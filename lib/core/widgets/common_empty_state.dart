import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import '../theme/theme_helper.dart';

/// نموذج موحد لعرض الحالات الفارغة
class CommonEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionButtonText;
  final VoidCallback? onActionPressed;
  final Color? iconColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final double? iconSize;
  final Widget? customAction;

  const CommonEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionButtonText,
    this.onActionPressed,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
    this.iconSize,
    this.customAction,
  });

  /// Empty state للطلبات
  const CommonEmptyState.orders({super.key, this.onActionPressed})
    : icon = Icons.shopping_cart_outlined,
      title = 'لا توجد طلبات',
      subtitle = 'عندما تقوم بطلب شيء، ستظهر هنا',
      actionButtonText = 'ابدأ الطلب',
      iconColor = null,
      titleColor = null,
      subtitleColor = null,
      iconSize = null,
      customAction = null;

  /// Empty state للعناوين
  const CommonEmptyState.addresses({super.key, this.onActionPressed})
    : icon = Icons.location_off,
      title = 'لا توجد عناوين محفوظة',
      subtitle = 'يجب إضافة عنوان واحد على الأقل للمتابعة',
      actionButtonText = 'إضافة عنوان جديد',
      iconColor = null,
      titleColor = null,
      subtitleColor = null,
      iconSize = null,
      customAction = null;

  /// Empty state للسلة
  const CommonEmptyState.cart({super.key, this.onActionPressed})
    : icon = Icons.shopping_bag_outlined,
      title = 'السلة فارغة',
      subtitle = 'لم تقم بإضافة أي منتجات للسلة بعد',
      actionButtonText = 'ابدأ التسوق',
      iconColor = null,
      titleColor = null,
      subtitleColor = null,
      iconSize = null,
      customAction = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Icon(
              icon,
              size: iconSize ?? 80.sp,
              color:
                  iconColor ??
                  ThemeHelper.getSecondaryTextColor(
                    context,
                  ).withValues(alpha: 0.5),
            ),
            SizedBox(height: 24.h),

            // Title
            Text(
              title,
              style: AppTextStyles.senBold18(context).copyWith(
                color: titleColor ?? ThemeHelper.getPrimaryTextColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),

            // Subtitle
            Text(
              subtitle,
              style: AppTextStyles.senRegular14(context).copyWith(
                color:
                    subtitleColor ?? ThemeHelper.getSecondaryTextColor(context),
              ),
              textAlign: TextAlign.center,
            ),

            // Action Button or Custom Action
            if (customAction != null) ...[
              SizedBox(height: 32.h),
              customAction!,
            ] else if (actionButtonText != null && onActionPressed != null) ...[
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPrimary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  actionButtonText!,
                  style: AppTextStyles.senMedium14(
                    context,
                  ).copyWith(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// نموذج مبسط للحالات الفارغة
class CommonEmptyStateSimple extends StatelessWidget {
  final String message;
  final IconData? icon;

  const CommonEmptyStateSimple({super.key, required this.message, this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 60.sp,
              color: ThemeHelper.getSecondaryTextColor(
                context,
              ).withValues(alpha: 0.5),
            ),
            SizedBox(height: 16.h),
          ],
          Text(
            message,
            style: AppTextStyles.senRegular16(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
