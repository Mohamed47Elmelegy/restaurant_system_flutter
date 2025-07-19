import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_helper.dart';

class SignupHeaderWidget extends StatelessWidget {
  const SignupHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo or Icon
        Container(
          width: 120,
          height: 120,
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
          'Create Account',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: ThemeHelper.getPrimaryTextColor(context),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        // Subtitle
        Text(
          'Sign up to get started with your account',
          style: TextStyle(
            fontSize: 16,
            color: ThemeHelper.getSecondaryTextColor(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
