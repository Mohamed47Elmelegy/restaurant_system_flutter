import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/snack_bar_service.dart';
import '../../../../core/widgets/skeleton_wrapper.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import 'home_view_body.dart';

class HomeViewBodyBuilder extends StatelessWidget {
  const HomeViewBodyBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              SnackBarService.showErrorMessage(context, state.message);
            }
          },
        ),
        BlocListener<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartItemAdded) {
              SnackBarService.showSuccessMessage(
                context,
                state.message,
                title: 'تم بنجاح',
              );
            } else if (state is CartItemUpdated) {
              SnackBarService.showSuccessMessage(
                context,
                state.message,
                title: 'تم التحديث',
              );
            } else if (state is CartItemRemoved) {
              SnackBarService.showSuccessMessage(
                context,
                state.message,
                title: 'تم الحذف',
              );
            } else if (state is CartCleared) {
              SnackBarService.showSuccessMessage(
                context,
                state.message,
                title: 'تم التفريغ',
              );
            } else if (state is CartError) {
              SnackBarService.showErrorMessage(context, state.message);
            } else if (state is CartValidationError) {
              SnackBarService.showWarningMessage(context, state.message);
            } else if (state is CartAuthError) {
              SnackBarService.showErrorMessage(context, state.message);
            } else if (state is CartNetworkError) {
              SnackBarService.showErrorMessage(context, state.message);
            }
          },
        ),
      ],
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final isLoading = state is HomeLoading || state is HomeInitial;
          return SkeletonWrapper(
            enabled: isLoading,
            child: const HomeViewBody(),
          );
        },
      ),
    );
  }
}
