import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_enums.dart';
import '../widgets/order_info_tab.dart';
import '../widgets/order_items_tab.dart';
import '../widgets/order_receipt_tab.dart';
import '../widgets/order_tracking_tab.dart';
import '../widgets/status_chip.dart';

class OrderDetailsPage extends StatefulWidget {
  final OrderEntity order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildOrderHeader(context),
          _buildTabBar(context),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                OrderItemsTab(order: widget.order),
                OrderInfoTab(order: widget.order),
                OrderTrackingTab(order: widget.order),
                OrderReceiptTab(order: widget.order),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeHelper.getSurfaceColor(context),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'تفاصيل الطلب',
        style: AppTextStyles.senBold18(
          context,
        ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
      ),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back_ios,
          color: ThemeHelper.getPrimaryTextColor(context),
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طلب #${widget.order.id}',
                    style: AppTextStyles.senBold20(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _formatDate(widget.order.createdAt),
                    style: AppTextStyles.senRegular14(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                  ),
                ],
              ),
              StatusChip(status: widget.order.status),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                widget.order.type == OrderType.delivery
                    ? Icons.delivery_dining
                    : Icons.restaurant,
                color: AppColors.lightPrimary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                widget.order.type == OrderType.delivery
                    ? 'توصيل'
                    : 'داخل المطعم',
                style: AppTextStyles.senMedium14(
                  context,
                ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
              ),
              const Spacer(),
              Text(
                '${widget.order.totalAmount.toStringAsFixed(2)} EGP',
                style: AppTextStyles.senBold16(
                  context,
                ).copyWith(color: AppColors.lightPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        border: Border(
          bottom: BorderSide(
            color: ThemeHelper.getSecondaryTextColor(context).withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.lightPrimary,
        unselectedLabelColor: ThemeHelper.getSecondaryTextColor(context),
        indicatorColor: AppColors.lightPrimary,
        indicatorWeight: 2,
        labelStyle: AppTextStyles.senMedium12(context),
        unselectedLabelStyle: AppTextStyles.senRegular12(context),
        tabs: const [
          Tab(text: 'الأصناف'),
          Tab(text: 'معلومات'),
          Tab(text: 'التتبع'),
          Tab(text: 'الفاتورة'),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
