import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormSectionWidget extends StatelessWidget {
  final Widget child;
  final double topSpacing;
  final double bottomSpacing;

  const FormSectionWidget({
    super.key,
    required this.child,
    this.topSpacing = 24,
    this.bottomSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: topSpacing.h),
        child,
        SizedBox(height: bottomSpacing.h),
      ],
    );
  }
}
