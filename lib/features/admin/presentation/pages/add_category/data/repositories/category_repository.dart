import 'package:dartz/dartz.dart';
import '../../../../../../../core/base/base_repository.dart';
import '../../../../../../../core/error/failures.dart';
import '../../domain/entities/main_category.dart';

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
}
