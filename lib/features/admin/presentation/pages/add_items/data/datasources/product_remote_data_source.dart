import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';
import '../../../../../../../core/network/api_path.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(int id);
  Future<ProductModel> getProductById(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;

  ProductRemoteDataSourceImpl({required this.dio})
    : storage = FlutterSecureStorage();

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get(
        ApiPath.adminProducts(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true) {
          final List<dynamic> productsData = responseData['data'];
          return productsData
              .map((json) => ProductModel.fromJson(json))
              .toList();
        } else {
          throw Exception(responseData['message'] ?? 'Failed to load products');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      // فحص وجود الـ token
      final token = await storage.read(key: 'token');
      log(
        '🔍 ProductRemoteDataSource: Token found: ${token != null ? 'Yes' : 'No'}',
      );

      if (token != null) {
        log(
          '🔍 ProductRemoteDataSource: Token preview: ${token.substring(0, 10)}...',
        );
      }

      final response = await dio.post(
        ApiPath.adminProducts(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: product.toJson(),
      );

      log(
        '🟢 ProductRemoteDataSource: Create product response status: ${response.statusCode}',
      );
      log(
        '🟢 ProductRemoteDataSource: Create product response data: ${response.data}',
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true) {
          return ProductModel.fromJson(responseData['data']);
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to create product',
          );
        }
      } else {
        throw Exception('Failed to create product: ${response.statusCode}');
      }
    } catch (e) {
      log('🔴 ProductRemoteDataSource: Create product error: $e');
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final response = await dio.put(
        ApiPath.adminProduct(product.id!),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: product.toJson(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true) {
          return ProductModel.fromJson(responseData['data']);
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to update product',
          );
        }
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      final response = await dio.delete(
        ApiPath.adminProduct(id),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        final Map<String, dynamic> responseData = response.data;
        throw Exception(responseData['message'] ?? 'Failed to delete product');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await dio.get(
        ApiPath.adminProduct(id),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true) {
          return ProductModel.fromJson(responseData['data']);
        } else {
          throw Exception(responseData['message'] ?? 'Failed to load product');
        }
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
