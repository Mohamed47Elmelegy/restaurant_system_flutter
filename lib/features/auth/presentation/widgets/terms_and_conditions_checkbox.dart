import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_helper.dart';
import 'custom_checkbox.dart';

class TermsAndConditionsCheckbox extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const TermsAndConditionsCheckbox({super.key, required this.onChanged});

  @override
  TermsAndConditionsCheckboxState createState() =>
      TermsAndConditionsCheckboxState();
}

class TermsAndConditionsCheckboxState
    extends State<TermsAndConditionsCheckbox> {
  bool isTermsAccept = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCheckbox(
          onChecked: (value) {
            isTermsAccept = value;
            widget.onChanged(value);
            setState(() {});
          },
          isChecked: isTermsAccept,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: ThemeHelper.getSecondaryTextColor(context),
                fontSize: 14.sp,
              ),
              children: [
                const TextSpan(text: 'أوافق على '),
                TextSpan(
                  text: 'الشروط والأحكام',
                  style: TextStyle(
                    color: AppColors.lightPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' و '),
                TextSpan(
                  text: 'سياسة الخصوصية',
                  style: TextStyle(
                    color: AppColors.lightPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
