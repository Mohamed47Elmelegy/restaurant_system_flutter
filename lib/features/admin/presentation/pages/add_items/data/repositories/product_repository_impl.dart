import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../datasources/remoteDataSource/product_remote_data_source.dart';
import '../datasources/product_local_data_source.dart';
import '../../../../../../../core/error/failures.dart';
import '../../../../../../../core/error/api_response.dart';
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
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      // 1. محاولة جلب البيانات من الـ local أولاً
      final localProducts = await localDataSource.getProducts();
      if (localProducts.isNotEmpty) {
        print(
          '📱 ProductRepository: Using local data - ${localProducts.length} products',
        );
        final products = localProducts
            .map((model) => model.toEntity())
            .toList();
        return Right(products);
      }

      // 2. جلب البيانات من الـ API
      print('🌐 ProductRepository: Fetching from API...');
      final response = await remoteDataSource.getProducts();

      if (response.status) {
        final products = response.data!
            .map((model) => model.toEntity())
            .toList();

        // 3. حفظ البيانات محلياً
        if (products.isNotEmpty) {
          final productModels = products
              .map((entity) => ProductModel.fromEntity(entity))
              .toList();
          await localDataSource.saveProducts(productModels);
          print(
            '💾 ProductRepository: Saved ${products.length} products to local storage',
          );
        }

        return Right(products);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ ProductRepository: Error getting products - $e');
      return Left(ServerFailure(message: 'Failed to get products: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final response = await remoteDataSource.createProduct(productModel);

      if (response.status) {
        final createdProduct = response.data!.toEntity();

        // حفظ المنتج الجديد محلياً
        await localDataSource.saveProduct(response.data!);
        print('💾 ProductRepository: Saved new product to local storage');

        return Right(createdProduct);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ ProductRepository: Error creating product - $e');
      return Left(ServerFailure(message: 'Failed to create product: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final response = await remoteDataSource.updateProduct(productModel);

      if (response.status) {
        final updatedProduct = response.data!.toEntity();

        // تحديث المنتج محلياً
        await localDataSource.saveProduct(response.data!);
        print('💾 ProductRepository: Updated product in local storage');

        return Right(updatedProduct);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ ProductRepository: Error updating product - $e');
      return Left(ServerFailure(message: 'Failed to update product: $e'));
    }
  }

  @override
  Future<Either<Failure, Product?>> getProductById(int id) async {
    try {
      // 1. محاولة جلب المنتج من الـ local أولاً
      final localProduct = await localDataSource.getProductById(id.toString());
      if (localProduct != null) {
        print(
          '📱 ProductRepository: Using local product - ${localProduct.name}',
        );
        return Right(localProduct.toEntity());
      }

      // 2. جلب المنتج من الـ API
      print('🌐 ProductRepository: Fetching product from API...');
      final response = await remoteDataSource.getProductById(id);

      if (response.status && response.data != null) {
        final product = response.data!.toEntity();

        // 3. حفظ المنتج محلياً
        await localDataSource.saveProduct(response.data!);
        print('💾 ProductRepository: Saved product to local storage');

        return Right(product);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ ProductRepository: Error getting product by ID - $e');
      return Left(ServerFailure(message: 'Failed to get product: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(int id) async {
    try {
      final response = await remoteDataSource.deleteProduct(id);

      if (response.status && response.data == true) {
        // حذف المنتج من التخزين المحلي
        await localDataSource.deleteProduct(id.toString());
        print('🗑️ ProductRepository: Deleted product from local storage');

        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ ProductRepository: Error deleting product - $e');
      return Left(ServerFailure(message: 'Failed to delete product: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleProductAvailability(int id) async {
    try {
      final response = await remoteDataSource.toggleProductAvailability(id);

      if (response.status && response.data == true) {
        // تحديث حالة التوفر محلياً
        await localDataSource.updateProductAvailability(id.toString(), true);
        print(
          '💾 ProductRepository: Updated product availability in local storage',
        );

        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ ProductRepository: Error toggling product availability - $e');
      return Left(
        ServerFailure(message: 'Failed to toggle product availability: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> toggleProductFeatured(int id) async {
    try {
      final response = await remoteDataSource.toggleProductFeatured(id);

      if (response.status && response.data == true) {
        // تحديث حالة التميز محلياً (نستخدم updateProductAvailability كبديل مؤقت)
        await localDataSource.updateProductAvailability(id.toString(), true);
        print(
          '💾 ProductRepository: Updated product featured status in local storage',
        );

        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ ProductRepository: Error toggling product featured - $e');
      return Left(
        ServerFailure(message: 'Failed to toggle product featured: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    int categoryId,
  ) async {
    try {
      // 1. محاولة جلب المنتجات من الـ local أولاً
      final localProducts = await localDataSource.getProductsByCategory(
        categoryId,
      );
      if (localProducts.isNotEmpty) {
        print(
          '📱 ProductRepository: Using local products for category $categoryId - ${localProducts.length} products',
        );
        final products = localProducts
            .map((model) => model.toEntity())
            .toList();
        return Right(products);
      }

      // 2. جلب المنتجات من الـ API
      print('🌐 ProductRepository: Fetching products by category from API...');
      final response = await remoteDataSource.getProductsByCategory(categoryId);

      if (response.status) {
        final products = response.data!
            .map((model) => model.toEntity())
            .toList();

        // 3. حفظ المنتجات محلياً
        if (products.isNotEmpty) {
          final productModels = products
              .map((entity) => ProductModel.fromEntity(entity))
              .toList();
          await localDataSource.saveProducts(productModels);
          print(
            '💾 ProductRepository: Saved products by category to local storage',
          );
        }

        return Right(products);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ ProductRepository: Error getting products by category - $e');
      return Left(
        ServerFailure(message: 'Failed to get products by category: $e'),
      );
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

      return deleteProduct(intId);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete product: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> search(String query) async {
    try {
      // 1. محاولة البحث في البيانات المحلية أولاً
      final localSearchResults = await localDataSource.searchProducts(query);
      if (localSearchResults.isNotEmpty) {
        print(
          '📱 ProductRepository: Using local search results - ${localSearchResults.length} products',
        );
        final products = localSearchResults
            .map((model) => model.toEntity())
            .toList();
        return Right(products);
      }

      // 2. البحث في الـ API
      print('🌐 ProductRepository: Searching in API...');
      // TODO: Implement searchProducts method in ProductRemoteDataSource
      return Left(
        ServerFailure(message: 'Search products not implemented yet'),
      );
    } catch (e) {
      print('❌ ProductRepository: Error searching products - $e');
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
      // 1. محاولة جلب البيانات المحلية أولاً
      final localProducts = await localDataSource.getProducts();
      if (localProducts.isNotEmpty) {
        print(
          '📱 ProductRepository: Using local paginated data - ${localProducts.length} products',
        );
        final products = localProducts
            .map((model) => model.toEntity())
            .toList();

        // تطبيق الـ pagination على البيانات المحلية
        final startIndex = (page - 1) * limit;
        final endIndex = startIndex + limit;
        final paginatedProducts = products.length > startIndex
            ? products.sublist(
                startIndex,
                endIndex > products.length ? products.length : endIndex,
              )
            : <Product>[];

        return Right(paginatedProducts);
      }

      // 2. جلب البيانات من الـ API
      print('🌐 ProductRepository: Fetching paginated data from API...');
      // TODO: Implement getProductsPaginated method in ProductRemoteDataSource
      return Left(
        ServerFailure(message: 'Paginated products not implemented yet'),
      );
    } catch (e) {
      print('❌ ProductRepository: Error getting paginated products - $e');
      return Left(
        ServerFailure(message: 'Failed to get paginated products: $e'),
      );
    }
  }
}
