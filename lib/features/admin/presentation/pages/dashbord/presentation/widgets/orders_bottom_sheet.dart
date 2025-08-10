import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/text_styles.dart';
import '../../../../../../../core/theme/theme_helper.dart';
import '../../../../../../orders/domain/entities/order_entity.dart';
import '../../../../../../orders/presentation/bloc/order_bloc.dart';
import '../../../../../../orders/presentation/bloc/order_event.dart';
import '../../../../../../orders/presentation/bloc/order_state.dart';

class OrdersBottomSheet extends StatelessWidget {
  final String title;
  final String orderType;

  const OrdersBottomSheet({
    super.key,
    required this.title,
    required this.orderType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RunningOrdersLoaded ||
                    state is NewOrdersLoaded) {
                  final orders = state is RunningOrdersLoaded
                      ? state.orders
                      : (state as NewOrdersLoaded).orders;
                  return _buildOrdersList(context, orders);
                } else if (state is OrderError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: ThemeHelper.getErrorColor(context),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Error loading orders',
                          style: AppTextStyles.senBold22(context),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          state.message,
                          style: AppTextStyles.senRegular14(context).copyWith(
                            color: ThemeHelper.getSecondaryTextColor(context),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('No orders found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.senBold22(context))),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: ThemeHelper.getSecondaryTextColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, List<OrderEntity> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: ThemeHelper.getSecondaryTextColor(context),
            ),
            SizedBox(height: 16.h),
            Text('No orders found', style: AppTextStyles.senBold22(context)),
            SizedBox(height: 8.h),
            Text(
              'There are no ${orderType.toLowerCase()} orders at the moment',
              style: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(context, order);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderEntity order) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeHelper.getDividerColor(context),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.orderNumber, style: AppTextStyles.senBold14(context)),
                    SizedBox(height: 4.h),
                    Text(
                      order.totalAmount.toString(),
                      style: AppTextStyles.senRegular14(context).copyWith(
                        color: ThemeHelper.getSecondaryTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${order.totalAmount.toStringAsFixed(2)}',
                style: AppTextStyles.senBold14(
                  context,
                ).copyWith(color: AppColors.lightPrimary),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: ThemeHelper.getSecondaryTextColor(context),
              ),
              SizedBox(width: 8.w),
              Text(
                _formatDateTime(order.createdAt),
                style: AppTextStyles.senRegular14(context).copyWith(
                  color: ThemeHelper.getSecondaryTextColor(context),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: AppTextStyles.senBold14(context).copyWith(
                    color: _getStatusColor(order.status),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<OrderBloc>().add(MarkOrderAsDone(order.id));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'Mark Done',
                    style: AppTextStyles.senBold14(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<OrderBloc>().add(CancelOrder(order.id));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ThemeHelper.getErrorColor(context),
                    side: BorderSide(color: ThemeHelper.getErrorColor(context)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.senBold14(
                      context,
                    ).copyWith(color: ThemeHelper.getErrorColor(context)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'running':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
