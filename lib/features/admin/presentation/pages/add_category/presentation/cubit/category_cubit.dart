import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/main_category.dart';
import '../../domain/entities/sub_category.dart';
import '../../domain/usecases/create_category_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';
import '../../domain/usecases/get_category_by_id_usecase.dart';
import '../../domain/usecases/create_sub_category_usecase.dart';
import '../../domain/usecases/get_sub_categories_usecase.dart';
import '../../data/repositories/category_repository.dart';
import 'category_events.dart';
import 'category_states.dart';

/// 🟦 CategoryCubit - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إدارة حالة الفئات والفئات الفرعية
class CategoryCubit extends Bloc<CategoryEvent, CategoryState> {
  final CreateCategoryUseCase createCategoryUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final GetCategoryByIdUseCase getCategoryByIdUseCase;
  final CreateSubCategoryUseCase createSubCategoryUseCase;
  final GetSubCategoriesUseCase getSubCategoriesUseCase;
  final CategoryRepository categoryRepository;

  CategoryCubit({
    required this.createCategoryUseCase,
    required this.getCategoriesUseCase,
    required this.updateCategoryUseCase,
    required this.getCategoryByIdUseCase,
    required this.createSubCategoryUseCase,
    required this.getSubCategoriesUseCase,
    required this.categoryRepository,
  }) : super(const CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<CreateCategory>(_onCreateCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<GetCategoryById>(_onGetCategoryById);
    on<SearchCategories>(_onSearchCategories);
    on<GetActiveCategories>(_onGetActiveCategories);
    on<GetCategoriesWithSubCategories>(_onGetCategoriesWithSubCategories);

    // Sub-category events
    on<LoadSubCategories>(_onLoadSubCategories);
    on<CreateSubCategory>(_onCreateSubCategory);
    on<UpdateSubCategory>(_onUpdateSubCategory);
    on<DeleteSubCategory>(_onDeleteSubCategory);
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
          log('✅ CategoryCubit: Created category ID - ${createdCategory.id}');
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
          log('✅ CategoryCubit: Updated category ID - ${updatedCategory.id}');
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
            log('❌ CategoryCubit: Category not found - ${event.categoryId}');
            emit(const CategoryError('الفئة غير موجودة'));
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
            '✅ CategoryCubit: Categories searched successfully - ${categories.length} results',
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

  /// Get categories with subcategories
  Future<void> _onGetCategoriesWithSubCategories(
    GetCategoriesWithSubCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      log('🔄 CategoryCubit: Getting categories with subcategories...');

      final result = await categoryRepository.getCategoriesWithSubCategories();

      result.fold(
        (failure) {
          log(
            '❌ CategoryCubit: Failed to get categories with subcategories - $failure',
          );
          if (failure.message.contains('تسجيل الدخول') ||
              failure.message.contains('مصادقة')) {
            emit(CategoryAuthError(failure.message));
          } else {
            emit(CategoryError(failure.message));
          }
        },
        (categories) {
          log(
            '✅ CategoryCubit: Categories with subcategories loaded successfully - ${categories.length} categories',
          );
          emit(CategoriesWithSubCategoriesLoaded(categories));
        },
      );
    } catch (e) {
      log('❌ CategoryCubit: Failed to get categories with subcategories - $e');
      emit(CategoryError(e.toString()));
    }
  }

  // ==================== SUB-CATEGORIES HANDLERS ====================

  /// Load sub-categories for a specific category
  Future<void> _onLoadSubCategories(
    LoadSubCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      log(
        '🔄 CategoryCubit: Loading sub-categories for category ${event.categoryId}',
      );

      final result = await getSubCategoriesUseCase(event.categoryId);

      result.fold(
        (failure) {
          log('❌ CategoryCubit: Failed to load sub-categories - $failure');
          if (failure.message.contains('تسجيل الدخول') ||
              failure.message.contains('مصادقة')) {
            emit(CategoryAuthError(failure.message));
          } else {
            emit(CategoryError(failure.message));
          }
        },
        (subCategories) {
          log(
            '✅ CategoryCubit: Sub-categories loaded successfully - ${subCategories.length} sub-categories',
          );
          emit(SubCategoriesLoaded(subCategories));
        },
      );
    } catch (e) {
      log('❌ CategoryCubit: Failed to load sub-categories - $e');
      emit(CategoryError(e.toString()));
    }
  }

  /// Create new sub-category
  Future<void> _onCreateSubCategory(
    CreateSubCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      log(
        '🔄 CategoryCubit: Creating sub-category - ${event.subCategory.name}',
      );
      log(
        '🔄 CategoryCubit: Sub-category data - ${event.subCategory.toString()}',
      );

      final result = await createSubCategoryUseCase(
        categoryId: event.categoryId,
        subCategory: event.subCategory,
      );

      result.fold(
        (failure) {
          log('❌ CategoryCubit: Failed to create sub-category - $failure');
          if (failure.message.contains('تسجيل الدخول') ||
              failure.message.contains('مصادقة')) {
            emit(CategoryAuthError(failure.message));
          } else {
            emit(CategoryError(failure.message));
          }
        },
        (createdSubCategory) {
          log(
            '✅ CategoryCubit: Sub-category created successfully - ${createdSubCategory.name}',
          );
          log(
            '✅ CategoryCubit: Created sub-category ID - ${createdSubCategory.id}',
          );
          emit(SubCategoryCreated(createdSubCategory));
        },
      );
    } catch (e) {
      log('❌ CategoryCubit: Failed to create sub-category - $e');
      emit(CategoryError(e.toString()));
    }
  }

  /// Update existing sub-category
  Future<void> _onUpdateSubCategory(
    UpdateSubCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      log(
        '🔄 CategoryCubit: Updating sub-category - ${event.subCategory.name}',
      );
      log(
        '🔄 CategoryCubit: Sub-category data - ${event.subCategory.toString()}',
      );

      final result = await categoryRepository.updateSubCategory(
        event.categoryId,
        event.subCategoryId,
        event.subCategory,
      );

      result.fold(
        (failure) {
          log('❌ CategoryCubit: Failed to update sub-category - $failure');
          if (failure.message.contains('تسجيل الدخول') ||
              failure.message.contains('مصادقة')) {
            emit(CategoryAuthError(failure.message));
          } else {
            emit(CategoryError(failure.message));
          }
        },
        (updatedSubCategory) {
          log(
            '✅ CategoryCubit: Sub-category updated successfully - ${updatedSubCategory.name}',
          );
          log(
            '✅ CategoryCubit: Updated sub-category ID - ${updatedSubCategory.id}',
          );
          emit(SubCategoryUpdated(updatedSubCategory));
        },
      );
    } catch (e) {
      log('❌ CategoryCubit: Failed to update sub-category - $e');
      emit(CategoryError(e.toString()));
    }
  }

  /// Delete sub-category
  Future<void> _onDeleteSubCategory(
    DeleteSubCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      log('🔄 CategoryCubit: Deleting sub-category - ${event.subCategoryId}');

      final result = await categoryRepository.deleteSubCategory(
        event.categoryId,
        event.subCategoryId,
      );

      result.fold(
        (failure) {
          log('❌ CategoryCubit: Failed to delete sub-category - $failure');
          if (failure.message.contains('تسجيل الدخول') ||
              failure.message.contains('مصادقة')) {
            emit(CategoryAuthError(failure.message));
          } else {
            emit(CategoryError(failure.message));
          }
        },
        (success) {
          log(
            '✅ CategoryCubit: Sub-category deleted successfully - ${event.subCategoryId}',
          );
          emit(SubCategoryDeleted(event.categoryId, event.subCategoryId));
        },
      );
    } catch (e) {
      log('❌ CategoryCubit: Failed to delete sub-category - $e');
      emit(CategoryError(e.toString()));
    }
  }
}
