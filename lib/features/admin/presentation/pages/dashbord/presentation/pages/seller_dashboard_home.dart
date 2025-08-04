import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/utils/app_bar_helper.dart';
import '../../../../../../../core/utils/responsive_helper.dart';
import '../../../../../../orders/data/repositories/order_repository_impl.dart';
import '../../../../../../orders/domain/entities/order_entity.dart';
import '../../../../../../orders/domain/usecases/get_running_orders_usecase.dart';
import '../../../../../../orders/domain/usecases/mark_order_done_usecase.dart';
import '../../../../../../orders/domain/usecases/cancel_order_usecase.dart';
import '../../../../../../orders/presentation/bloc/order_bloc.dart';
import '../../../../../../orders/presentation/bloc/order_event.dart';
import '../../../../../../orders/presentation/bloc/order_state.dart';
import '../widgets/orders_section.dart';
import '../widgets/popular_items_section.dart';
import '../widgets/revenue_section.dart';
import '../widgets/reviews_section.dart';

class SellerDashboardHome extends StatefulWidget {
  const SellerDashboardHome({super.key});

  @override
  State<SellerDashboardHome> createState() => _SellerDashboardHomeState();
}

class _SellerDashboardHomeState extends State<SellerDashboardHome> {
  late OrderBloc _orderBloc;
  List<OrderEntity> allOrders = [];
  final OrderRepositoryImpl _orderRepository = OrderRepositoryImpl();

  @override
  void initState() {
    super.initState();
    _orderBloc = OrderBloc(
      getRunningOrdersUseCase: GetRunningOrdersUseCase(_orderRepository),
      markOrderDoneUseCase: MarkOrderDoneUseCase(_orderRepository),
      cancelOrderUseCase: CancelOrderUseCase(_orderRepository),
    );

    // تحميل الطلبات النشطة والجديدة والمكتملة
    _loadAllOrders();
  }

  Future<void> _loadAllOrders() async {
    // تحميل الطلبات النشطة والجديدة
    _orderBloc.add(const LoadRunningOrders());
    _orderBloc.add(const LoadNewOrders());

    // تحميل الطلبات المكتملة للإيرادات
    try {
      final completedOrders = await _orderRepository.getCompletedOrders();
      setState(() {
        allOrders.addAll(completedOrders);
      });
    } catch (e) {
      print('Error loading completed orders: $e');
    }
  }

  @override
  void dispose() {
    _orderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarHelper.appBar(title: 'Seller Dashboard'),
      body: ResponsiveHelper.responsiveLayout(
        builder: (context, constraints) {
          return BlocProvider(
            create: (context) => _orderBloc,
            child: BlocListener<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is RunningOrdersLoaded) {
                  setState(() {
                    allOrders.addAll(state.orders);
                  });
                } else if (state is NewOrdersLoaded) {
                  setState(() {
                    allOrders.addAll(state.orders);
                  });
                }
              },
              child: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        spacing: 16.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ReviewsSection(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OrdersSection(
                                title: 'ActiveOrders ',
                                orderCount: 20,
                              ),
                              OrdersSection(
                                title: 'New Orders ',
                                orderCount: 10,
                              ),
                            ],
                          ),

                          RevenueSection(orders: allOrders),
                          PopularItemsSection(),
                          // Add other sections here
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
