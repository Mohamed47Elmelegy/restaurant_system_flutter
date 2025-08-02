import '../entities/product.dart';
import '../../../../../../../core/base/base_repository.dart';
import '../../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

/// 🟦 ProductRepository - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحديد عمليات المنتجات فقط
///
/// 🟦 مبدأ الفتح والإغلاق (OCP)
/// يمكن إضافة repositories جديدة بدون تعديل BaseRepository
///
/// 🟦 مبدأ الاستبدال (LSP)
/// يمكن استخدام ProductRepository كـ BaseRepository<Product>
abstract class ProductRepository extends BaseRepository<Product> {
  /// Get products with backward compatibility
  Future<Either<Failure, List<Product>>> getProducts();

  /// Create product with backward compatibility
  Future<Either<Failure, Product>> createProduct(Product product);

  /// Update product with backward compatibility
  Future<Either<Failure, Product>> updateProduct(Product product);

  /// Get product by int id for backward compatibility
  Future<Either<Failure, Product?>> getProductById(int id);
}
