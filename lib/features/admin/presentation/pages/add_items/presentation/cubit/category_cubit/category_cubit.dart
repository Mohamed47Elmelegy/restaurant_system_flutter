import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import '../../../../add_category/data/repositories/category_repository.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;

  CategoryCubit(this._repository) : super(const CategoryInitial());

  Future<void> loadCategories({int? mealTimeId}) async {
    try {
      log('🔄 CategoryCubit: Loading categories (mealTimeId: $mealTimeId)');
      emit(const CategoryLoading());

      final result = await _repository.getCategories(mealTimeId: mealTimeId);

      result.fold(
        (failure) {
          log(
            '❌ CategoryCubit: Failed to load categories - ${failure.message}',
          );
          emit(
            CategoryError(message: failure.message, errorCode: failure.code),
          );
        },
        (categories) {
          log('✅ CategoryCubit: Loaded ${categories.length} categories');
          emit(
            CategoriesLoaded(categories: categories, mealTimeId: mealTimeId),
          );
        },
      );
    } catch (e) {
      log('💥 CategoryCubit: Unexpected error in loadCategories: $e');
      emit(const CategoryError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> refresh() async {
    log('🔄 CategoryCubit: Refreshing categories');
    final currentState = state;
    if (currentState is CategoriesLoaded) {
      await loadCategories(mealTimeId: currentState.mealTimeId);
    } else {
      await loadCategories();
    }
  }
}
