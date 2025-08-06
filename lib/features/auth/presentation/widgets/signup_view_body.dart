import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/validation/form_validator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/services/snack_bar_service.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import 'auth_header_widget.dart';
import 'terms_and_conditions_checkbox.dart';
import 'account_creation_prompt.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  late bool isTermsAccept = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String name, password, email;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        autovalidateMode: autovalidateMode,
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Column(
            children: [
              const AuthHeaderWidget(
                title: 'Signup',
                subtitle: 'Please sign up to get started',
              ),
              const SizedBox(height: 24),
              CustomTextField(
                onSaved: (value) {
                  name = value!;
                },
                controller: nameController,
                hint: 'الاسم كامل',
                keyboardType: TextInputType.name,
                onValidate: (value) {
                  return FormValidator.validateMinLength(value, 2, 'الاسم');
                },
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              TermsAndConditionsCheckbox(
                onChanged: (value) {
                  isTermsAccept = value;
                  setState(() {});
                },
              ),
              const SizedBox(height: 30),
              CustomButton(
                width: 327.w,
                height: 62.h,
                text: 'Create Account',
                onPressed: () {
                  // Validate form fields
                  final isFormValid = formKey.currentState!.validate();

                  // Validate terms acceptance
                  final termsError = FormValidator.validateTermsAcceptance(
                    isTermsAccept,
                  );

                  if (isFormValid && termsError == null) {
                    formKey.currentState!.save();
                    context.read<AuthBloc>().add(
                      RegisterRequested(
                        email: email,
                        password: password,
                        name: name,
                      ),
                    );
                  } else {
                    // Show terms error if not accepted
                    if (termsError != null) {
                      SnackBarService.showErrorMessage(context, termsError);
                    }

                    // Enable form validation
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
                gradientColors: [
                  AppColors.lightPrimary,
                  AppColors.lightSecondary,
                ],
                textStyle: AppTextStyles.senBold14(
                  context,
                ).copyWith(color: Colors.white),
              ),
              const SizedBox(height: 26),
              AccountCreationPrompt(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                text: 'تمتلك حساب بالفعل؟',
                buttonText: 'تسجيل دخول',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
