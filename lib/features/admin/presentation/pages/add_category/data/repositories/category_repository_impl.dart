import 'package:dartz/dartz.dart';
import '../../../../../../../core/error/failures.dart';
import '../../../../../../../core/error/simple_error.dart';
import '../../domain/entities/main_category.dart';
import '../repositories/category_repository.dart';
import '../models/main_category_model.dart';
import '../datasources/category_remote_data_source.dart';

/// 🟦 CategoryRepositoryImpl - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تنفيذ عمليات الفئات فقط
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MainCategory>>> getCategories({
    int? mealTimeId,
  }) async {
    try {
      final response = await remoteDataSource.getCategories(
        mealTimeId: mealTimeId,
      );
      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];
        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get categories: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MainCategory>>> getCategoriesByMealTime(
    int mealTimeId,
  ) async {
    try {
      final response = await remoteDataSource.getCategoriesByMealTime(
        mealTimeId,
      );
      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];
        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get categories by meal time: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<MainCategory>>> getActiveCategories() async {
    try {
      final response = await remoteDataSource.getActiveCategories();
      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];
        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get active categories: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, MainCategory?>> getCategoryByName(String name) async {
    try {
      final response = await remoteDataSource.getCategoryByName(name);
      if (response.status) {
        return Right(response.data?.toEntity());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get category by name: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MainCategory>>>
  getCategoriesWithSubCategories() async {
    try {
      final response = await remoteDataSource.getCategoriesWithSubCategories();
      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];
        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
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
      final intId = int.tryParse(id);
      if (intId == null) {
        return Left(ServerFailure(message: 'Invalid category ID: $id'));
      }
      final response = await remoteDataSource.getCategoryById(intId);
      if (response.status) {
        return Right(response.data?.toEntity());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get category by ID: $e'));
    }
  }

  @override
  Future<Either<Failure, MainCategory>> add(MainCategory item) async {
    try {
      final categoryModel = MainCategoryModel.fromEntity(item);
      final response = await remoteDataSource.createCategory(categoryModel);
      if (response.status && response.data != null) {
        return Right(response.data!.toEntity());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
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
        return Right(response.data!.toEntity());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
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
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete category: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MainCategory>>> search(String query) async {
    try {
      final response = await remoteDataSource.searchCategories(query);
      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];
        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
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
      final response = await remoteDataSource.getCategoriesPaginated(
        page: page,
        limit: limit,
        sortBy: sortBy,
        ascending: ascending,
      );
      if (response.status) {
        final categories =
            response.data?.map((model) => model.toEntity()).toList() ?? [];
        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get paginated categories: $e'),
      );
    }
  }
}
