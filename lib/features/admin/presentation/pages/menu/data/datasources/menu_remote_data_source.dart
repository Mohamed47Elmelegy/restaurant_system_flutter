import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../../../core/network/api_path.dart';
import '../models/menu_item_model.dart';

abstract class MenuRemoteDataSource {
  Future<List<MenuItemModel>> getMenuItems();
  Future<List<MenuItemModel>> getMenuItemsByCategory(String category);
  Future<MenuItemModel?> getMenuItemById(String id);
  Future<MenuItemModel> addMenuItem(MenuItemModel menuItem);
  Future<MenuItemModel> updateMenuItem(MenuItemModel menuItem);
  Future<bool> deleteMenuItem(String id);
  Future<List<MenuItemModel>> searchMenuItems(String query);
  Future<List<Map<String, dynamic>>> getCategories(); // إضافة دالة جلب الفئات
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;

  MenuRemoteDataSourceImpl({required this.dio})
    : storage = const FlutterSecureStorage();

  @override
  Future<List<MenuItemModel>> getMenuItems() async {
    try {
      // فحص وجود الـ token
      final token = await storage.read(key: 'token');
      log(
        '🔍 MenuRemoteDataSource: Token found: ${token != null ? 'Yes' : 'No'}',
      );

      final response = await dio.get(
        ApiPath.adminProducts(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      log(
        '🟢 MenuRemoteDataSource: Get products response status: ${response.statusCode}',
      );
      log(
        '🟢 MenuRemoteDataSource: Get products response data: ${response.data}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true) {
          final List<dynamic> productsData =
              responseData['data']['data'] ?? responseData['data'];
          return productsData
              .map((json) => _convertProductToMenuItem(json))
              .toList();
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to load menu items',
          );
        }
      } else {
        throw Exception('Failed to load menu items: ${response.statusCode}');
      }
    } catch (e) {
      log('🔴 MenuRemoteDataSource: Get products error: $e');
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<List<MenuItemModel>> getMenuItemsByCategory(String category) async {
    try {
      final token = await storage.read(key: 'token');

      // جلب الفئات من الباك إند أولاً
      final categories = await getCategories();
      final categoryId = _getCategoryIdFromBackend(category, categories);

      log(
        '🔄 MenuRemoteDataSource: Loading items for category: $category (ID: $categoryId)',
      );

      final response = await dio.get(
        ApiPath.adminProducts(),
        queryParameters: {'main_category_id': categoryId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      log(
        '🟢 MenuRemoteDataSource: Category response status: ${response.statusCode}',
      );
      log('🟢 MenuRemoteDataSource: Category response data: ${response.data}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true) {
          final List<dynamic> productsData =
              responseData['data']['data'] ?? responseData['data'];

          log(
            '📊 MenuRemoteDataSource: Raw products data count: ${productsData.length}',
          );

          final items = productsData
              .map((json) => _convertProductToMenuItem(json))
              .toList();

          log(
            '✅ MenuRemoteDataSource: Loaded ${items.length} items for category: $category',
          );
          log(
            '📋 MenuRemoteDataSource: Items categories: ${items.map((item) => item.category).toList()}',
          );

          return items;
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to load menu items by category',
          );
        }
      } else {
        throw Exception(
          'Failed to load menu items by category: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('🔴 MenuRemoteDataSource: Category error: $e');
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<MenuItemModel?> getMenuItemById(String id) async {
    try {
      final token = await storage.read(key: 'token');

      final response = await dio.get(
        ApiPath.adminProduct(int.parse(id)),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true) {
          return _convertProductToMenuItem(responseData['data']);
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to load menu item',
          );
        }
      } else {
        throw Exception('Failed to load menu item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<MenuItemModel> addMenuItem(MenuItemModel menuItem) async {
    try {
      final token = await storage.read(key: 'token');

      final response = await dio.post(
        ApiPath.adminProducts(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
        data: _convertMenuItemToProduct(menuItem),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true) {
          return _convertProductToMenuItem(responseData['data']);
        } else {
          throw Exception(responseData['message'] ?? 'Failed to add menu item');
        }
      } else {
        throw Exception('Failed to add menu item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<MenuItemModel> updateMenuItem(MenuItemModel menuItem) async {
    try {
      final token = await storage.read(key: 'token');

      final response = await dio.put(
        ApiPath.adminProduct(int.parse(menuItem.id)),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
        data: _convertMenuItemToProduct(menuItem),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true) {
          return _convertProductToMenuItem(responseData['data']);
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to update menu item',
          );
        }
      } else {
        throw Exception('Failed to update menu item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<bool> deleteMenuItem(String id) async {
    try {
      final token = await storage.read(key: 'token');

      final response = await dio.delete(
        ApiPath.adminProduct(int.parse(id)),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<List<MenuItemModel>> searchMenuItems(String query) async {
    try {
      final token = await storage.read(key: 'token');

      final response = await dio.get(
        ApiPath.adminProducts(),
        queryParameters: {'search': query},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true) {
          final List<dynamic> productsData =
              responseData['data']['data'] ?? responseData['data'];
          return productsData
              .map((json) => _convertProductToMenuItem(json))
              .toList();
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to search menu items',
          );
        }
      } else {
        throw Exception('Failed to search menu items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final token = await storage.read(key: 'token');
      log('🔄 MenuRemoteDataSource: Fetching categories from backend...');

      final response = await dio.get(
        ApiPath.adminCategories(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      log(
        '🟢 MenuRemoteDataSource: Categories response status: ${response.statusCode}',
      );
      log(
        '🟢 MenuRemoteDataSource: Categories response data: ${response.data}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        // Handle different response formats
        List<dynamic> categoriesData;
        if (responseData['success'] == true && responseData['data'] != null) {
          categoriesData = responseData['data'] as List<dynamic>;
        } else if (responseData['data'] != null) {
          categoriesData = responseData['data'] as List<dynamic>;
        } else {
          categoriesData = responseData as List<dynamic>;
        }

        final categories = List<Map<String, dynamic>>.from(categoriesData);

        log(
          '✅ MenuRemoteDataSource: Successfully loaded ${categories.length} categories from backend',
        );
        log(
          '📋 MenuRemoteDataSource: Categories: ${categories.map((cat) => cat['name']).toList()}',
        );

        return categories;
      } else {
        log(
          '❌ MenuRemoteDataSource: Failed to load categories - Status: ${response.statusCode}',
        );
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log(
        '🔴 MenuRemoteDataSource: DioException while fetching categories: ${e.message}',
      );
      log(
        '🔴 MenuRemoteDataSource: DioException response: ${e.response?.data}',
      );
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log(
        '🔴 MenuRemoteDataSource: Unexpected error while fetching categories: $e',
      );
      throw Exception('Unexpected error: $e');
    }
  }

  /// Convert Product from API to MenuItemModel
  MenuItemModel _convertProductToMenuItem(Map<String, dynamic> productJson) {
    final categoryName = productJson['main_category']?['name'] ?? 'Unknown';
    log(
      '🔄 MenuRemoteDataSource: Converting product - ID: ${productJson['id']}, Name: ${productJson['name']}, Category: $categoryName',
    );

    return MenuItemModel(
      id: productJson['id'].toString(),
      name: productJson['name'] ?? '',
      category: categoryName,
      rating: _parseDouble(productJson['rating']),
      reviewCount: productJson['review_count'] ?? 0,
      price: productJson['price'].toString(),
      imagePath: productJson['image_url'] ?? 'assets/images/chickenburger.jpg',
      description: productJson['description'],
      isAvailable: productJson['is_available'] ?? true,
    );
  }

  /// Convert MenuItemModel to Product for API
  Map<String, dynamic> _convertMenuItemToProduct(MenuItemModel menuItem) {
    return {
      'name': menuItem.name,
      'name_ar': menuItem.name,
      'description': menuItem.description ?? '',
      'description_ar': menuItem.description ?? '',
      'price': double.tryParse(menuItem.price) ?? 0.0,
      'main_category_id': _getCategoryId(menuItem.category),
      'is_available': menuItem.isAvailable,
      'image_url': menuItem.imagePath,
    };
  }

  /// Parse double values safely
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  /// Get category ID based on category name
  int _getCategoryId(String category) {
    switch (category.toLowerCase()) {
      case 'fast food':
        return 1; // Fast Food
      case 'pizza':
        return 2; // Pizza
      case 'beverages':
        return 3; // Beverages
      case 'breakfast':
        return 1; // Fast Food (legacy support)
      case 'lunch':
        return 2; // Pizza (legacy support)
      case 'dinner':
        return 3; // Beverages (legacy support)
      default:
        return 1; // Default to Fast Food
    }
  }

  /// Get category ID from backend categories based on frontend category name
  int _getCategoryIdFromBackend(
    String categoryName,
    List<Map<String, dynamic>> backendCategories,
  ) {
    final category = backendCategories.firstWhere(
      (cat) => cat['name'].toLowerCase() == categoryName.toLowerCase(),
      orElse: () => {'id': 1}, // Default to Fast Food if not found
    );
    return category['id'];
  }
}
