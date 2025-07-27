import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/theme/text_styles.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../../domain/entities/order_entity.dart';

class OrdersBottomSheet extends StatelessWidget {
  final String title;
  final String orderType; // 'running' or 'new'

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
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Text(title, style: AppTextStyles.senBold22(context)),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Orders list
          Expanded(
            child: BlocConsumer<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is OrderActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Refresh orders after successful action
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      context.read<OrderBloc>().add(
                        orderType == 'running'
                            ? const LoadRunningOrders()
                            : const LoadNewOrders(),
                      );
                    }
                  });
                } else if (state is OrderError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is OrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RunningOrdersLoaded &&
                    orderType == 'running') {
                  return _buildOrdersList(context, state.orders);
                } else if (state is NewOrdersLoaded && orderType == 'new') {
                  return _buildOrdersList(context, state.orders);
                } else if (state is OrderError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 48.sp,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No orders found',
                          style: AppTextStyles.senRegular14(
                            context,
                          ).copyWith(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Pull down to refresh',
                          style: AppTextStyles.senRegular14(
                            context,
                          ).copyWith(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, List<OrderEntity> orders) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<OrderBloc>().add(
          orderType == 'running'
              ? const LoadRunningOrders()
              : const LoadNewOrders(),
        );
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderItem(context, order);
        },
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderEntity order) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Image placeholder
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: order.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      order.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.fastfood,
                          color: Colors.grey[400],
                          size: 24.sp,
                        );
                      },
                    ),
                  )
                : Icon(Icons.fastfood, color: Colors.grey[400], size: 24.sp),
          ),

          SizedBox(width: 12.w),

          // Order details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: ThemeHelper.getPrimaryColorForTheme(
                      context,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '#${order.category}',
                    style: AppTextStyles.senRegular14(context).copyWith(
                      color: ThemeHelper.getPrimaryColorForTheme(context),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                // Order name
                Text(
                  order.name,
                  style: AppTextStyles.senBold14(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 2.h),

                // Order ID
                Text(
                  'ID: ${order.id}',
                  style: AppTextStyles.senRegular14(context).copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),

                SizedBox(height: 2.h),

                // Price
                Text(
                  '\$${order.price.toStringAsFixed(0)}',
                  style: AppTextStyles.senBold14(context).copyWith(
                    color: ThemeHelper.getPrimaryColorForTheme(context),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Action buttons
          Column(
            children: [
              // Done button
              SizedBox(
                width: 60.w,
                height: 32.h,
                child: ElevatedButton(
                  onPressed: () {
                    // Show loading state
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Processing...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    context.read<OrderBloc>().add(MarkOrderAsDone(order.id));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeHelper.getPrimaryColorForTheme(
                      context,
                    ),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Done',
                    style: AppTextStyles.senBold14(
                      context,
                    ).copyWith(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // Cancel button
              SizedBox(
                width: 60.w,
                height: 32.h,
                child: OutlinedButton(
                  onPressed: () {
                    // Show loading state
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Processing...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    context.read<OrderBloc>().add(CancelOrder(order.id));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.senBold14(
                      context,
                    ).copyWith(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
