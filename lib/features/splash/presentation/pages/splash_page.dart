import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Check authentication status after a short delay
    Timer(const Duration(seconds: 2), () {
      context.read<AuthBloc>().add(CheckAuthStatus());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print('🔍 Splash: Auth state changed to: ${state.runtimeType}');
        if (state is AuthSuccess) {
          print('✅ Splash: User is logged in, navigating to main layout');
          Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
        } else if (state is AuthLoggedOut || state is AuthFailure) {
          print('❌ Splash: User is not logged in, navigating to onboarding');
          Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        }
      },
      child: Scaffold(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 150,
                height: 150,
                decoration: ThemeHelper.getLogoDecoration(),
                child: Icon(
                  Icons.restaurant,
                  size: 80,
                  color: ThemeHelper.getPrimaryTextColor(context),
                ),
              ),
              const SizedBox(height: 24),
              Text('نظام المطعم', style: AppTextStyles.senBold22(context)),
              const SizedBox(height: 8),
              Text(
                'Food Delivery App',
                style: AppTextStyles.senRegular14(context),
              ),
              const SizedBox(height: 40),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  ThemeHelper.getPrimaryColor(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
