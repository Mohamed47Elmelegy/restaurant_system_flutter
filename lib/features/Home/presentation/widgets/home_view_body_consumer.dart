import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/skeleton_wrapper.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import 'home_view_body.dart';
import '../../../../core/services/snack_bar_service.dart';

class HomeViewBodyBuilder extends StatelessWidget {
  const HomeViewBodyBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeError) {
          SnackBarService.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is HomeLoading || state is HomeInitial;
        return SkeletonWrapper(enabled: isLoading, child: const HomeViewBody());
      },
    );
  }
}
