import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_popular_items_usecase.dart';
import '../../domain/usecases/get_recommended_items_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetPopularItemsUseCase _getPopularItemsUseCase;
  final GetRecommendedItemsUseCase _getRecommendedItemsUseCase;

  HomeBloc({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetPopularItemsUseCase getPopularItemsUseCase,
    required GetRecommendedItemsUseCase getRecommendedItemsUseCase,
  }) : _getCategoriesUseCase = getCategoriesUseCase,
       _getPopularItemsUseCase = getPopularItemsUseCase,
       _getRecommendedItemsUseCase = getRecommendedItemsUseCase,
       super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final categoriesResult = await _getCategoriesUseCase();
      final popularItemsResult = await _getPopularItemsUseCase();
      final recommendedItemsResult = await _getRecommendedItemsUseCase();

      categoriesResult.fold((failure) => emit(HomeError(failure.message)), (
        categories,
      ) {
        popularItemsResult.fold((failure) => emit(HomeError(failure.message)), (
          popularItems,
        ) {
          recommendedItemsResult.fold(
            (failure) => emit(HomeError(failure.message)),
            (recommendedItems) {
              emit(
                HomeLoaded(
                  categories: categories,
                  popularItems: popularItems,
                  recommendedItems: recommendedItems,
                ),
              );
            },
          );
        });
      });
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(HomeLoading());

      try {
        final categoriesResult = await _getCategoriesUseCase();
        final popularItemsResult = await _getPopularItemsUseCase();
        final recommendedItemsResult = await _getRecommendedItemsUseCase();

        categoriesResult.fold((failure) => emit(HomeError(failure.message)), (
          categories,
        ) {
          log('Categories count: ${categories.length}');

          popularItemsResult.fold(
            (failure) => emit(HomeError(failure.message)),
            (popularItems) {
              recommendedItemsResult.fold(
                (failure) => emit(HomeError(failure.message)),
                (recommendedItems) {
                  emit(
                    HomeLoaded(
                      categories: categories,
                      popularItems: popularItems,
                      recommendedItems: recommendedItems,
                      selectedCategoryId: currentState.selectedCategoryId,
                    ),
                  );
                },
              );
            },
          );
        });
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    }
  }

  void _onSelectCategory(SelectCategory event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(selectedCategoryId: event.categoryId));
    }
  }
}
