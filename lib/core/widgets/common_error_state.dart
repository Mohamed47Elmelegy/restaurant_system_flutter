import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import '../theme/theme_helper.dart';

/// نموذج موحد لعرض حالات الخطأ
class CommonErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final IconData? icon;
  final Color? iconColor;
  final Color? titleColor;
  final String? title;

  const CommonErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.retryButtonText,
    this.icon,
    this.iconColor,
    this.titleColor,
    this.title,
  });

  /// خطأ الشبكة
  const CommonErrorState.network({
    super.key,
    this.onRetry,
    this.retryButtonText,
  }) : message = 'لا يوجد اتصال بالإنترنت',
       icon = Icons.wifi_off,
       iconColor = AppColors.error,
       titleColor = AppColors.error,
       title = 'خطأ في الاتصال';

  /// خطأ الخادم
  const CommonErrorState.server({super.key, this.onRetry, this.retryButtonText})
    : message = 'حدث خطأ في الخادم، يرجى المحاولة لاحقاً',
      icon = Icons.error_outline,
      iconColor = AppColors.error,
      titleColor = AppColors.error,
      title = 'خطأ في الخادم';

  /// خطأ عام
  const CommonErrorState.general({
    super.key,
    required this.message,
    this.onRetry,
    this.retryButtonText,
  }) : icon = Icons.error_outline,
       iconColor = AppColors.error,
       titleColor = AppColors.error,
       title = 'حدث خطأ';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            Icon(
              icon ?? Icons.error_outline,
              size: 80.sp,
              color: iconColor ?? AppColors.error,
            ),
            SizedBox(height: 24.h),

            // Title
            if (title != null) ...[
              Text(
                title!,
                style: AppTextStyles.senBold18(
                  context,
                ).copyWith(color: titleColor ?? AppColors.error),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
            ],

            // Error Message
            Text(
              message,
              style: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
              textAlign: TextAlign.center,
            ),

            // Retry Button
            if (onRetry != null) ...[
              SizedBox(height: 32.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  retryButtonText ?? 'إعادة المحاولة',
                  style: AppTextStyles.senMedium14(
                    context,
                  ).copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// نموذج مبسط لعرض الأخطاء في الصف
class CommonErrorRow extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryText;

  const CommonErrorRow({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.error_outline, color: AppColors.error, size: 20.sp),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            message,
            style: AppTextStyles.senRegular14(
              context,
            ).copyWith(color: AppColors.error),
          ),
        ),
        if (onRetry != null) ...[
          SizedBox(width: 8.w),
          TextButton(
            onPressed: onRetry,
            child: Text(
              retryText ?? 'إعادة المحاولة',
              style: AppTextStyles.senMedium12(
                context,
              ).copyWith(color: AppColors.error),
            ),
          ),
        ],
      ],
    );
  }
}
