import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../datasources/remoteDataSource/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    try {
      final productModels = await remoteDataSource.getProducts();
      // ✅ استخدام toEntity() للتحويل
      return productModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      // ✅ استخدام fromEntity() بدلاً من إنشاء model يدوياً
      final productModel = ProductModel.fromEntity(product);

      final createdProductModel = await remoteDataSource.createProduct(
        productModel,
      );
      return createdProductModel.toEntity();
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      // ✅ استخدام fromEntity() بدلاً من إنشاء model يدوياً
      final productModel = ProductModel.fromEntity(product);

      final updatedProductModel = await remoteDataSource.updateProduct(
        productModel,
      );
      return updatedProductModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final productModel = await remoteDataSource.getProductById(id);
      return productModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }
}
