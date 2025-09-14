import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Navigate to onboarding page after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
