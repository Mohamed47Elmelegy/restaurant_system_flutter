import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/onboarding_model.dart';

class OnboardingScreenWidget extends StatelessWidget {
  final OnboardingModel screen;
  final bool isLastScreen;

  const OnboardingScreenWidget({
    super.key,
    required this.screen,
    required this.isLastScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: SvgPicture.asset(screen.imagePath, height: 300, width: 300),
          ),

          // Title
          Expanded(
            flex: 1,
            child: Text(
              screen.title,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.lightTextMain,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Description
          Expanded(
            flex: 1,
            child: Text(
              screen.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.lightTextMain.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
