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

  /// Get category by ID
  Future<ApiResponse<MainCategoryModel?>> getCategoryById(int id);
}

class HomeDataSourceImpl implements HomeDataSource {
  final Dio dio;

  HomeDataSourceImpl(this.dio);

  @override
  Future<ApiResponse<List<MainCategoryModel>>> getCategories() async {
    try {
      log('🌐 HomeDataSourceImpl: Fetching categories from API...');

      final response = await dio.get(ApiPath.categories());
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
      log('🔄 HomeDataSourceImpl: Getting products');

      final response = await dio.get(ApiPath.products());

      // Fix: Access nested data structure - response.data['data']['data']
      final Map<String, dynamic> paginatedData = response.data['data'];
      final List<dynamic> data = paginatedData['data'];
      final products = data.map((json) => ProductModel.fromJson(json)).toList();

      log('✅ HomeDataSourceImpl: Products loaded - ${products.length}');
      return ApiResponse.success(products);
    } on DioException catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get products - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get products - $e');
      return ApiResponse.error('Failed to get products: $e');
    }
  }

  @override
  Future<ApiResponse<List<ProductModel>>> getRecommendedItems() async {
    try {
      log('🔄 HomeDataSourceImpl: Getting products');

      final response = await dio.get(ApiPath.products());

      // Fix: Access nested data structure - response.data['data']['data']
      final Map<String, dynamic> paginatedData = response.data['data'];
      final List<dynamic> data = paginatedData['data'];
      final products = data.map((json) => ProductModel.fromJson(json)).toList();

      log('✅ HomeDataSourceImpl: Products loaded - ${products.length}');
      return ApiResponse.success(products);
    } on DioException catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get products - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get products - $e');
      return ApiResponse.error('Failed to get products: $e');
    }
  }

  @override
  Future<ApiResponse<List<ProductModel>>> getAllProducts() async {
    try {
      log('🔄 HomeDataSourceImpl: Getting products');

      final response = await dio.get(ApiPath.products());

      // Fix: Access nested data structure - response.data['data']['data']
      final Map<String, dynamic> paginatedData = response.data['data'];
      final List<dynamic> data = paginatedData['data'];
      final products = data.map((json) => ProductModel.fromJson(json)).toList();

      log('✅ HomeDataSourceImpl: Products loaded - ${products.length}');
      return ApiResponse.success(products);
    } on DioException catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get products - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ HomeDataSourceImpl: Failed to get products - $e');
      return ApiResponse.error('Failed to get products: $e');
    }
  }

  @override
  Future<ApiResponse<List<ProductModel>>> getProductsByCategory(
    int categoryId,
  ) async {
    try {
      final response = await dio.get(ApiPath.categoryProducts(categoryId));
      log('Response data: ${response.data}');

      // Fix: Access nested data structure - response.data['data']['data']
      final Map<String, dynamic> paginatedData = response.data['data'];
      final List<dynamic> data = paginatedData['data'];
      final products = data.map((json) => ProductModel.fromJson(json)).toList();

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
      log('🔵 Category by ID Request - URL: ${ApiPath.categories()}/$id');

      final response = await dio.get('${ApiPath.categories()}/$id');

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
      log('🔵 Category by Name Request - URL: ${ApiPath.categories()}');

      final response = await dio.get(
        ApiPath.categories(),
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
