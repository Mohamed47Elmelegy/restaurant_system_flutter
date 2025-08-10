import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/error/api_response.dart';
import '../../../../core/models/main_category_model.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/network/api_path.dart';

abstract class HomeDataSource {
  Future<ApiResponse<List<MainCategoryModel>>> getCategories();
  Future<ApiResponse<MainCategoryModel?>> getCategoryByName(String name);
  Future<ApiResponse<List<ProductModel>>> getPopularItems();
  Future<ApiResponse<List<ProductModel>>> getRecommendedItems();
  Future<ApiResponse<List<ProductModel>>> getAllProducts();
  Future<ApiResponse<List<ProductModel>>> getProductsByCategory(int categoryId);
  Future<ApiResponse<List<ProductModel>>> getNewProducts();

  Future<ApiResponse<MainCategoryModel?>> getCategoryById(int id);
}

class HomeDataSourceImpl implements HomeDataSource {
  final Dio dio;

  HomeDataSourceImpl(this.dio);

  @override
  Future<ApiResponse<List<MainCategoryModel>>> getCategories() async {
    try {
      log('🌐 HomeDataSourceImpl: Fetching categories from API...');

      final response = await dio.get(ApiPath.publicCategories());
      log('Response data: ${response.data}');
      final List<dynamic> data = response.data['data'];
      final categories = data
          .map((json) => MainCategoryModel.fromJson(json))
          .toList();

      log('✅ HomeDataSourceImpl: Loaded ${categories.length} categories');

      return ApiResponse.success(categories);
    } on DioException catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get categories - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ HomeDataSourceImpl: Unexpected error - $e');
      return ApiResponse.error('Failed to get categories: $e');
    }
  }

  @override
  Future<ApiResponse<List<ProductModel>>> getPopularItems() async {
    try {
      log('🔄 HomeDataSourceImpl: Getting popular products');

      final response = await dio.get(ApiPath.publicProductsPopular());

      // Fix: Access nested data structure - response.data['data']['data']
      final Map<String, dynamic> paginatedData = response.data['data'];
      final List<dynamic> data = paginatedData['data'];
      final products = data.map((json) => ProductModel.fromJson(json)).toList();

      log('✅ HomeDataSourceImpl: Popular products loaded - ${products.length}');
      return ApiResponse.success(products);
    } on DioException catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get popular products - $e');
      log('❌ HomeDataSourceImpl: DioException type - ${e.type}');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get popular products - $e');
      return ApiResponse.error('Failed to get popular products: $e');
    }
  }

  @override
  Future<ApiResponse<List<ProductModel>>> getRecommendedItems() async {
    try {
      log('🔄 HomeDataSourceImpl: Getting recommended products');

      final response = await dio.get(ApiPath.publicProductsRecommended());

      // Fix: Access nested data structure - response.data['data']['data']
      final Map<String, dynamic> paginatedData = response.data['data'];
      final List<dynamic> data = paginatedData['data'];
      final products = data.map((json) => ProductModel.fromJson(json)).toList();

      log(
        '✅ HomeDataSourceImpl: Recommended products loaded - ${products.length}',
      );
      return ApiResponse.success(products);
    } on DioException catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get recommended products - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get recommended products - $e');
      return ApiResponse.error('Failed to get recommended products: $e');
    }
  }

  /// Get new products
  Future<ApiResponse<List<ProductModel>>> getNewProducts() async {
    try {
      log('🔄 HomeDataSourceImpl: Getting new products');

      final response = await dio.get(ApiPath.publicProductsNew());

      // Fix: Access nested data structure - response.data['data']['data']
      final Map<String, dynamic> paginatedData = response.data['data'];
      final List<dynamic> data = paginatedData['data'];
      final products = data.map((json) => ProductModel.fromJson(json)).toList();

      log('✅ HomeDataSourceImpl: New products loaded - ${products.length}');
      return ApiResponse.success(products);
    } on DioException catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get new products - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get new products - $e');
      return ApiResponse.error('Failed to get new products: $e');
    }
  }

  @override
  Future<ApiResponse<List<ProductModel>>> getAllProducts() async {
    try {
      log('🔄 HomeDataSourceImpl: Getting all products');

      final response = await dio.get(ApiPath.publicProducts());

      // Fix: Access nested data structure - response.data['data']['data']
      final Map<String, dynamic> paginatedData = response.data['data'];
      final List<dynamic> data = paginatedData['data'];
      final products = data.map((json) => ProductModel.fromJson(json)).toList();

      log('✅ HomeDataSourceImpl: All products loaded - ${products.length}');
      return ApiResponse.success(products);
    } on DioException catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get all products - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get all products - $e');
      return ApiResponse.error('Failed to get all products: $e');
    }
  }

  @override
  Future<ApiResponse<List<ProductModel>>> getProductsByCategory(
    int categoryId,
  ) async {
    try {
      final response = await dio.get(
        ApiPath.publicCategoryProducts(categoryId),
      );
      log('Response data: ${response.data}');

      // Robust parsing: support both paginated map and direct list responses
      final dynamic root = response.data;
      List<dynamic> itemsJson;
      if (root is List) {
        itemsJson = root;
      } else if (root is Map<String, dynamic>) {
        final dynamic dataNode = root['data'];
        if (dataNode is List) {
          itemsJson = dataNode;
        } else if (dataNode is Map<String, dynamic>) {
          final dynamic innerData = dataNode['data'];
          if (innerData is List) {
            itemsJson = innerData;
          } else {
            throw TypeError();
          }
        } else {
          throw TypeError();
        }
      } else {
        throw TypeError();
      }

      final products = itemsJson
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      log(
        '✅ HomeDataSourceImpl: Products by category loaded - ${products.length}',
      );
      return ApiResponse.success(products);
    } on DioException catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get products by category - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get products by category - $e');
      return ApiResponse.error('Failed to get products by category: $e');
    }
  }

  @override
  Future<ApiResponse<MainCategoryModel?>> getCategoryById(int id) async {
    try {
      log('🔵 Category by ID Request - URL: ${ApiPath.publicCategory(id)}');

      final response = await dio.get(ApiPath.publicCategory(id));

      log('🟢 Category by ID Response Status: ${response.statusCode}');

      return ApiResponse.fromJson(response.data, (data) {
        if (data == null) return null;
        return MainCategoryModel.fromJson(data);
      });
    } on DioException catch (e) {
      log('🔴 Category by ID DioException: ${e.message}');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('🔴 Category by ID Unexpected Error: $e');
      return const ApiResponse<MainCategoryModel?>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<MainCategoryModel?>> getCategoryByName(String name) async {
    try {
      log('🔵 Category by Name Request - URL: ${ApiPath.publicCategories()}');

      final response = await dio.get(
        ApiPath.publicCategories(),
        queryParameters: {'name': name},
      );

      log('🟢 Category by Name Response Status: ${response.statusCode}');

      return ApiResponse.fromJson(response.data, (data) {
        if (data == null) return null;
        return MainCategoryModel.fromJson(data);
      });
    } on DioException catch (e) {
      log('🔴 Category by Name DioException: ${e.message}');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('🔴 Category by Name Unexpected Error: $e');
      return const ApiResponse<MainCategoryModel?>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }
}
