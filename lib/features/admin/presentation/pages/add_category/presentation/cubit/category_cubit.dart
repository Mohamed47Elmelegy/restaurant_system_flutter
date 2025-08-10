import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_category_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';
import '../../domain/usecases/get_category_by_id_usecase.dart';
import '../../domain/repositories/category_repository.dart';
import 'category_events.dart';
import 'category_states.dart';

/// 🟦 CategoryCubit - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إدارة حالة الفئات
class CategoryCubit extends Bloc<CategoryEvent, CategoryState> {
  final CreateCategoryUseCase createCategoryUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final GetCategoryByIdUseCase getCategoryByIdUseCase;
  final CategoryRepository categoryRepository;

  CategoryCubit({
    required this.createCategoryUseCase,
    required this.getCategoriesUseCase,
    required this.updateCategoryUseCase,
    required this.getCategoryByIdUseCase,
    required this.categoryRepository,
  }) : super(const CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<CreateCategory>(_onCreateCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<GetCategoryById>(_onGetCategoryById);
    on<SearchCategories>(_onSearchCategories);
    on<GetActiveCategories>(_onGetActiveCategories);
  }

  /// Load all categories
  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      log('🔄 CategoryCubit: Loading categories...');

      final result = await getCategoriesUseCase();

      result.fold(
        (failure) {
          log('❌ CategoryCubit: Failed to load categories - $failure');
          if (failure.message.contains('تسجيل الدخول') ||
              failure.message.contains('مصادقة')) {
            emit(CategoryAuthError(failure.message));
          } else {
            emit(CategoryError(failure.message));
          }
        },
        (categories) {
          log(
            '✅ CategoryCubit: Categories loaded successfully - ${categories.length} categories',
          );
          emit(CategoriesLoaded(categories));
        },
      );
    } catch (e) {
      log('❌ CategoryCubit: Failed to load categories - $e');
      emit(CategoryError(e.toString()));
    }
  }

  /// Create new category
  Future<void> _onCreateCategory(
    CreateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      log('🔄 CategoryCubit: Creating category - ${event.category.name}');
      log('🔄 CategoryCubit: Category data - ${event.category.toString()}');

      final result = await createCategoryUseCase(event.category);

      result.fold(
        (failure) {
          log('❌ CategoryCubit: Failed to create category - $failure');
          if (failure.message.contains('تسجيل الدخول') ||
              failure.message.contains('مصادقة')) {
            emit(CategoryAuthError(failure.message));
          } else {
            emit(CategoryError(failure.message));
          }
        },
        (createdCategory) {
          log(
            '✅ CategoryCubit: Category created successfully - ${createdCategory.name}',
          );
          log(
            '✅ CategoryCubit: Created category ID - ${createdCategory.id}',
          );
          emit(CategoryCreated(createdCategory));
        },
      );
    } catch (e) {
      log('❌ CategoryCubit: Failed to create category - $e');
      emit(CategoryError(e.toString()));
    }
  }

  /// Update existing category
  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      log('🔄 CategoryCubit: Updating category - ${event.category.name}');
      log('🔄 CategoryCubit: Category data - ${event.category.toString()}');

      final result = await updateCategoryUseCase(event.category);

      result.fold(
        (failure) {
          log('❌ CategoryCubit: Failed to update category - $failure');
          if (failure.message.contains('تسجيل الدخول') ||
              failure.message.contains('مصادقة')) {
            emit(CategoryAuthError(failure.message));
          } else {
            emit(CategoryError(failure.message));
          }
        },
        (updatedCategory) {
          log(
            '✅ CategoryCubit: Category updated successfully - ${updatedCategory.name}',
          );
          log(
            '✅ CategoryCubit: Updated category ID - ${updatedCategory.id}',
          );
          emit(CategoryUpdated(updatedCategory));
        },
      );
    } catch (e) {
      log('❌ CategoryCubit: Failed to update category - $e');
      emit(CategoryError(e.toString()));
    }
  }

  /// Delete category
  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      log('🔄 CategoryCubit: Deleting category - ${event.categoryId}');

      final result = await categoryRepository.delete(event.categoryId);

      result.fold(
        (failure) {
          log('❌ CategoryCubit: Failed to delete category - $failure');
          if (failure.message.contains('تسجيل الدخول') ||
              failure.message.contains('مصادقة')) {
            emit(CategoryAuthError(failure.message));
          } else {
            emit(CategoryError(failure.message));
          }
        },
        (success) {
          log(
            '✅ CategoryCubit: Category deleted successfully - ${event.categoryId}',
          );
          emit(CategoryDeleted(event.categoryId));
        },
      );
    } catch (e) {
      log('❌ CategoryCubit: Failed to delete category - $e');
      emit(CategoryError(e.toString()));
    }
  }

  /// Get category by ID
  Future<void> _onGetCategoryById(
    GetCategoryById event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      log('🔄 CategoryCubit: Getting category by ID - ${event.categoryId}');

      final result = await getCategoryByIdUseCase(event.categoryId);

      result.fold(
        (failure) {
          log('❌ CategoryCubit: Failed to get category by ID - $failure');
          if (failure.message.contains('تسجيل الدخول') ||
              failure.message.contains('مصادقة')) {
            emit(CategoryAuthError(failure.message));
          } else {
            emit(CategoryError(failure.message));
          }
        },
        (category) {
          if (category != null) {
            log(
              '✅ CategoryCubit: Category loaded successfully - ${category.name}',
            );
            emit(CategoryLoaded(category));
          } else {
            log('❌ CategoryCubit: Category not found');
            emit(const CategoryError('Category not found'));
          }
        },
      );
    } catch (e) {
      log('❌ CategoryCubit: Failed to get category by ID - $e');
      emit(CategoryError(e.toString()));
    }
  }

  /// Search categories
  Future<void> _onSearchCategories(
    SearchCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      log('🔄 CategoryCubit: Searching categories - ${event.query}');

      final result = await categoryRepository.search(event.query);

      result.fold(
        (failure) {
          log('❌ CategoryCubit: Failed to search categories - $failure');
          if (failure.message.contains('تسجيل الدخول') ||
              failure.message.contains('مصادقة')) {
            emit(CategoryAuthError(failure.message));
          } else {
            emit(CategoryError(failure.message));
          }
        },
        (categories) {
          log(
            '✅ CategoryCubit: Categories searched successfully - ${categories.length} categories',
          );
          emit(CategoriesSearched(categories));
        },
      );
    } catch (e) {
      log('❌ CategoryCubit: Failed to search categories - $e');
      emit(CategoryError(e.toString()));
    }
  }

  /// Get active categories
  Future<void> _onGetActiveCategories(
    GetActiveCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      log('🔄 CategoryCubit: Getting active categories...');

      final result = await categoryRepository.getActiveCategories();

      result.fold(
        (failure) {
          log('❌ CategoryCubit: Failed to get active categories - $failure');
          if (failure.message.contains('تسجيل الدخول') ||
              failure.message.contains('مصادقة')) {
            emit(CategoryAuthError(failure.message));
          } else {
            emit(CategoryError(failure.message));
          }
        },
        (categories) {
          log(
            '✅ CategoryCubit: Active categories loaded successfully - ${categories.length} categories',
          );
          emit(ActiveCategoriesLoaded(categories));
        },
      );
    } catch (e) {
      log('❌ CategoryCubit: Failed to get active categories - $e');
      emit(CategoryError(e.toString()));
    }
  }
}
