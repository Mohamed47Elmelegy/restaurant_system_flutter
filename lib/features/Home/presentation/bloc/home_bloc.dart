import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_popular_items_usecase.dart';
import '../../domain/usecases/get_recommended_items_usecase.dart';
import '../../domain/usecases/get_banners_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetPopularItemsUseCase _getPopularItemsUseCase;
  final GetRecommendedItemsUseCase _getRecommendedItemsUseCase;
  final GetBannersUseCase _getBannersUseCase;

  HomeBloc({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetPopularItemsUseCase getPopularItemsUseCase,
    required GetRecommendedItemsUseCase getRecommendedItemsUseCase,
    required GetBannersUseCase getBannersUseCase,
  }) : _getCategoriesUseCase = getCategoriesUseCase,
       _getPopularItemsUseCase = getPopularItemsUseCase,
       _getRecommendedItemsUseCase = getRecommendedItemsUseCase,
       _getBannersUseCase = getBannersUseCase,
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
      final categories = await _getCategoriesUseCase();
      final popularItems = await _getPopularItemsUseCase();
      final recommendedItems = await _getRecommendedItemsUseCase();
      final banners = await _getBannersUseCase();

      emit(
        HomeLoaded(
          categories: categories,
          popularItems: popularItems,
          recommendedItems: recommendedItems,
          banners: banners,
        ),
      );
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
        final categories = await _getCategoriesUseCase();
        final popularItems = await _getPopularItemsUseCase();
        final recommendedItems = await _getRecommendedItemsUseCase();
        final banners = await _getBannersUseCase();

        emit(
          HomeLoaded(
            categories: categories,
            popularItems: popularItems,
            recommendedItems: recommendedItems,
            banners: banners,
            selectedCategoryId: currentState.selectedCategoryId,
          ),
        );
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
