import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_enums.dart';
import 'status_chip.dart';

/// A card widget for displaying order information in lists
class OrderCardWidget extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const OrderCardWidget({
    super.key,
    required this.order,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: ThemeHelper.getCardBackgroundColor(context),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 12.h),
              _buildOrderInfo(context),
              if (order.type == OrderType.dineIn && order.table != null) ...[
                SizedBox(height: 8.h),
                _buildTableInfo(context),
              ],
              SizedBox(height: 12.h),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                'طلب #${order.id}',
                style: AppTextStyles.senBold16(
                  context,
                ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  order.typeDisplayName,
                  style: AppTextStyles.senMedium12(
                    context,
                  ).copyWith(color: AppColors.lightPrimary),
                ),
              ),
            ],
          ),
        ),
        StatusChip(status: order.status),
      ],
    );
  }

  Widget _buildOrderInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${order.items.length} منتج',
              style: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
            ),
            Text(
              '${order.totalAmount.toStringAsFixed(2)} ج.م',
              style: AppTextStyles.senBold16(
                context,
              ).copyWith(color: AppColors.lightPrimary),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          _formatDateTime(order.createdAt),
          style: AppTextStyles.senRegular12(
            context,
          ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
        ),
      ],
    );
  }

  Widget _buildTableInfo(BuildContext context) {
    if (order.table == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.table_restaurant,
            size: 16.sp,
            color: ThemeHelper.getSecondaryTextColor(context),
          ),
          SizedBox(width: 8.w),
          Text(
            'طاولة ${order.table!.number}',
            style: AppTextStyles.senMedium12(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildProgressIndicator(context),
        if (onEdit != null)
          TextButton.icon(
            onPressed: onEdit,
            icon: Icon(Icons.edit, size: 16.sp, color: AppColors.lightPrimary),
            label: Text(
              'تعديل',
              style: AppTextStyles.senMedium14(
                context,
              ).copyWith(color: AppColors.lightPrimary),
            ),
          ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    if (order.isFinalStatus) {
      return const SizedBox.shrink();
    }

    final progress = order.progressPercentage;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تقدم الطلب',
            style: AppTextStyles.senRegular12(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
          ),
          SizedBox(height: 4.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: ThemeHelper.getSecondaryTextColor(
              context,
            ).withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.lightPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '${(progress * 100).toInt()}%',
            style: AppTextStyles.senMedium12(
              context,
            ).copyWith(color: AppColors.lightPrimary),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}
