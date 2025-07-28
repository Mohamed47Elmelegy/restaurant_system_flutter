import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/theme_helper.dart';

class SaveButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SaveButtonWidget({
    super.key,
    required this.onPressed,
    this.text = 'SAVE CHANGES',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        color: ThemeHelper.getPrimaryColorForTheme(context),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ThemeHelper.getPrimaryColorForTheme(
              context,
            ).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: ThemeHelper.getPrimaryTextColor(context),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
