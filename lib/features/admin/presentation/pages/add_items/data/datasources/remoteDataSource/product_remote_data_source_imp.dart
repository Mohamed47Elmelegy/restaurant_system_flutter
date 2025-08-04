import 'package:dio/dio.dart';
import 'dart:developer';
import '../../../../../../../../core/error/api_response.dart';
import '../../../../../../../../core/network/api_path.dart';
import '../../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<ApiResponse<List<ProductModel>>> getProducts() async {
    try {
      log('🔄 ProductRemoteDataSourceImpl: Getting products');

      final response = await dio.get(ApiPath.adminProducts());

      final List<dynamic> data = response.data['data'];
      final products = data.map((json) => ProductModel.fromJson(json)).toList();

      log(
        '✅ ProductRemoteDataSourceImpl: Products loaded - ${products.length}',
      );
      return ApiResponse.success(products);
    } on DioException catch (e) {
      log('❌ ProductRemoteDataSourceImpl: Failed to get products - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ ProductRemoteDataSourceImpl: Failed to get products - $e');
      return ApiResponse.error('Failed to get products: $e');
    }
  }

  @override
  Future<ApiResponse<ProductModel>> createProduct(ProductModel product) async {
    try {
      log('🔄 ProductRemoteDataSourceImpl: Creating product - ${product.name}');

      final requestData = product.toJson();
      log('📤 ProductRemoteDataSourceImpl: Request data - $requestData');

      final response = await dio.post(
        ApiPath.adminProducts(),
        data: requestData,
      );

      log('✅ ProductRemoteDataSourceImpl: Product created successfully');
      return ApiResponse.success(ProductModel.fromJson(response.data['data']));
    } on DioException catch (e) {
      log('❌ ProductRemoteDataSourceImpl: DioException - ${e.type}');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ ProductRemoteDataSourceImpl: Unexpected error - $e');
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  @override
  Future<ApiResponse<ProductModel>> updateProduct(ProductModel product) async {
    try {
      log('🔄 ProductRemoteDataSourceImpl: Updating product - ${product.name}');

      final requestData = product.toJson();
      log('📤 ProductRemoteDataSourceImpl: Request data - $requestData');

      final response = await dio.put(
        ApiPath.adminProduct(int.parse(product.id!)),
        data: requestData,
      );

      log('✅ ProductRemoteDataSourceImpl: Product updated successfully');
      return ApiResponse.success(ProductModel.fromJson(response.data['data']));
    } on DioException catch (e) {
      log('❌ ProductRemoteDataSourceImpl: Failed to update product - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ ProductRemoteDataSourceImpl: Failed to update product - $e');
      return ApiResponse.error('Failed to update product: $e');
    }
  }

  @override
  Future<ApiResponse<ProductModel>> getProductById(int id) async {
    try {
      log('🔄 ProductRemoteDataSourceImpl: Getting product by ID - $id');

      final response = await dio.get(ApiPath.adminProduct(id));

      log('✅ ProductRemoteDataSourceImpl: Product loaded successfully');
      return ApiResponse.success(ProductModel.fromJson(response.data['data']));
    } on DioException catch (e) {
      log('❌ ProductRemoteDataSourceImpl: Failed to get product by ID - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ ProductRemoteDataSourceImpl: Failed to get product by ID - $e');
      return ApiResponse.error('Failed to get product by ID: $e');
    }
  }

  @override
  Future<ApiResponse<bool>> deleteProduct(int id) async {
    try {
      log('🔄 ProductRemoteDataSourceImpl: Deleting product - $id');

      await dio.delete(ApiPath.adminProduct(id));

      log('✅ ProductRemoteDataSourceImpl: Product deleted successfully');
      return ApiResponse.success(true);
    } on DioException catch (e) {
      log('❌ ProductRemoteDataSourceImpl: Failed to delete product - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ ProductRemoteDataSourceImpl: Failed to delete product - $e');
      return ApiResponse.error('Failed to delete product: $e');
    }
  }

  @override
  Future<ApiResponse<bool>> toggleProductAvailability(int id) async {
    try {
      log(
        '🔄 ProductRemoteDataSourceImpl: Toggling product availability - $id',
      );

      await dio.patch(ApiPath.adminProductToggleAvailability(id));

      log(
        '✅ ProductRemoteDataSourceImpl: Product availability toggled successfully',
      );
      return ApiResponse.success(true);
    } on DioException catch (e) {
      log(
        '❌ ProductRemoteDataSourceImpl: Failed to toggle product availability - $e',
      );
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log(
        '❌ ProductRemoteDataSourceImpl: Failed to toggle product availability - $e',
      );
      return ApiResponse.error('Failed to toggle product availability: $e');
    }
  }

  @override
  Future<ApiResponse<bool>> toggleProductFeatured(int id) async {
    try {
      log('🔄 ProductRemoteDataSourceImpl: Toggling product featured - $id');

      await dio.patch(ApiPath.adminProductToggleFeatured(id));

      log(
        '✅ ProductRemoteDataSourceImpl: Product featured toggled successfully',
      );
      return ApiResponse.success(true);
    } on DioException catch (e) {
      log(
        '❌ ProductRemoteDataSourceImpl: Failed to toggle product featured - $e',
      );
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log(
        '❌ ProductRemoteDataSourceImpl: Failed to toggle product featured - $e',
      );
      return ApiResponse.error('Failed to toggle product featured: $e');
    }
  }

  @override
  Future<ApiResponse<List<ProductModel>>> getProductsByCategory(
    int categoryId,
  ) async {
    try {
      log(
        '🔄 ProductRemoteDataSourceImpl: Getting products by category - $categoryId',
      );

      final response = await dio.get(ApiPath.adminCategoryProducts(categoryId));

      final List<dynamic> data = response.data['data'];
      final products = data.map((json) => ProductModel.fromJson(json)).toList();

      log(
        '✅ ProductRemoteDataSourceImpl: Products by category loaded - ${products.length}',
      );
      return ApiResponse.success(products);
    } on DioException catch (e) {
      log(
        '❌ ProductRemoteDataSourceImpl: Failed to get products by category - $e',
      );
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log(
        '❌ ProductRemoteDataSourceImpl: Failed to get products by category - $e',
      );
      return ApiResponse.error('Failed to get products by category: $e');
    }
  }
}
