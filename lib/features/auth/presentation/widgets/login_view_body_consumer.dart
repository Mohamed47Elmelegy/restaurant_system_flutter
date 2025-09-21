import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/snack_bar_service.dart';
import '../../../../core/widgets/custom_indicator.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'login_view_body.dart';

class LoginViewBodyConsumer extends StatelessWidget {
  const LoginViewBodyConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          print('✅ Login: Authentication successful!');
          print('💾 Login: Token saved to secure storage');
          print(
            '👤 Login: User: ${state.auth.user.name} (${state.auth.user.email})',
          );

          // Get username from auth data
          final String username = state.auth.user.name;
          SnackBarService.showSuccessMessage(
            context,
            'تم تسجيل الدخول بنجاح',
            title: "مرحبا بك $username",
          );

          // Navigate based on user role
          final userRole = state.auth.user.role.toLowerCase();
          if (userRole == 'admin') {
            print('🔑 Login: Admin user, navigating to admin panel');
            Navigator.pushReplacementNamed(context, AppRoutes.admin);
          } else {
            print('🏠 Login: Regular user, navigating to main layout (home)');
            Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
          }
        } else if (state is AuthFailure) {
          print('❌ Login: Authentication failed - ${state.message}');
          SnackBarService.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomLoadingIndicator(
          isLoading: state is AuthLoading,
          child: const LoginViewBody(),
        );
      },
    );
  }
}
