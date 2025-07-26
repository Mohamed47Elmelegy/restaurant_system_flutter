import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/theme/theme_helper.dart';

class OrdersSection extends StatelessWidget {
  final String title;
  final int orderCount;

  const OrdersSection({
    super.key,
    required this.title,
    required this.orderCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 157.w,
      height: 115.h,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$orderCount', style: AppTextStyles.senBold52(context)),
            Text(
              title,
              style: AppTextStyles.senBold14(context).copyWith(
                fontSize: 13.sp,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
