import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';
import 'dart:developer';
import 'dart:convert';

/// 🟦 ProductLocalDataSource - للتخزين المحلي للمنتجات باستخدام Hive
///
/// يوفر وظائف التخزين المحلي للمنتجات:
/// - حفظ المنتجات محلياً
/// - جلب المنتجات من التخزين المحلي
/// - مسح البيانات المحلية
/// - إدارة الـ cache
abstract class ProductLocalDataSource {
  /// حفظ المنتجات محلياً
  Future<void> saveProducts(List<ProductModel> products);

  /// جلب المنتجات من التخزين المحلي
  Future<List<ProductModel>> getProducts();

  /// جلب منتج بواسطة المعرف
  Future<ProductModel?> getProductById(String id);

  /// البحث في المنتجات المحلية
  Future<List<ProductModel>> searchProducts(String query);

  /// جلب المنتجات حسب الفئة
  Future<List<ProductModel>> getProductsByCategory(int categoryId);

  /// جلب المنتجات المميزة
  Future<List<ProductModel>> getFeaturedProducts();

  /// مسح جميع المنتجات
  Future<void> clearAllProducts();

  /// التحقق من وجود منتجات محلية
  Future<bool> hasProducts();

  /// حفظ منتج واحد
  Future<void> saveProduct(ProductModel product);

  /// حذف منتج واحد
  Future<void> deleteProduct(String id);

  /// تحديث حالة توفر المنتج
  Future<void> updateProductAvailability(String id, bool isAvailable);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String _boxName = 'admin_cache';
  static const String _storageKey = 'products';
  static const Duration _cacheDuration = Duration(hours: 2);

  @override
  Future<void> saveProducts(List<ProductModel> products) async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = {
        'items': products.map((item) => item.toJson()).toList(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await box.put(_storageKey, jsonEncode(data));
      log(
        '💾 ProductLocalDataSource: Saved ${products.length} products locally',
      );
    } catch (e) {
      log('❌ ProductLocalDataSource: Error saving products: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_storageKey);

      if (data == null) {
        log('📭 ProductLocalDataSource: No products found in local storage');
        return [];
      }

      final jsonData = jsonDecode(data);
      final items = (jsonData['items'] as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();

      log(
        '📥 ProductLocalDataSource: Retrieved ${items.length} products from local storage',
      );
      return items;
    } catch (e) {
      log('❌ ProductLocalDataSource: Error retrieving products: $e');
      return [];
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final products = await getProducts();
      final product = products.firstWhere(
        (product) => product.id == id,
        orElse: () => throw Exception('Product not found'),
      );
      log('📥 ProductLocalDataSource: Retrieved product with ID: $id');
      return product;
    } catch (e) {
      log('❌ ProductLocalDataSource: Error retrieving product by ID $id: $e');
      return null;
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final products = await getProducts();
      final filteredProducts = products.where((product) {
        final searchQuery = query.toLowerCase();
        return product.name.toLowerCase().contains(searchQuery) ||
            product.nameAr.toLowerCase().contains(searchQuery) ||
            (product.description?.toLowerCase().contains(searchQuery) ??
                false) ||
            (product.descriptionAr?.toLowerCase().contains(searchQuery) ??
                false);
      }).toList();

      log(
        '🔍 ProductLocalDataSource: Found ${filteredProducts.length} products matching "$query"',
      );
      return filteredProducts;
    } catch (e) {
      log('❌ ProductLocalDataSource: Error searching products: $e');
      return [];
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      final products = await getProducts();
      final categoryProducts = products.where((product) {
        return product.mainCategoryId == categoryId ||
            product.subCategoryId == categoryId;
      }).toList();

      log(
        '📂 ProductLocalDataSource: Found ${categoryProducts.length} products for category $categoryId',
      );
      return categoryProducts;
    } catch (e) {
      log('❌ ProductLocalDataSource: Error getting products by category: $e');
      return [];
    }
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final products = await getProducts();
      final featuredProducts = products
          .where((product) => product.isFeatured)
          .toList();

      log(
        '⭐ ProductLocalDataSource: Found ${featuredProducts.length} featured products',
      );
      return featuredProducts;
    } catch (e) {
      log('❌ ProductLocalDataSource: Error getting featured products: $e');
      return [];
    }
  }

  @override
  Future<void> clearAllProducts() async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.delete(_storageKey);
      log(
        '🗑️ ProductLocalDataSource: Cleared all products from local storage',
      );
    } catch (e) {
      log('❌ ProductLocalDataSource: Error clearing products: $e');
      rethrow;
    }
  }

  @override
  Future<bool> hasProducts() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_storageKey);

      if (data == null) return false;

      final jsonData = jsonDecode(data);
      final timestamp = jsonData['timestamp'] as int;
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      final isValid = now.difference(cacheTime) < _cacheDuration;

      log('🔍 ProductLocalDataSource: Has products in local storage: $isValid');
      return isValid;
    } catch (e) {
      log('❌ ProductLocalDataSource: Error checking if products exist: $e');
      return false;
    }
  }

  @override
  Future<void> saveProduct(ProductModel product) async {
    try {
      final products = await getProducts();
      final existingIndex = products.indexWhere((p) => p.id == product.id);

      if (existingIndex != -1) {
        products[existingIndex] = product;
      } else {
        products.add(product);
      }

      await saveProducts(products);
      log(
        '💾 ProductLocalDataSource: Saved/Updated product with ID: ${product.id}',
      );
    } catch (e) {
      log('❌ ProductLocalDataSource: Error saving single product: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final products = await getProducts();
      products.removeWhere((product) => product.id == id);
      await saveProducts(products);
      log('🗑️ ProductLocalDataSource: Deleted product with ID: $id');
    } catch (e) {
      log('❌ ProductLocalDataSource: Error deleting product: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateProductAvailability(String id, bool isAvailable) async {
    try {
      final products = await getProducts();
      final productIndex = products.indexWhere((product) => product.id == id);

      if (productIndex != -1) {
        final updatedProduct = ProductModel.fromIntId(
          id: int.tryParse(id),
          name: products[productIndex].name,
          nameAr: products[productIndex].nameAr,
          description: products[productIndex].description,
          descriptionAr: products[productIndex].descriptionAr,
          price: products[productIndex].price,
          mainCategoryId: products[productIndex].mainCategoryId,
          subCategoryId: products[productIndex].subCategoryId,
          imageUrl: products[productIndex].imageUrl,
          isAvailable: isAvailable,
          rating: products[productIndex].rating,
          reviewCount: products[productIndex].reviewCount,
          preparationTime: products[productIndex].preparationTime,
          ingredients: products[productIndex].ingredients,
          allergens: products[productIndex].allergens,
          isFeatured: products[productIndex].isFeatured,
          sortOrder: products[productIndex].sortOrder,
          createdAt: products[productIndex].createdAt,
          updatedAt: DateTime.now(),
        );

        products[productIndex] = updatedProduct;
        await saveProducts(products);
        log(
          '🔄 ProductLocalDataSource: Updated availability for product $id to $isAvailable',
        );
      }
    } catch (e) {
      log('❌ ProductLocalDataSource: Error updating product availability: $e');
      rethrow;
    }
  }
}
