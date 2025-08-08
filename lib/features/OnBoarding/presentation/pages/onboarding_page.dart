import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../data/datasources/onboarding_data.dart';
import '../../data/models/onboarding_model.dart';
import '../bloc/onboarding_bloc.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_navigation_widget.dart';
import '../widgets/onboarding_screen_widget.dart';
import '../widgets/onboarding_skip_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final List<OnboardingModel> _screens = OnboardingData.onboardingScreens;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: BlocProvider(
        create: (context) => OnboardingBloc(),
        child: BlocConsumer<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            if (state.isCompleted) {
              // Navigate to login page
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  // Skip button
                  const OnboardingSkipButton(),

                  // PageView
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        context.read<OnboardingBloc>().add(
                          OnboardingPageChanged(index),
                        );
                      },
                      itemCount: _screens.length,
                      itemBuilder: (context, index) {
                        return OnboardingScreenWidget(
                          screen: _screens[index],
                          isLastScreen: index == _screens.length - 1,
                        );
                      },
                    ),
                  ),

                  // Page indicators
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: OnboardingIndicator(
                      currentPage: state.currentPage,
                      totalPages: _screens.length,
                    ),
                  ),

                  // Navigation buttons
                  OnboardingNavigationWidget(
                    pageController: _pageController,
                    currentPage: state.currentPage,
                    totalPages: _screens.length,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
