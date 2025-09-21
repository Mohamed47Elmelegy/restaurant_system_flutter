import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import '../theme/theme_helper.dart';

/// نموذج موحد لعرض حالات التحميل
class CommonLoadingWidget extends StatelessWidget {
  final String? message;
  final double? size;
  final Color? color;
  final bool showMessage;

  const CommonLoadingWidget({
    super.key,
    this.message,
    this.size,
    this.color,
    this.showMessage = false,
  });

  const CommonLoadingWidget.withMessage(
    String this.message, {
    super.key,
    this.size,
    this.color,
  }) : showMessage = true;

  const CommonLoadingWidget.small({super.key, this.message, this.color})
    : size = 20.0,
      showMessage = false;

  const CommonLoadingWidget.large({super.key, this.message, this.color})
    : size = 40.0,
      showMessage = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size ?? 24.w,
            height: size ?? 24.h,
            child: CircularProgressIndicator(
              color: color ?? AppColors.lightPrimary,
              strokeWidth: (size ?? 24) > 30 ? 3.0 : 2.0,
            ),
          ),
          if (showMessage && message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message!,
              style: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// نموذج للتحميل في الصف
class CommonLoadingRow extends StatelessWidget {
  final String message;
  final double? iconSize;

  const CommonLoadingRow({super.key, required this.message, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: iconSize ?? 20.w,
          height: iconSize ?? 20.h,
          child: const CircularProgressIndicator(
            color: AppColors.lightPrimary,
            strokeWidth: 2.0,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          message,
          style: AppTextStyles.senRegular14(
            context,
          ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
        ),
      ],
    );
  }
}
