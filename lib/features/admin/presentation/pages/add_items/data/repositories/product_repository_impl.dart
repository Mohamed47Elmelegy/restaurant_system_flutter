import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    try {
      final productModels = await remoteDataSource.getProducts();
      return productModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      final productModel = ProductModel(
        name: product.name,
        nameAr: product.nameAr,
        description: product.description,
        descriptionAr: product.descriptionAr,
        price: product.price,
        mainCategoryId: product.mainCategoryId,
        subCategoryId: product.subCategoryId,
        imageUrl: product.imageUrl,
        isAvailable: product.isAvailable,
        rating: product.rating,
        reviewCount: product.reviewCount,
        preparationTime: product.preparationTime,
        ingredients: product.ingredients,
        allergens: product.allergens,
        isFeatured: product.isFeatured,
        sortOrder: product.sortOrder,
      );

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
      final productModel = ProductModel(
        id: product.id,
        name: product.name,
        nameAr: product.nameAr,
        description: product.description,
        descriptionAr: product.descriptionAr,
        price: product.price,
        mainCategoryId: product.mainCategoryId,
        subCategoryId: product.subCategoryId,
        imageUrl: product.imageUrl,
        isAvailable: product.isAvailable,
        rating: product.rating,
        reviewCount: product.reviewCount,
        preparationTime: product.preparationTime,
        ingredients: product.ingredients,
        allergens: product.allergens,
        isFeatured: product.isFeatured,
        sortOrder: product.sortOrder,
      );

      final updatedProductModel = await remoteDataSource.updateProduct(
        productModel,
      );
      return updatedProductModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await remoteDataSource.deleteProduct(id);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
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
