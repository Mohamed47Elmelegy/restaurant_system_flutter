import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_helper.dart';

class PlusButtonWidget extends StatelessWidget {
  const PlusButtonWidget({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: ThemeHelper.getPrimaryColorForTheme(context),
          shape: BoxShape.circle,
          boxShadow: ThemeHelper.getButtonShadow(context),
        ),
        child: Center(
          child: Icon(Icons.add, color: Colors.white, size: 24.sp, weight: 900),
        ),
      ),
    );
  }
}
