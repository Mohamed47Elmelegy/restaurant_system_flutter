import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/snack_bar_service.dart';
import '../../../../core/widgets/custom_indicator.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'signup_view_body.dart';

class SignupViewBodyConsumer extends StatelessWidget {
  const SignupViewBodyConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Get username from auth data
          final String username = state.auth.user.name;
          SnackBarService.showSuccessMessage(
            context,
            'تم إنشاء حسابك بنجاح',
            title: "مرحبا بك $username",
          );
          Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
        } else if (state is AuthFailure) {
          SnackBarService.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomLoadingIndicator(
          isLoading: state is AuthLoading,
          child: const SignupViewBody(),
        );
      },
    );
  }
}
