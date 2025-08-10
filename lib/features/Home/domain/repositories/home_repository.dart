import 'package:dartz/dartz.dart';

import '../../../../core/entities/main_category.dart';
import '../../../../core/entities/product.dart';
import '../../../../core/error/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, CategoryEntity?>> getCategoryById(String id);
    /// Get category by name
  Future<Either<Failure, CategoryEntity?>> getCategoryByName(String name);


  Future<Either<Failure, List<ProductEntity>>> getPopularItems();
  Future<Either<Failure, List<ProductEntity>>> getRecommendedItems();

  /// Get products by category
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    int categoryId,
  );
}
