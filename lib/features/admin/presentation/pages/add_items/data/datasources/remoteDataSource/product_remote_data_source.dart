import '../../../../../../../../core/error/api_response.dart';
import '../../../../../../../../core/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ApiResponse<List<ProductModel>>> getProducts();
  Future<ApiResponse<ProductModel>> createProduct(ProductModel product);
  Future<ApiResponse<ProductModel>> updateProduct(ProductModel product);
  Future<ApiResponse<ProductModel>> getProductById(int id);
  Future<ApiResponse<bool>> deleteProduct(int id);
  Future<ApiResponse<bool>> toggleProductAvailability(int id);
  Future<ApiResponse<bool>> toggleProductFeatured(int id);
  Future<ApiResponse<List<ProductModel>>> getProductsByCategory(int categoryId);
}
