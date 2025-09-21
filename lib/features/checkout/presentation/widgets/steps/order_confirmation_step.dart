import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/theme/theme_helper.dart';
import '../../../../orders/domain/entities/order_enums.dart';
import '../../../domain/entities/checkout_process_entity.dart';

/// 🟦 OrderConfirmationStep - Final order confirmation step
class OrderConfirmationStep extends StatelessWidget {
  final CheckoutProcessEntity process;

  const OrderConfirmationStep({super.key, required this.process});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تأكيد الطلب',
          style: AppTextStyles.senBold18(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        SizedBox(height: 8.h),
        Text(
          'راجع جميع تفاصيل طلبك قبل التأكيد النهائي',
          style: AppTextStyles.senRegular14(
            context,
          ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildOrderTypeCard(context),
                SizedBox(height: 16.h),
                if (process.checkoutData.orderType == OrderType.delivery)
                  _buildDeliveryInfoCard(context),
                if (process.checkoutData.orderType == OrderType.dineIn)
                  _buildDineInInfoCard(context),
                SizedBox(height: 16.h),
                _buildPaymentInfoCard(context),
                SizedBox(height: 16.h),
                _buildOrderSummaryCard(context),
                if (process.checkoutData.notes?.isNotEmpty == true) ...[
                  SizedBox(height: 16.h),
                  _buildNotesCard(context),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderTypeCard(BuildContext context) {
    final orderType = process.checkoutData.orderType;
    final isDelivery = orderType == OrderType.delivery;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              isDelivery ? Icons.delivery_dining : Icons.restaurant,
              color: AppColors.lightPrimary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نوع الطلب',
                  style: AppTextStyles.senMedium14(
                    context,
                  ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
                ),
                Text(
                  isDelivery ? 'توصيل' : 'داخل المطعم',
                  style: AppTextStyles.senBold16(
                    context,
                  ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfoCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.location_on,
              color: AppColors.lightPrimary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'عنوان التوصيل',
                  style: AppTextStyles.senMedium14(
                    context,
                  ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
                ),
                Text(
                  process.checkoutData.deliveryAddress ?? 'غير محدد',
                  style: AppTextStyles.senBold14(
                    context,
                  ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDineInInfoCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.table_restaurant,
              color: AppColors.lightPrimary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رقم الطاولة',
                  style: AppTextStyles.senMedium14(
                    context,
                  ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
                ),
                Text(
                  process.checkoutData.selectedTableId?.toString() ??
                      'غير محدد',
                  style: AppTextStyles.senBold16(
                    context,
                  ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfoCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.payment,
              color: AppColors.lightPrimary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'طريقة الدفع',
                  style: AppTextStyles.senMedium14(
                    context,
                  ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
                ),
                Text(
                  _getPaymentMethodDisplayName(
                    process.checkoutData.selectedPaymentMethod,
                  ),
                  style: AppTextStyles.senBold16(
                    context,
                  ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard(BuildContext context) {
    return Container(
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
            children: [
              Icon(
                Icons.receipt_long,
                color: AppColors.lightPrimary,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'ملخص الطلب',
                style: AppTextStyles.senBold16(
                  context,
                ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'عدد الأصناف: ${process.cart.uniqueItemsCount}',
            style: AppTextStyles.senRegular14(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
          ),
          Text(
            'إجمالي الكمية: ${process.cart.totalItemsCount}',
            style: AppTextStyles.senRegular14(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
          ),
          SizedBox(height: 8.h),
          Divider(
            color: ThemeHelper.getSecondaryTextColor(
              context,
            ).withValues(alpha: 0.2),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع الكلي',
                style: AppTextStyles.senBold16(
                  context,
                ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
              ),
              Text(
                '${process.cart.subtotal.toStringAsFixed(2)} ج.م',
                style: AppTextStyles.senBold18(
                  context,
                ).copyWith(color: AppColors.lightPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    return Container(
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
            children: [
              Icon(Icons.note, color: AppColors.lightPrimary, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'ملاحظات خاصة',
                style: AppTextStyles.senBold16(
                  context,
                ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            process.checkoutData.notes!,
            style: AppTextStyles.senRegular14(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodDisplayName(String? paymentMethod) {
    switch (paymentMethod) {
      case 'cash':
        return 'نقداً';
      case 'credit_card':
        return 'بطاقة ائتمان';
      case 'digital_wallet':
        return 'محفظة رقمية';
      default:
        return 'غير محدد';
    }
  }
}
