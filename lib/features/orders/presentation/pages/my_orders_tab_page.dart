import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/empty_page.dart';
import '../../../../core/constants/order_tab_constants.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/order_editing_dialog_manager.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../domain/entities/order_entity.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../widgets/orders_error_state.dart';
import '../widgets/orders_loading_state.dart';
import '../widgets/orders_tab_view.dart';
import 'order_details_page.dart';

/// Refactored orders page with clean architecture
class MyOrdersTabPage extends StatefulWidget {
  const MyOrdersTabPage({super.key});

  @override
  State<MyOrdersTabPage> createState() => _MyOrdersTabPageState();
}

class _MyOrdersTabPageState extends State<MyOrdersTabPage>
    with TickerProviderStateMixin {
  // Controllers and services
  late TabController _tabController;
  late OrderBloc _orderBloc;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadOrders();
  }

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  /// Initialize controllers and services
  void _initializeControllers() {
    _tabController = TabController(
      length: OrderTabConstants.tabCount,
      vsync: this,
    );
    _orderBloc = getIt<OrderBloc>();
  }

  /// Load initial orders
  void _loadOrders() {
    _orderBloc.add(const LoadAllOrders());
  }

  /// Dispose resources
  void _disposeResources() {
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _orderBloc,
      child: Scaffold(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        appBar: _buildAppBar(context),
        body: _buildBody(),
        floatingActionButton: _buildRefreshButton(),
      ),
    );
  }

  /// Build app bar with tabs
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeHelper.getSurfaceColor(context),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'طلباتي',
        style: AppTextStyles.senBold18(
          context,
        ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
      ),
      automaticallyImplyLeading: false,
      bottom: TabBar(
        controller: _tabController,
        labelColor: AppColors.lightPrimary,
        unselectedLabelColor: ThemeHelper.getSecondaryTextColor(context),
        indicatorColor: AppColors.lightPrimary,
        indicatorWeight: 3.h,
        labelStyle: AppTextStyles.senMedium14(context),
        unselectedLabelStyle: AppTextStyles.senRegular14(context),
        tabs: OrderTabConstants.tabs,
      ),
    );
  }

  /// Build body with state management
  Widget _buildBody() {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return OrdersLoadingState(
            tabController: _tabController,
            onRefresh: _handleRefresh,
            onOrderTap: _handleOrderTap,
            onOrderEdit: _handleOrderEdit,
          );
        } else if (state is AllOrdersLoaded) {
          return OrdersTabView(
            tabController: _tabController,
            orders: state.orders,
            onRefresh: _handleRefresh,
            onOrderTap: _handleOrderTap,
            onOrderEdit: _handleOrderEdit,
          );
        } else if (state is OrderError) {
          return OrdersErrorState(
            message: state.message,
            onRetry: _handleRefresh,
          );
        }
        return _buildInitialEmptyState();
      },
    );
  }

  /// Build refresh floating action button
  Widget _buildRefreshButton() {
    return FloatingActionButton(
      onPressed: _handleRefresh,
      backgroundColor: AppColors.lightPrimary,
      child: const Icon(Icons.refresh, color: Colors.white),
    );
  }

  /// Build initial empty state
  Widget _buildInitialEmptyState() {
    return EmptyPagePresets.noOrders(
      context,
      onAction: () => Navigator.pushNamed(context, AppRoutes.mainLayout),
    );
  }

  // Event handlers

  /// Handle refresh action
  void _handleRefresh() {
    _orderBloc.add(const LoadAllOrders());
  }

  /// Handle order tap
  void _handleOrderTap(BuildContext context, OrderEntity order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailsPage(order: order)),
    );
  }

  /// Handle order edit
  void _handleOrderEdit(BuildContext context, OrderEntity order) {
    OrderEditingDialogManager.showEditOrderDialog(context, order);
  }
}
