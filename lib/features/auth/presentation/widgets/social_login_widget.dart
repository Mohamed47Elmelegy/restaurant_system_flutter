import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_helper.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: ThemeHelper.getSecondaryTextColor(
                  context,
                ).withValues(alpha: 0.2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or continue with',
                style: TextStyle(
                  color: ThemeHelper.getSecondaryTextColor(context),
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: ThemeHelper.getSecondaryTextColor(
                  context,
                ).withValues(alpha: 0.2),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Social Login Buttons
        Row(
          children: [
            Expanded(
              child: _SocialLoginButton(
                icon: Icons.g_mobiledata,
                label: 'Google',
                onPressed: () {
                  // TODO: Implement Google login
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SocialLoginButton(
                icon: Icons.apple,
                label: 'Apple',
                onPressed: () {
                  // TODO: Implement Apple login
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialLoginButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeHelper.getSecondaryTextColor(
            context,
          ).withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: ThemeHelper.getSocialButtonShadow(context),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.lightPrimary, size: 24),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: ThemeHelper.getPrimaryTextColor(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
