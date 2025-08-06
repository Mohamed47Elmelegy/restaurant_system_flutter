import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_helper.dart';

class AccountCreationPrompt extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String buttonText;

  const AccountCreationPrompt({
    super.key,
    required this.onPressed,
    required this.text,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: ThemeHelper.getSecondaryTextColor(context),
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(
              color: AppColors.lightPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
