import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_helper.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'login_form_widget.dart';
import 'login_header_widget.dart';
import 'social_login_widget.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            EasyLoading.show(
              status: 'جاري تسجيل الدخول...',
              maskType: EasyLoadingMaskType.black,
            );
          } else if (state is AuthSuccess) {
            EasyLoading.dismiss();
            // Navigate to home page
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is AuthFailure) {
            EasyLoading.dismiss();
            EasyLoading.showError(
              state.message,
              duration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Header
                  const LoginHeaderWidget(),

                  const SizedBox(height: 40),

                  // Login Form
                  LoginFormWidget(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    isPasswordVisible: _isPasswordVisible,
                    onPasswordVisibilityChanged: (value) {
                      setState(() {
                        _isPasswordVisible = value;
                      });
                    },
                    onLoginPressed: _handleLogin,
                  ),

                  const SizedBox(height: 32),

                  // Social Login
                  const SocialLoginWidget(),

                  const SizedBox(height: 24),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ليس لديك حساب؟ ",
                        style: TextStyle(
                          color: ThemeHelper.getSecondaryTextColor(context),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.signup,
                          );
                        },
                        child: Text(
                          "إنشاء حساب",
                          style: TextStyle(
                            color: AppColors.lightPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
