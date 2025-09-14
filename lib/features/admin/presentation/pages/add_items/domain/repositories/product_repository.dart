import 'package:dartz/dartz.dart';

import '../../../../../../../core/base/base_repository.dart';
import '../../../../../../../core/entities/product.dart';
import '../../../../../../../core/error/failures.dart';

/// 🟦 ProductRepository - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحديد عمليات المنتجات فقط
///
/// 🟦 مبدأ الفتح والإغلاق (OCP)
/// يمكن إضافة repositories جديدة بدون تعديل BaseRepository
///
/// 🟦 مبدأ الاستبدال (LSP)
/// يمكن استخدام ProductRepository كـ BaseRepository<Product>
abstract class ProductRepository extends BaseRepository<ProductEntity> {
  /// Get products with backward compatibility
  Future<Either<Failure, List<ProductEntity>>> getProducts();

  /// Create product with backward compatibility
  Future<Either<Failure, ProductEntity>> createProduct(ProductEntity product);

  /// Update product with backward compatibility
  Future<Either<Failure, ProductEntity>> updateProduct(ProductEntity product);

  /// Get product by int id for backward compatibility
  Future<Either<Failure, ProductEntity?>> getProductById(int id);

  /// Delete product by int id
  Future<Either<Failure, bool>> deleteProduct(int id);

  /// Toggle product availability
  Future<Either<Failure, bool>> toggleProductAvailability(int id);

  /// Toggle product featured status
  Future<Either<Failure, bool>> toggleProductFeatured(int id);

  /// Get products by category
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    int categoryId,
  );
}
