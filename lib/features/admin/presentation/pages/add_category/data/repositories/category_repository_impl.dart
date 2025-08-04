import 'package:dartz/dartz.dart';
import '../../../../../../../core/error/failures.dart';
import '../../../../../../../core/error/simple_error.dart';
import '../../domain/entities/main_category.dart';
import '../../domain/entities/sub_category.dart';
import '../repositories/category_repository.dart';
import '../models/main_category_model.dart';
import '../models/sub_category_model.dart';
import '../datasources/category_remote_data_source.dart';
import '../datasources/category_local_data_source.dart';

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
  Future<Either<Failure, List<MainCategory>>> getCategories({
    int? mealTimeId,
  }) async {
    try {
      // 1. محاولة جلب البيانات من الـ local أولاً
      final localCategories = await localDataSource.getMainCategories();
      if (localCategories.isNotEmpty) {
        print(
          '📱 CategoryRepository: Using local data - ${localCategories.length} categories',
        );
        // تحويل MainCategoryModel إلى MainCategory
        final categories = localCategories
            .map((model) => model.toEntity())
            .toList();
        return Right(categories);
      }

      // 2. جلب البيانات من الـ API
      print('🌐 CategoryRepository: Fetching from API...');
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
          await localDataSource.saveMainCategories(categoryModels);
          print(
            '💾 CategoryRepository: Saved ${categories.length} categories to local storage',
          );
        }

        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error getting categories - $e');
      return Left(ServerFailure(message: 'Failed to get categories: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MainCategory>>> getCategoriesByMealTime(
    int mealTimeId,
  ) async {
    try {
      // 1. محاولة جلب الفئات من الـ local أولاً
      final localCategories = await localDataSource.getMainCategories();
      if (localCategories.isNotEmpty) {
        print(
          '📱 CategoryRepository: Using local categories for meal time - ${localCategories.length} categories',
        );
        final categories = localCategories
            .map((model) => model.toEntity())
            .toList();
        return Right(categories);
      }

      // 2. جلب الفئات من الـ API
      print(
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
          await localDataSource.saveMainCategories(categoryModels);
          print(
            '💾 CategoryRepository: Saved categories by meal time to local storage',
          );
        }

        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error getting categories by meal time - $e');
      return Left(
        ServerFailure(message: 'Failed to get categories by meal time: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<MainCategory>>> getActiveCategories() async {
    try {
      // 1. محاولة جلب البيانات النشطة من الـ local أولاً
      final localActiveCategories = await localDataSource
          .getActiveMainCategories();
      if (localActiveCategories.isNotEmpty) {
        print(
          '📱 CategoryRepository: Using local active categories - ${localActiveCategories.length} categories',
        );
        final categories = localActiveCategories
            .map((model) => model.toEntity())
            .toList();
        return Right(categories);
      }

      // 2. جلب البيانات من الـ API
      print('🌐 CategoryRepository: Fetching active categories from API...');
      final response = await remoteDataSource.getActiveCategories();
      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];

        // 3. حفظ البيانات محلياً
        if (categories.isNotEmpty) {
          final categoryModels = categories
              .map((entity) => MainCategoryModel.fromEntity(entity))
              .toList();
          await localDataSource.saveMainCategories(categoryModels);
          print(
            '💾 CategoryRepository: Saved ${categories.length} active categories to local storage',
          );
        }

        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error getting active categories - $e');
      return Left(
        ServerFailure(message: 'Failed to get active categories: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, MainCategory?>> getCategoryByName(String name) async {
    try {
      // 1. محاولة البحث في البيانات المحلية أولاً
      final localSearchResults = await localDataSource.searchMainCategories(
        name,
      );
      if (localSearchResults.isNotEmpty) {
        print(
          '📱 CategoryRepository: Using local search for category name - ${localSearchResults.length} results',
        );
        final category = localSearchResults.first.toEntity();
        return Right(category);
      }

      // 2. البحث في الـ API
      print('🌐 CategoryRepository: Searching for category name in API...');
      final response = await remoteDataSource.getCategoryByName(name);
      if (response.status && response.data != null) {
        final category = response.data!.toEntity();

        // 3. حفظ الفئة محلياً
        await localDataSource.saveMainCategory(response.data!);
        print('💾 CategoryRepository: Saved category by name to local storage');

        return Right(category);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error getting category by name - $e');
      return Left(ServerFailure(message: 'Failed to get category by name: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MainCategory>>>
  getCategoriesWithSubCategories() async {
    try {
      // 1. محاولة جلب الفئات مع الفئات الفرعية من الـ local أولاً
      final localCategories = await localDataSource.getMainCategories();
      final localSubCategories = await localDataSource.getSubCategories();

      if (localCategories.isNotEmpty) {
        print(
          '📱 CategoryRepository: Using local categories with sub-categories - ${localCategories.length} categories',
        );
        final categories = localCategories
            .map((model) => model.toEntity())
            .toList();
        return Right(categories);
      }

      // 2. جلب الفئات مع الفئات الفرعية من الـ API
      print(
        '🌐 CategoryRepository: Fetching categories with sub-categories from API...',
      );
      final response = await remoteDataSource.getCategoriesWithSubCategories();
      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];

        // 3. حفظ الفئات والفئات الفرعية محلياً
        if (categories.isNotEmpty) {
          final categoryModels = categories
              .map((entity) => MainCategoryModel.fromEntity(entity))
              .toList();
          await localDataSource.saveMainCategories(categoryModels);

          // حفظ الفئات الفرعية أيضاً
          for (final category in categories) {
            if (category.subCategories?.isNotEmpty == true) {
              final subCategoryModels = category.subCategories!
                  .map((entity) => SubCategoryModel.fromEntity(entity))
                  .toList();
              await localDataSource.saveSubCategories(subCategoryModels);
            }
          }

          print(
            '💾 CategoryRepository: Saved categories with sub-categories to local storage',
          );
        }

        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print(
        '❌ CategoryRepository: Error getting categories with sub-categories - $e',
      );
      return Left(
        ServerFailure(
          message: 'Failed to get categories with subcategories: $e',
        ),
      );
    }
  }

  // BaseRepository inherited methods
  @override
  Future<Either<Failure, List<MainCategory>>> getAll() async {
    return getCategories();
  }

  @override
  Future<Either<Failure, MainCategory?>> getById(String id) async {
    try {
      // 1. محاولة جلب الفئة من الـ local أولاً
      final localCategory = await localDataSource.getMainCategoryById(id);
      if (localCategory != null) {
        print(
          '📱 CategoryRepository: Using local category - ${localCategory.name}',
        );
        return Right(localCategory.toEntity());
      }

      // 2. جلب الفئة من الـ API
      print('🌐 CategoryRepository: Fetching category from API...');
      final intId = int.tryParse(id);
      if (intId == null) {
        return Left(ServerFailure(message: 'Invalid category ID: $id'));
      }
      final response = await remoteDataSource.getCategoryById(intId);
      if (response.status && response.data != null) {
        final category = response.data!.toEntity();

        // 3. حفظ الفئة محلياً
        await localDataSource.saveMainCategory(response.data!);
        print('💾 CategoryRepository: Saved category to local storage');

        return Right(category);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error getting category by ID - $e');
      return Left(ServerFailure(message: 'Failed to get category by ID: $e'));
    }
  }

  @override
  Future<Either<Failure, MainCategory>> add(MainCategory item) async {
    try {
      final categoryModel = MainCategoryModel.fromEntity(item);
      final response = await remoteDataSource.createCategory(categoryModel);
      if (response.status && response.data != null) {
        final createdCategory = response.data!.toEntity();

        // حفظ الفئة الجديدة محلياً
        await localDataSource.saveMainCategory(response.data!);
        print('💾 CategoryRepository: Saved new category to local storage');

        return Right(createdCategory);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error creating category - $e');
      return Left(ServerFailure(message: 'Failed to create category: $e'));
    }
  }

  @override
  Future<Either<Failure, MainCategory>> update(
    String id,
    MainCategory item,
  ) async {
    try {
      final updatedCategory = item.copyWith(id: id);
      final categoryModel = MainCategoryModel.fromEntity(updatedCategory);
      final response = await remoteDataSource.updateCategory(categoryModel);
      if (response.status && response.data != null) {
        final updatedCategoryEntity = response.data!.toEntity();

        // تحديث الفئة محلياً
        await localDataSource.saveMainCategory(response.data!);
        print('💾 CategoryRepository: Updated category in local storage');

        return Right(updatedCategoryEntity);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error updating category - $e');
      return Left(ServerFailure(message: 'Failed to update category: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> delete(String id) async {
    try {
      final intId = int.tryParse(id);
      if (intId == null) {
        return Left(ServerFailure(message: 'Invalid category ID: $id'));
      }
      final response = await remoteDataSource.deleteCategory(intId);
      if (response.status && response.data != null) {
        // حذف الفئة من التخزين المحلي
        await localDataSource.deleteMainCategory(id);
        print('🗑️ CategoryRepository: Deleted category from local storage');

        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error deleting category - $e');
      return Left(ServerFailure(message: 'Failed to delete category: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MainCategory>>> search(String query) async {
    try {
      // 1. محاولة البحث في البيانات المحلية أولاً
      final localSearchResults = await localDataSource.searchMainCategories(
        query,
      );
      if (localSearchResults.isNotEmpty) {
        print(
          '📱 CategoryRepository: Using local search results - ${localSearchResults.length} categories',
        );
        final categories = localSearchResults
            .map((model) => model.toEntity())
            .toList();
        return Right(categories);
      }

      // 2. البحث في الـ API
      print('🌐 CategoryRepository: Searching in API...');
      final response = await remoteDataSource.searchCategories(query);
      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];

        // 3. حفظ نتائج البحث محلياً
        if (categories.isNotEmpty) {
          final categoryModels = categories
              .map((entity) => MainCategoryModel.fromEntity(entity))
              .toList();
          await localDataSource.saveMainCategories(categoryModels);
          print('💾 CategoryRepository: Saved search results to local storage');
        }

        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error searching categories - $e');
      return Left(ServerFailure(message: 'Failed to search categories: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MainCategory>>> getPaginated({
    int page = 1,
    int limit = 10,
    String? sortBy,
    bool ascending = true,
  }) async {
    try {
      // 1. محاولة جلب البيانات المحلية أولاً
      final localCategories = await localDataSource.getMainCategories();
      if (localCategories.isNotEmpty) {
        print(
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
            : <MainCategory>[];

        return Right(paginatedCategories);
      }

      // 2. جلب البيانات من الـ API
      print('🌐 CategoryRepository: Fetching paginated data from API...');
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
          await localDataSource.saveMainCategories(categoryModels);
          print('💾 CategoryRepository: Saved paginated data to local storage');
        }

        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error getting paginated categories - $e');
      return Left(
        ServerFailure(message: 'Failed to get paginated categories: $e'),
      );
    }
  }

  // ==================== SUB-CATEGORIES IMPLEMENTATION ====================

  @override
  Future<Either<Failure, List<SubCategory>>> getSubCategories(
    int categoryId,
  ) async {
    try {
      // 1. محاولة جلب الفئات الفرعية من الـ local أولاً
      final localSubCategories = await localDataSource
          .getSubCategoriesByMainCategory(categoryId);
      if (localSubCategories.isNotEmpty) {
        print(
          '📱 CategoryRepository: Using local sub-categories - ${localSubCategories.length} sub-categories',
        );
        final subCategories = localSubCategories
            .map((model) => model.toEntity())
            .toList();
        return Right(subCategories);
      }

      // 2. جلب الفئات الفرعية من الـ API
      print('🌐 CategoryRepository: Fetching sub-categories from API...');
      final response = await remoteDataSource.getSubCategories(categoryId);
      if (response.status) {
        final subCategories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];

        // 3. حفظ الفئات الفرعية محلياً
        if (subCategories.isNotEmpty) {
          final subCategoryModels = subCategories
              .map((entity) => SubCategoryModel.fromEntity(entity))
              .toList();
          await localDataSource.saveSubCategories(subCategoryModels);
          print(
            '💾 CategoryRepository: Saved ${subCategories.length} sub-categories to local storage',
          );
        }

        return Right(subCategories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error getting sub-categories - $e');
      return Left(ServerFailure(message: 'Failed to get sub-categories: $e'));
    }
  }

  @override
  Future<Either<Failure, SubCategory>> createSubCategory(
    int categoryId,
    SubCategory subCategory,
  ) async {
    try {
      final subCategoryModel = SubCategoryModel.fromEntity(subCategory);
      final response = await remoteDataSource.createSubCategory(
        categoryId,
        subCategoryModel,
      );
      if (response.status && response.data != null) {
        final createdSubCategory = response.data!.toEntity();

        // حفظ الفئة الفرعية الجديدة محلياً
        await localDataSource.saveSubCategory(response.data!);
        print('💾 CategoryRepository: Saved new sub-category to local storage');

        return Right(createdSubCategory);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error creating sub-category - $e');
      return Left(ServerFailure(message: 'Failed to create sub-category: $e'));
    }
  }

  @override
  Future<Either<Failure, SubCategory>> updateSubCategory(
    int categoryId,
    int subCategoryId,
    SubCategory subCategory,
  ) async {
    try {
      final subCategoryModel = SubCategoryModel.fromEntity(subCategory);
      final response = await remoteDataSource.updateSubCategory(
        categoryId,
        subCategoryId,
        subCategoryModel,
      );
      if (response.status && response.data != null) {
        final updatedSubCategory = response.data!.toEntity();

        // تحديث الفئة الفرعية محلياً
        await localDataSource.saveSubCategory(response.data!);
        print('💾 CategoryRepository: Updated sub-category in local storage');

        return Right(updatedSubCategory);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error updating sub-category - $e');
      return Left(ServerFailure(message: 'Failed to update sub-category: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSubCategory(
    int categoryId,
    int subCategoryId,
  ) async {
    try {
      final response = await remoteDataSource.deleteSubCategory(
        categoryId,
        subCategoryId,
      );
      if (response.status && response.data != null) {
        // حذف الفئة الفرعية من التخزين المحلي
        await localDataSource.deleteSubCategory(subCategoryId.toString());
        print(
          '🗑️ CategoryRepository: Deleted sub-category from local storage',
        );

        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error deleting sub-category - $e');
      return Left(ServerFailure(message: 'Failed to delete sub-category: $e'));
    }
  }
}
