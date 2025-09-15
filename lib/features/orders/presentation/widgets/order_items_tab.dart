import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/theme_helper.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';

class OrderItemsTab extends StatelessWidget {
  final OrderEntity order;

  const OrderItemsTab({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Use real order items from the API
    if (order.items.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: order.items.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = order.items[index];
        return _buildOrderItem(context, item);
      },
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItemEntity item) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: ThemeHelper.getSecondaryTextColor(
                  context,
                ).withOpacity(0.1),
              ),
              child: item.image != null
                  ? Image.asset(
                      item.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.restaurant,
                        color: ThemeHelper.getSecondaryTextColor(context),
                        size: 24.sp,
                      ),
                    )
                  : Icon(
                      Icons.restaurant,
                      color: ThemeHelper.getSecondaryTextColor(context),
                      size: 24.sp,
                    ),
            ),
          ),
          SizedBox(width: 12.w),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyles.senBold16(
                    context,
                  ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                ),
                SizedBox(height: 4.h),
                if (item.specialInstructions != null) ...[
                  Text(
                    'ملاحظات: ${item.specialInstructions}',
                    style: AppTextStyles.senRegular12(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
                Row(
                  children: [
                    Text(
                      '${item.unitPrice.toStringAsFixed(2)} ر.س',
                      style: AppTextStyles.senMedium14(
                        context,
                      ).copyWith(color: AppColors.lightPrimary),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'الكمية: ${item.quantity}',
                        style: AppTextStyles.senMedium12(
                          context,
                        ).copyWith(color: AppColors.lightPrimary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Total Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.totalPrice.toStringAsFixed(2)} ر.س',
                style: AppTextStyles.senBold16(
                  context,
                ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_outlined,
              size: 80.sp,
              color: ThemeHelper.getSecondaryTextColor(context),
            ),
            SizedBox(height: 16.h),
            Text(
              'لا توجد أصناف في هذا الطلب',
              style: AppTextStyles.senBold16(
                context,
              ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'قد تكون البيانات لم تحمل بعد أو حدث خطأ في النظام',
              style: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
