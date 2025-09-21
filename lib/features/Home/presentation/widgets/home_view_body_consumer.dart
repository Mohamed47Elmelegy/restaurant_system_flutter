import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/snack_bar_service.dart';
import '../../../../core/widgets/common_error_state.dart';
import '../../../../core/widgets/common_state_builder.dart';
import '../../../../core/widgets/skeletons/skeletons.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
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
      child: CommonStateBuilder<HomeBloc, HomeState>(
        isLoading: (state) => state is HomeLoading || state is HomeInitial,
        hasError: (state) => state is HomeError,
        isEmpty: (state) =>
            state is HomeLoaded &&
            state.categories.isEmpty &&
            state.popularItems.isEmpty &&
            state.recommendedItems.isEmpty,
        getErrorMessage: (state) =>
            state is HomeError ? state.message : 'حدث خطأ غير متوقع',
        loadingMessage: 'جاري تحميل البيانات...',
        errorBuilder: (context, message) => CommonErrorState.general(
          message: message,
          onRetry: () => context.read<HomeBloc>().add(const LoadHomeData()),
        ),
        builder: (context, state) {
          return const HomeViewBody();
        },
        loadingBuilder: (context) {
          return const HomePageSkeleton();
        },
      ),
    );
  }
}
