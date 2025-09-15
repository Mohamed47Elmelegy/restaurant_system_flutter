import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../domain/entities/checkout_process_entity.dart';
import '../../domain/entities/checkout_step_entity.dart';

/// 🟦 CheckoutProgressIndicator - Modern step progress widget
class CheckoutProgressIndicator extends StatelessWidget {
  final CheckoutProcessEntity process;
  final VoidCallback? onStepTap;

  const CheckoutProgressIndicator({
    super.key,
    required this.process,
    this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        children: [
          _buildProgressBar(context),
          SizedBox(height: 16.h),
          _buildStepsList(context),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'تقدم عملية الشراء',
              style: AppTextStyles.senBold16(context).copyWith(
                color: ThemeHelper.getPrimaryTextColor(context),
              ),
            ),
            Text(
              '${(process.progressPercentage * 100).toInt()}%',
              style: AppTextStyles.senMedium14(context).copyWith(
                color: AppColors.lightPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        LinearProgressIndicator(
          value: process.progressPercentage,
          backgroundColor: ThemeHelper.getSecondaryTextColor(context).withOpacity(0.1),
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.lightPrimary),
          minHeight: 6.h,
        ),
      ],
    );
  }

  Widget _buildStepsList(BuildContext context) {
    return Row(
      children: process.steps
          .asMap()
          .entries
          .where((entry) => entry.value.isEnabled)
          .map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == process.steps.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: _buildStepItem(context, step, index),
              ),
              if (!isLast) _buildConnector(context, step),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStepItem(BuildContext context, CheckoutStepEntity step, int index) {
    final isActive = step.isActive;
    final isCompleted = step.isCompleted;
    final isEnabled = step.isEnabled;

    Color circleColor;
    Color textColor;
    Widget circleChild;

    if (isCompleted) {
      circleColor = AppColors.lightPrimary;
      textColor = AppColors.lightPrimary;
      circleChild = Icon(Icons.check, color: Colors.white, size: 12.sp);
    } else if (isActive) {
      circleColor = AppColors.lightPrimary;
      textColor = AppColors.lightPrimary;
      circleChild = Text(
        '${index + 1}',
        style: AppTextStyles.senBold14(context).copyWith(color: Colors.white),
      );
    } else if (isEnabled) {
      circleColor = ThemeHelper.getSecondaryTextColor(context).withOpacity(0.3);
      textColor = ThemeHelper.getSecondaryTextColor(context);
      circleChild = Text(
        '${index + 1}',
        style: AppTextStyles.senMedium12(context).copyWith(color: textColor),
      );
    } else {
      circleColor = ThemeHelper.getSecondaryTextColor(context).withOpacity(0.1);
      textColor = ThemeHelper.getSecondaryTextColor(context).withOpacity(0.5);
      circleChild = Text(
        '${index + 1}',
        style: AppTextStyles.senMedium12(context).copyWith(color: textColor),
      );
    }

    return GestureDetector(
      onTap: isEnabled && onStepTap != null ? onStepTap : null,
      child: Column(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: isActive
                  ? Border.all(color: AppColors.lightPrimary, width: 2)
                  : null,
            ),
            child: Center(child: circleChild),
          ),
          SizedBox(height: 4.h),
          Text(
            step.title,
            style: AppTextStyles.senMedium14(context).copyWith(fontSize: 12.sp,color: textColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildConnector(BuildContext context, CheckoutStepEntity step) {
    return Container(
      height: 2.h,
      width: 16.w,
      margin: EdgeInsets.only(bottom: 20.h),
      color: step.isCompleted
          ? AppColors.lightPrimary
          : ThemeHelper.getSecondaryTextColor(context).withOpacity(0.2),
    );
  }
}