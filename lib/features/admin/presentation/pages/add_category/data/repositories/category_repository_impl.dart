import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../../../../core/entities/main_category.dart';
import '../../../../../../../core/error/failures.dart';
import '../../../../../../../core/models/main_category_model.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_data_source.dart';
import '../datasources/category_remote_data_source.dart';

/// 🟦 CategoryRepositoryImpl - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تنفيذ عمليات الفئات فقط
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    int? mealTimeId,
  }) async {
    try {
      // 1. محاولة جلب البيانات من الـ local أولاً
      final localCategories = await localDataSource.getMainCategories();
      if (localCategories.isNotEmpty) {
        log(
          '📱 CategoryRepository: Using local data - ${localCategories.length} categories',
        );
        // تحويل MainCategoryModel إلى MainCategory
        final categories = localCategories
            .map((model) => model.toEntity())
            .toList();
        return Right(categories);
      }

      // 2. جلب البيانات من الـ API
      log('🌐 CategoryRepository: Fetching from API...');
      final response = await remoteDataSource.getCategories(
        mealTimeId: mealTimeId,
      );

      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];

        // 3. حفظ البيانات محلياً (تحويل MainCategory إلى MainCategoryModel)
        if (categories.isNotEmpty) {
          final categoryModels = categories
              .map((entity) => MainCategoryModel.fromEntity(entity))
              .toList();
          await localDataSource.saveMainCategories(
            categoryModels.cast<MainCategoryModel>(),
          );
          log(
            '💾 CategoryRepository: Saved ${categories.length} categories to local storage',
          );
        }

        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CategoryRepository: Error getting categories - $e');
      return Left(ServerFailure(message: 'Failed to get categories: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategoriesByMealTime(
    int mealTimeId,
  ) async {
    try {
      // 1. محاولة جلب الفئات من الـ local أولاً
      final localCategories = await localDataSource.getMainCategories();
      if (localCategories.isNotEmpty) {
        log(
          '📱 CategoryRepository: Using local categories for meal time - ${localCategories.length} categories',
        );
        final categories = localCategories
            .map((model) => model.toEntity())
            .toList();
        return Right(categories);
      }

      // 2. جلب الفئات من الـ API
      log(
        '🌐 CategoryRepository: Fetching categories by meal time from API...',
      );
      final response = await remoteDataSource.getCategoriesByMealTime(
        mealTimeId,
      );
      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];

        // 3. حفظ الفئات محلياً
        if (categories.isNotEmpty) {
          final categoryModels = categories
              .map((entity) => MainCategoryModel.fromEntity(entity))
              .toList();
          await localDataSource.saveMainCategories(
            categoryModels.cast<MainCategoryModel>(),
          );
          log(
            '💾 CategoryRepository: Saved ${categories.length} categories to local storage',
          );
        }

        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CategoryRepository: Error getting categories by meal time - $e');
      return Left(
        ServerFailure(message: 'Failed to get categories by meal time: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getActiveCategories() async {
    try {
      // 1. محاولة جلب الفئات النشطة من الـ local أولاً
      final localCategories = await localDataSource.getActiveMainCategories();
      if (localCategories.isNotEmpty) {
        log(
          '📱 CategoryRepository: Using local active categories - ${localCategories.length} categories',
        );
        final categories = localCategories
            .map((model) => model.toEntity())
            .toList();
        return Right(categories);
      }

      // 2. جلب الفئات النشطة من الـ API
      log('🌐 CategoryRepository: Fetching active categories from API...');
      final response = await remoteDataSource.getActiveCategories();
      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];

        // 3. حفظ الفئات النشطة محلياً
        if (categories.isNotEmpty) {
          final categoryModels = categories
              .map((entity) => MainCategoryModel.fromEntity(entity))
              .toList();
          await localDataSource.saveMainCategories(
            categoryModels.cast<MainCategoryModel>(),
          );
          log(
            '💾 CategoryRepository: Saved ${categories.length} active categories to local storage',
          );
        }

        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CategoryRepository: Error getting active categories - $e');
      return Left(
        ServerFailure(message: 'Failed to get active categories: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, CategoryEntity?>> getCategoryByName(
    String name,
  ) async {
    try {
      // 1. محاولة البحث في الـ local أولاً
      final localCategories = await localDataSource.searchMainCategories(name);
      if (localCategories.isNotEmpty) {
        log('📱 CategoryRepository: Found category by name in local storage');
        final category = localCategories.first.toEntity();
        return Right(category);
      }

      // 2. البحث في الـ API
      log('🌐 CategoryRepository: Searching category by name in API...');
      final response = await remoteDataSource.getCategoryByName(name);
      if (response.status) {
        final category = response.data?.toEntity();
        return Right(category);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CategoryRepository: Error getting category by name - $e');
      return Left(ServerFailure(message: 'Failed to get category by name: $e'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> addCategory(
    CategoryEntity entity,
  ) async {
    try {
      final categoryModel = MainCategoryModel.fromEntity(entity);
      final response = await remoteDataSource.createCategory(categoryModel);
      if (response.status && response.data != null) {
        final createdCategory = response.data!.toEntity();

        // حفظ الفئة الجديدة محلياً
        await localDataSource.saveMainCategory(response.data!);
        log('💾 CategoryRepository: Saved new category to local storage');

        return Right(createdCategory);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CategoryRepository: Error creating category - $e');
      return Left(ServerFailure(message: 'Failed to create category: $e'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> update(
    String id,
    CategoryEntity entity,
  ) async {
    try {
      final updatedEntity = entity.copyWith(id: id);
      final categoryModel = MainCategoryModel.fromEntity(updatedEntity);
      final response = await remoteDataSource.updateCategory(categoryModel);
      if (response.status && response.data != null) {
        final updatedCategory = response.data!.toEntity();

        // تحديث الفئة محلياً
        await localDataSource.saveMainCategory(response.data!);
        log('💾 CategoryRepository: Updated category in local storage');

        return Right(updatedCategory);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CategoryRepository: Error updating category - $e');
      return Left(ServerFailure(message: 'Failed to update category: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> delete(String id) async {
    try {
      final categoryId = int.tryParse(id);
      if (categoryId == null) {
        return const Left(ServerFailure(message: 'Invalid category ID'));
      }

      final response = await remoteDataSource.deleteCategory(categoryId);
      if (response.status && response.data != null) {
        // حذف الفئة من التخزين المحلي
        await localDataSource.deleteMainCategory(id);
        log('🗑️ CategoryRepository: Deleted category from local storage');

        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CategoryRepository: Error deleting category - $e');
      return Left(ServerFailure(message: 'Failed to delete category: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAll() async {
    return getCategories();
  }

  @override
  Future<Either<Failure, CategoryEntity?>> getById(String id) async {
    try {
      // 1. محاولة جلب الفئة من الـ local أولاً
      final localCategory = await localDataSource.getMainCategoryById(id);
      if (localCategory != null) {
        log('📱 CategoryRepository: Found category in local storage');
        final category = localCategory.toEntity();
        return Right(category);
      }

      // 2. جلب الفئة من الـ API
      log('🌐 CategoryRepository: Fetching category from API...');
      final categoryId = int.tryParse(id);
      if (categoryId == null) {
        return const Left(ServerFailure(message: 'Invalid category ID'));
      }

      final response = await remoteDataSource.getCategoryById(categoryId);
      if (response.status) {
        final category = response.data?.toEntity();
        return Right(category);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CategoryRepository: Error getting category by ID - $e');
      return Left(ServerFailure(message: 'Failed to get category by ID: $e'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> add(CategoryEntity item) async {
    return addCategory(item);
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> search(String query) async {
    try {
      // 1. محاولة البحث في الـ local أولاً
      final localCategories = await localDataSource.searchMainCategories(query);
      if (localCategories.isNotEmpty) {
        log(
          '📱 CategoryRepository: Using local search results - ${localCategories.length} categories',
        );
        final categories = localCategories
            .map((model) => model.toEntity())
            .toList();
        return Right(categories);
      }

      // 2. البحث في الـ API
      log('🌐 CategoryRepository: Searching in API...');
      final response = await remoteDataSource.searchCategories(query);
      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];

        // 3. حفظ نتائج البحث محلياً
        if (categories.isNotEmpty) {
          final categoryModels = categories
              .map((entity) => MainCategoryModel.fromEntity(entity))
              .toList();
          await localDataSource.saveMainCategories(
            categoryModels.cast<MainCategoryModel>(),
          );
          log('💾 CategoryRepository: Saved search results to local storage');
        }

        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CategoryRepository: Error searching categories - $e');
      return Left(ServerFailure(message: 'Failed to search categories: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getPaginated({
    int page = 1,
    int limit = 10,
    String? sortBy,
    bool ascending = true,
  }) async {
    try {
      // 1. محاولة جلب البيانات المحلية أولاً
      final localCategories = await localDataSource.getMainCategories();
      if (localCategories.isNotEmpty) {
        log(
          '📱 CategoryRepository: Using local paginated data - ${localCategories.length} categories',
        );
        final categories = localCategories
            .map((model) => model.toEntity())
            .toList();

        // تطبيق الـ pagination على البيانات المحلية
        final startIndex = (page - 1) * limit;
        final endIndex = startIndex + limit;
        final paginatedCategories = categories.length > startIndex
            ? categories.sublist(
                startIndex,
                endIndex > categories.length ? categories.length : endIndex,
              )
            : <CategoryEntity>[];

        return Right(paginatedCategories);
      }

      // 2. جلب البيانات من الـ API
      log('🌐 CategoryRepository: Fetching paginated data from API...');
      final response = await remoteDataSource.getCategoriesPaginated(
        page: page,
        limit: limit,
        sortBy: sortBy,
        ascending: ascending,
      );
      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];

        // 3. حفظ البيانات محلياً
        if (categories.isNotEmpty) {
          final categoryModels = categories
              .map((entity) => MainCategoryModel.fromEntity(entity))
              .toList();
          await localDataSource.saveMainCategories(
            categoryModels.cast<MainCategoryModel>(),
          );
          log('💾 CategoryRepository: Saved paginated data to local storage');
        }

        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CategoryRepository: Error getting paginated categories - $e');
      return Left(
        ServerFailure(message: 'Failed to get paginated categories: $e'),
      );
    }
  }
}
