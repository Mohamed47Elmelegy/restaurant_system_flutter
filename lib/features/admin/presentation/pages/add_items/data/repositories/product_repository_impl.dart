import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../datasources/remoteDataSource/product_remote_data_source.dart';
import '../../../../../../../core/error/failures.dart';
import '../../../../../../../core/error/simple_error.dart';
import 'package:dartz/dartz.dart';

/// 🟦 ProductRepositoryImpl - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تنفيذ عمليات المنتجات فقط
///
/// 🟦 مبدأ الاستبدال (LSP)
/// يمكن استخدامه كـ ProductRepository أو BaseRepository<Product>
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final productModels = await remoteDataSource.getProducts();
      // ✅ استخدام toEntity() للتحويل
      final products = productModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get products: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    try {
      // ✅ استخدام fromEntity() بدلاً من إنشاء model يدوياً
      final productModel = ProductModel.fromEntity(product);

      final createdProductModel = await remoteDataSource.createProduct(
        productModel,
      );
      return Right(createdProductModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create product: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    try {
      // ✅ استخدام fromEntity() بدلاً من إنشاء model يدوياً
      final productModel = ProductModel.fromEntity(product);

      final updatedProductModel = await remoteDataSource.updateProduct(
        productModel,
      );
      return Right(updatedProductModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update product: $e'));
    }
  }

  @override
  Future<Either<Failure, Product?>> getProductById(int id) async {
    try {
      final productModel = await remoteDataSource.getProductById(id);
      return Right(productModel?.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get product: $e'));
    }
  }

  // 🟦 Implementation of BaseRepository methods

  @override
  Future<Either<Failure, List<Product>>> getAll() async {
    return getProducts();
  }

  @override
  Future<Either<Failure, Product?>> getById(String id) async {
    final intId = int.tryParse(id);
    if (intId == null) {
      return Left(ServerFailure(message: 'Invalid product ID: $id'));
    }
    return getProductById(intId);
  }

  @override
  Future<Either<Failure, Product>> add(Product item) async {
    return createProduct(item);
  }

  @override
  Future<Either<Failure, Product>> update(String id, Product item) async {
    // Ensure the item has the correct ID
    final updatedProduct = item.copyWith(id: id);
    return updateProduct(updatedProduct);
  }

  @override
  Future<Either<Failure, bool>> delete(String id) async {
    try {
      final intId = int.tryParse(id);
      if (intId == null) {
        return Left(ServerFailure(message: 'Invalid product ID: $id'));
      }

      // TODO: Implement deleteProduct method in ProductRemoteDataSource
      // await remoteDataSource.deleteProduct(intId);
      return Left(ServerFailure(message: 'Delete product not implemented yet'));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete product: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> search(String query) async {
    try {
      // TODO: Implement searchProducts method in ProductRemoteDataSource
      // final productModels = await remoteDataSource.searchProducts(query);
      // final products = productModels.map((model) => model.toEntity()).toList();
      // return Right(products);
      return Left(
        ServerFailure(message: 'Search products not implemented yet'),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to search products: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getPaginated({
    int page = 1,
    int limit = 10,
    String? sortBy,
    bool ascending = true,
  }) async {
    try {
      // TODO: Implement getProductsPaginated method in ProductRemoteDataSource
      // final productModels = await remoteDataSource.getProductsPaginated(
      //   page: page,
      //   limit: limit,
      //   sortBy: sortBy,
      //   ascending: ascending,
      // );
      // final products = productModels.map((model) => model.toEntity()).toList();
      // return Right(products);
      return Left(
        ServerFailure(message: 'Paginated products not implemented yet'),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get paginated products: $e'),
      );
    }
  }
}
