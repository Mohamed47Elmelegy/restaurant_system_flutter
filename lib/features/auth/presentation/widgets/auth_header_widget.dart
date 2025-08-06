import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';

class AuthHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo or Icon
        Container(
          width: 120.w,
          height: 120.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.lightPrimary, AppColors.lightSecondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: AppColors.lightPrimary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.restaurant, size: 60, color: Colors.white),
        ),

        const SizedBox(height: 32),

        // Welcome Text
        Text(
          title,
          style: AppTextStyles.senBold22(context).copyWith(
            color: ThemeHelper.getPrimaryTextColor(context),
            fontSize: 30.sp,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        // Subtitle
        Text(
          subtitle,
          style: AppTextStyles.senRegular14(context).copyWith(
            color: ThemeHelper.getSecondaryTextColor(context),
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
