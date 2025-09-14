import 'package:dartz/dartz.dart';

import '../../../../../../../core/base/base_repository.dart';
import '../../../../../../../core/entities/main_category.dart';
import '../../../../../../../core/error/failures.dart';

/// 🟦 CategoryRepository - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إدارة بيانات الفئات فقط
abstract class CategoryRepository extends BaseRepository<CategoryEntity> {
  /// Create new category
  Future<Either<Failure, CategoryEntity>> addCategory(CategoryEntity category);

  /// Get categories with backward compatibility
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    int? mealTimeId,
  });

  /// Get categories by meal time
  Future<Either<Failure, List<CategoryEntity>>> getCategoriesByMealTime(
    int mealTimeId,
  );

  /// Get active categories only
  Future<Either<Failure, List<CategoryEntity>>> getActiveCategories();

  /// Get category by name
  Future<Either<Failure, CategoryEntity?>> getCategoryByName(String name);
}
