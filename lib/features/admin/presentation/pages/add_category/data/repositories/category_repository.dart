import 'package:dartz/dartz.dart';
import '../../../../../../../core/base/base_repository.dart';
import '../../../../../../../core/error/failures.dart';
import '../../domain/entities/main_category.dart';
import '../../domain/entities/sub_category.dart';

/// 🟦 CategoryRepository - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إدارة بيانات الفئات فقط
abstract class CategoryRepository extends BaseRepository<MainCategory> {
  /// Get categories with backward compatibility
  Future<Either<Failure, List<MainCategory>>> getCategories({int? mealTimeId});

  /// Get categories by meal time
  Future<Either<Failure, List<MainCategory>>> getCategoriesByMealTime(
    int mealTimeId,
  );

  /// Get active categories only
  Future<Either<Failure, List<MainCategory>>> getActiveCategories();

  /// Get category by name
  Future<Either<Failure, MainCategory?>> getCategoryByName(String name);

  /// Get categories with subcategories
  Future<Either<Failure, List<MainCategory>>> getCategoriesWithSubCategories();

  // ==================== SUB-CATEGORIES METHODS ====================

  /// Get sub-categories for a specific category
  Future<Either<Failure, List<SubCategory>>> getSubCategories(int categoryId);

  /// Create new sub-category
  Future<Either<Failure, SubCategory>> createSubCategory(
    int categoryId,
    SubCategory subCategory,
  );

  /// Update existing sub-category
  Future<Either<Failure, SubCategory>> updateSubCategory(
    int categoryId,
    int subCategoryId,
    SubCategory subCategory,
  );

  /// Delete sub-category
  Future<Either<Failure, bool>> deleteSubCategory(
    int categoryId,
    int subCategoryId,
  );
}
