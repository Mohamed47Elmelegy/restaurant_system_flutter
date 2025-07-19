import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_helper.dart';
import '../bloc/onboarding_bloc.dart';

class OnboardingNavigationWidget extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final int totalPages;

  const OnboardingNavigationWidget({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          if (currentPage > 0)
            TextButton(
              onPressed: () {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                'Previous',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            const SizedBox(width: 80),

          // Next/Get Started button
          ElevatedButton(
            onPressed: () {
              if (currentPage < totalPages - 1) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                context.read<OnboardingBloc>().add(const OnboardingCompleted());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.darkPrimary
                  : AppColors.lightPrimary,
              foregroundColor: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextLight,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              currentPage < totalPages - 1 ? 'Next' : 'Get Started',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
