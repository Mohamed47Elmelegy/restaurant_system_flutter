import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../domain/entities/checkout_step_entity.dart';

/// 🟦 CheckoutStepWrapper - Wraps each checkout step with consistent UI
class CheckoutStepWrapper extends StatelessWidget {
  final CheckoutStepEntity step;
  final Widget child;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool showNavigation;
  final String? nextButtonText;
  final String? previousButtonText;
  final bool isLoading;

  const CheckoutStepWrapper({
    super.key,
    required this.step,
    required this.child,
    this.onNext,
    this.onPrevious,
    this.showNavigation = true,
    this.nextButtonText,
    this.previousButtonText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(context),
          SizedBox(height: 20.h),
          Expanded(child: child),
          if (showNavigation) ...[
            SizedBox(height: 20.h),
            _buildNavigationButtons(context),
          ],
        ],
      ),
    );
  }

  Widget _buildStepHeader(BuildContext context) {
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
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: step.isCompleted
                      ? AppColors.lightPrimary
                      : AppColors.lightPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step.isCompleted ? Icons.check : _getStepIcon(),
                  color: step.isCompleted
                      ? Colors.white
                      : AppColors.lightPrimary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: AppTextStyles.senBold16(context).copyWith(
                        color: ThemeHelper.getPrimaryTextColor(context),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      step.description,
                      style: AppTextStyles.senRegular14(context).copyWith(
                        color: ThemeHelper.getSecondaryTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Row(
      children: [
        if (onPrevious != null)
          Expanded(
            child: OutlinedButton(
              onPressed: isLoading ? null : onPrevious,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: ThemeHelper.getPrimaryTextColor(context),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                previousButtonText ?? 'السابق',
                style: AppTextStyles.senMedium16(
                  context,
                ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
              ),
            ),
          ),
        if (onPrevious != null && onNext != null) SizedBox(width: 16.w),
        if (onNext != null)
          Expanded(
            flex: onPrevious != null ? 1 : 2,
            child: ElevatedButton(
              onPressed: isLoading ? null : onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPrimary,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      nextButtonText ?? 'التالي',
                      style: AppTextStyles.senMedium16(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
            ),
          ),
      ],
    );
  }

  IconData _getStepIcon() {
    switch (step.type) {
      case CheckoutStepType.orderType:
        return Icons.restaurant_menu;
      case CheckoutStepType.addressSelection:
        return Icons.location_on;
      case CheckoutStepType.tableSelection:
        return Icons.table_restaurant;
      case CheckoutStepType.orderReview:
        return Icons.receipt_long;
      case CheckoutStepType.paymentMethod:
        return Icons.payment;
      case CheckoutStepType.confirmation:
        return Icons.check_circle;
    }
  }
}
