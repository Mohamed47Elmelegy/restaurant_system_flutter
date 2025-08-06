import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/theme_helper.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/login_view_body_consumer.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ThemeHelper.getBackgroundColor(context),
          body: const LoginViewBodyConsumer(),
        ),
      ),
    );
  }
}
