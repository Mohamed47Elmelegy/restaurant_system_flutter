import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../widgets/home_view_body_consumer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<HomeBloc>()..add(const LoadHomeData()),
        ),
        BlocProvider(create: (context) => getIt<CartCubit>()..add(LoadCart())),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ThemeHelper.getBackgroundColor(context),
          body: const HomeViewBodyBuilder(),
        ),
      ),
    );
  }
}
