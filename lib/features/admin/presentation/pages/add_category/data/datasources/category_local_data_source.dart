import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../../core/models/main_category_model.dart';
import 'dart:developer';
import 'dart:convert';

/// 🟦 CategoryLocalDataSource - للتخزين المحلي للفئات باستخدام Hive
///
/// يوفر وظائف التخزين المحلي للفئات:
/// - حفظ الفئات محلياً
/// - جلب الفئات من التخزين المحلي
/// - مسح البيانات المحلية
/// - إدارة الـ cache
abstract class CategoryLocalDataSource {
  /// حفظ الفئات الرئيسية محلياً
  Future<void> saveMainCategories(List<MainCategoryModel> categories);

  /// جلب الفئات الرئيسية من التخزين المحلي
  Future<List<MainCategoryModel>> getMainCategories();

  /// جلب فئة رئيسية بواسطة المعرف
  Future<MainCategoryModel?> getMainCategoryById(String id);

  /// البحث في الفئات المحلية
  Future<List<MainCategoryModel>> searchMainCategories(String query);

  /// جلب الفئات النشطة فقط
  Future<List<MainCategoryModel>> getActiveMainCategories();

  /// مسح جميع الفئات
  Future<void> clearAllCategories();

  /// التحقق من وجود فئات محلية
  Future<bool> hasCategories();

  /// حفظ فئة رئيسية واحدة
  Future<void> saveMainCategory(MainCategoryModel category);

  /// حذف فئة رئيسية واحدة
  Future<void> deleteMainCategory(String id);

}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  static const String _boxName = 'admin_cache';
  static const String _mainCategoriesKey = 'main_categories';
  static const Duration _cacheDuration = Duration(
    hours: 3,
  ); // فئات تحتاج cache أطول

  // Main Categories Methods
  @override
  Future<void> saveMainCategories(List<MainCategoryModel> categories) async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = {
        'items': categories.map((item) => item.toJson()).toList(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await box.put(_mainCategoriesKey, jsonEncode(data));
      log(
        '💾 CategoryLocalDataSource: Saved ${categories.length} main categories locally',
      );
    } catch (e) {
      log('❌ CategoryLocalDataSource: Error saving main categories: $e');
      rethrow;
    }
  }

  @override
  Future<List<MainCategoryModel>> getMainCategories() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_mainCategoriesKey);

      if (data == null) {
        log(
          '📭 CategoryLocalDataSource: No main categories found in local storage',
        );
        return [];
      }

      final jsonData = jsonDecode(data);
      final items = (jsonData['items'] as List)
          .map((item) => MainCategoryModel.fromJson(item))
          .toList();

      log(
        '📥 CategoryLocalDataSource: Retrieved ${items.length} main categories from local storage',
      );
      return items;
    } catch (e) {
      log('❌ CategoryLocalDataSource: Error retrieving main categories: $e');
      return [];
    }
  }

  @override
  Future<MainCategoryModel?> getMainCategoryById(String id) async {
    try {
      final categories = await getMainCategories();
      final category = categories.firstWhere(
        (category) => category.id == id,
        orElse: () => throw Exception('Main category not found'),
      );
      log('📥 CategoryLocalDataSource: Retrieved main category with ID: $id');
      return category;
    } catch (e) {
      log(
        '❌ CategoryLocalDataSource: Error retrieving main category by ID $id: $e',
      );
      return null;
    }
  }

  @override
  Future<List<MainCategoryModel>> searchMainCategories(String query) async {
    try {
      final categories = await getMainCategories();
      final filteredCategories = categories.where((category) {
        final searchQuery = query.toLowerCase();
        return category.name.toLowerCase().contains(searchQuery) ||
            (category.description?.toLowerCase().contains(searchQuery) ??
                false);

      }).toList();

      log(
        '🔍 CategoryLocalDataSource: Found ${filteredCategories.length} main categories matching "$query"',
      );
      return filteredCategories;
    } catch (e) {
      log('❌ CategoryLocalDataSource: Error searching main categories: $e');
      return [];
    }
  }

  @override
  Future<List<MainCategoryModel>> getActiveMainCategories() async {
    try {
      final categories = await getMainCategories();
      final activeCategories = categories
          .where((category) => category.isActive)
          .toList();

      log(
        '✅ CategoryLocalDataSource: Found ${activeCategories.length} active main categories',
      );
      return activeCategories;
    } catch (e) {
      log(
        '❌ CategoryLocalDataSource: Error getting active main categories: $e',
      );
      return [];
    }
  }

  @override
  Future<void> clearAllCategories() async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.delete(_mainCategoriesKey);
      log(
        '🗑️ CategoryLocalDataSource: Cleared all categories from local storage',
      );
    } catch (e) {
      log('❌ CategoryLocalDataSource: Error clearing categories: $e');
      rethrow;
    }
  }

  @override
  Future<bool> hasCategories() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_mainCategoriesKey);

      if (data == null) return false;

      final jsonData = jsonDecode(data);
      final timestamp = jsonData['timestamp'] as int;
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      final isValid = now.difference(cacheTime) < _cacheDuration;

      log(
        '🔍 CategoryLocalDataSource: Has categories in local storage: $isValid',
      );
      return isValid;
    } catch (e) {
      log('❌ CategoryLocalDataSource: Error checking if categories exist: $e');
      return false;
    }
  }

  @override
  Future<void> saveMainCategory(MainCategoryModel category) async {
    try {
      final categories = await getMainCategories();
      final existingIndex = categories.indexWhere((c) => c.id == category.id);

      if (existingIndex != -1) {
        categories[existingIndex] = category;
      } else {
        categories.add(category);
      }

      await saveMainCategories(categories);
      log(
        '💾 CategoryLocalDataSource: Saved/Updated main category with ID: ${category.id}',
      );
    } catch (e) {
      log('❌ CategoryLocalDataSource: Error saving single main category: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMainCategory(String id) async {
    try {
      final categories = await getMainCategories();
      categories.removeWhere((category) => category.id == id);
      await saveMainCategories(categories);
      log('🗑️ CategoryLocalDataSource: Deleted main category with ID: $id');
    } catch (e) {
      log('❌ CategoryLocalDataSource: Error deleting main category: $e');
      rethrow;
    }
  }


}
