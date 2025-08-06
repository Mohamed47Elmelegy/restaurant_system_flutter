import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_indicator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/snack_bar_service.dart';
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
          // Get username from auth data
          String username = state.auth.user.name;
          SnackBarService.showSuccessMessage(
            context,
            'تم تسجيل الدخول بنجاح',
            title: "مرحبا بك $username",
          );
          // Navigate based on user role
          final userRole = state.auth.user.role.toLowerCase();
          if (userRole == 'admin') {
            Navigator.pushReplacementNamed(context, AppRoutes.admin);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        } else if (state is AuthFailure) {
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
