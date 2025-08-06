import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_system_flutter/core/theme/text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/validation/form_validator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import 'account_creation_prompt.dart';
import 'auth_header_widget.dart';
import 'social_login_widget.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email, password;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            const AuthHeaderWidget(
              title: 'Login',
              subtitle: 'Sign in to continue to your account',
            ),
            Form(
              autovalidateMode: autovalidateMode,
              key: formKey,
              child: Column(
                children: [
                  CustomTextField(
                    onSaved: (value) {
                      email = value!;
                    },
                    controller: emailController,
                    hint: 'البريد الإلكتروني',
                    keyboardType: TextInputType.emailAddress,
                    onValidate: (value) {
                      return FormValidator.validateEmail(value);
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    onSaved: (value) {
                      password = value!;
                    },
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    hint: "كلمة المرور",
                    isPassword: true,
                    onValidate: (value) {
                      return FormValidator.validatePassword(value);
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    width: 327.w,
                    height: 62.h,
                    text: 'Log in',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        context.read<AuthBloc>().add(
                          LoginRequested(email: email, password: password),
                        );
                      } else {
                        setState(() {
                          autovalidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                    textStyle: AppTextStyles.senBold14(
                      context,
                    ).copyWith(color: Colors.white),
                    gradientColors: [
                      AppColors.lightPrimary,
                      AppColors.lightSecondary,
                    ],
                  ),
                  SizedBox(height: 32.h),

                  AccountCreationPrompt(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.signup);
                    },
                    text: 'ليس لديك حساب؟',
                    buttonText: 'إنشاء حساب جديد',
                  ),
                  SizedBox(height: 24.h),
                  // Social Login
                  const SocialLoginWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
