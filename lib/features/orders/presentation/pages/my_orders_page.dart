import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_helper.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/order_entity.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import 'order_details_page.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrderBloc>()..add(const LoadAllOrders()),
      child: Scaffold(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        appBar: AppBar(
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
        ),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.lightPrimary),
              );
            } else if (state is AllOrdersLoaded) {
              if (state.orders.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildOrdersList(context, state.orders);
            } else if (state is OrderError) {
              return _buildErrorState(context, state.message);
            }
            return _buildEmptyState(context);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80.sp,
            color: ThemeHelper.getSecondaryTextColor(context),
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد طلبات حتى الآن',
            style: AppTextStyles.senBold16(
              context,
            ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          ),
          SizedBox(height: 8.h),
          Text(
            'ابدأ بطلب طعامك المفضل',
            style: AppTextStyles.senRegular14(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, List<OrderEntity> orders) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(context, order);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderEntity order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(order: order),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ThemeHelper.getCardBackgroundColor(context),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: ThemeHelper.getCardShadow(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طلب #${order.id}',
                  style: AppTextStyles.senBold16(
                    context,
                  ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                ),
                _buildStatusChip(context, order.status),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  order.type == OrderType.delivery
                      ? Icons.delivery_dining
                      : Icons.restaurant,
                  color: AppColors.lightPrimary,
                  size: 16.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  order.type == OrderType.delivery ? 'توصيل' : 'داخل المطعم',
                  style: AppTextStyles.senRegular12(
                    context,
                  ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
                ),
                SizedBox(width: 8.w),
                Text(
                  '• ${_formatDate(order.createdAt)}',
                  style: AppTextStyles.senRegular12(
                    context,
                  ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.items.length} صنف',
                  style: AppTextStyles.senRegular12(
                    context,
                  ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
                ),
                Text(
                  '${order.totalAmount.toStringAsFixed(2)} EGP',
                  style: AppTextStyles.senBold14(
                    context,
                  ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                ),
              ],
            ),
            if (_canEditOrder(order)) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _editOrder(context, order),
                      icon: Icon(
                        order.type == OrderType.dineIn
                            ? Icons.add_shopping_cart
                            : Icons.edit,
                        color: AppColors.lightPrimary,
                        size: 16.sp,
                      ),
                      label: Text(
                        order.type == OrderType.dineIn
                            ? 'إضافة منتجات'
                            : 'تعديل الطلب',
                        style: AppTextStyles.senMedium14(
                          context,
                        ).copyWith(color: AppColors.lightPrimary),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.lightPrimary),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, OrderStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case OrderStatus.pending:
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        text = 'في الانتظار';
        break;
      case OrderStatus.paid:
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        text = 'مدفوع';
        break;
      case OrderStatus.preparing:
        backgroundColor = AppColors.lightPrimary.withOpacity(0.1);
        textColor = AppColors.lightPrimary;
        text = 'قيد التحضير';
        break;
      case OrderStatus.delivering:
        backgroundColor = Colors.purple.withOpacity(0.1);
        textColor = Colors.purple;
        text = 'في الطريق';
        break;
      case OrderStatus.completed:
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        text = 'مكتمل';
        break;
      case OrderStatus.cancelled:
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        text = 'ملغي';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: AppTextStyles.senMedium12(context).copyWith(color: textColor),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            'حدث خطأ',
            style: AppTextStyles.senBold16(
              context,
            ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: AppTextStyles.senRegular14(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Check if order can be edited
  bool _canEditOrder(OrderEntity order) {
    if (order.type == OrderType.delivery) {
      // For delivery orders: can edit if pending or paid (not preparing or delivering yet)
      return order.status == OrderStatus.pending ||
          order.status == OrderStatus.paid;
    } else {
      // For dine-in orders: can edit until being prepared
      // They can keep adding items before preparation starts
      return order.status == OrderStatus.pending ||
          order.status == OrderStatus.paid;
    }
  }

  /// Navigate to edit order page
  void _editOrder(BuildContext context, OrderEntity order) {
    final String title = order.type == OrderType.dineIn
        ? 'إضافة منتجات للطلب #${order.id}'
        : 'تعديل الطلب #${order.id}';

    final String content = order.type == OrderType.dineIn
        ? 'يمكنك إضافة المزيد من المنتجات لطلبك قبل الدفع النهائي.\nميزة إضافة المنتجات قيد التطوير...'
        : 'يمكنك تعديل طلب التوصيل قبل خروجه للتوصيل.\nميزة تعديل الطلب قيد التطوير...';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
