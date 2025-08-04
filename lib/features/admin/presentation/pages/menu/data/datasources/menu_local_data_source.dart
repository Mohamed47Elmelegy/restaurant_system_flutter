import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/menu_item_model.dart';
import 'dart:developer';
import 'dart:convert';

/// 🟦 MenuLocalDataSource - للتخزين المحلي للقوائم باستخدام Hive
///
/// يوفر وظائف التخزين المحلي للقوائم:
/// - حفظ عناصر القائمة محلياً
/// - جلب عناصر القائمة من التخزين المحلي
/// - مسح البيانات المحلية
/// - إدارة الـ cache
abstract class MenuLocalDataSource {
  /// حفظ عناصر القائمة محلياً
  Future<void> saveMenuItems(List<MenuItemModel> menuItems);

  /// جلب عناصر القائمة من التخزين المحلي
  Future<List<MenuItemModel>> getMenuItems();

  /// جلب عنصر قائمة بواسطة المعرف
  Future<MenuItemModel?> getMenuItemById(String id);

  /// البحث في عناصر القائمة المحلية
  Future<List<MenuItemModel>> searchMenuItems(String query);

  /// جلب عناصر القائمة حسب الفئة
  Future<List<MenuItemModel>> getMenuItemsByCategory(String category);

  /// جلب عناصر القائمة المتاحة فقط
  Future<List<MenuItemModel>> getAvailableMenuItems();

  /// جلب عناصر القائمة المميزة
  Future<List<MenuItemModel>> getFeaturedMenuItems();

  /// مسح جميع عناصر القائمة
  Future<void> clearAllMenuItems();

  /// التحقق من وجود عناصر قائمة محلية
  Future<bool> hasMenuItems();

  /// حفظ عنصر قائمة واحد
  Future<void> saveMenuItem(MenuItemModel menuItem);

  /// حذف عنصر قائمة واحد
  Future<void> deleteMenuItem(String id);

  /// تحديث حالة توفر عنصر القائمة
  Future<void> updateMenuItemAvailability(String id, bool isAvailable);

  /// جلب الفئات المحلية
  Future<List<Map<String, dynamic>>> getCategories();

  /// حفظ الفئات محلياً
  Future<void> saveCategories(List<Map<String, dynamic>> categories);
}

class MenuLocalDataSourceImpl implements MenuLocalDataSource {
  static const String _boxName = 'admin_cache';
  static const String _menuItemsKey = 'menu_items';
  static const String _categoriesKey = 'menu_categories';
  static const Duration _cacheDuration = const Duration(hours: 2);

  @override
  Future<void> saveMenuItems(List<MenuItemModel> menuItems) async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = {
        'items': menuItems.map((item) => item.toJson()).toList(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await box.put(_menuItemsKey, jsonEncode(data));
      log(
        '💾 MenuLocalDataSource: Saved ${menuItems.length} menu items locally',
      );
    } catch (e) {
      log('❌ MenuLocalDataSource: Error saving menu items: $e');
      rethrow;
    }
  }

  @override
  Future<List<MenuItemModel>> getMenuItems() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_menuItemsKey);

      if (data == null) {
        log('📭 MenuLocalDataSource: No menu items found in local storage');
        return [];
      }

      final jsonData = jsonDecode(data);
      final items = (jsonData['items'] as List)
          .map((item) => MenuItemModel.fromJson(item))
          .toList();

      log(
        '📥 MenuLocalDataSource: Retrieved ${items.length} menu items from local storage',
      );
      return items;
    } catch (e) {
      log('❌ MenuLocalDataSource: Error retrieving menu items: $e');
      return [];
    }
  }

  @override
  Future<MenuItemModel?> getMenuItemById(String id) async {
    try {
      final menuItems = await getMenuItems();
      final menuItem = menuItems.firstWhere(
        (item) => item.id == id,
        orElse: () => throw Exception('Menu item not found'),
      );
      log('📥 MenuLocalDataSource: Retrieved menu item with ID: $id');
      return menuItem;
    } catch (e) {
      log('❌ MenuLocalDataSource: Error retrieving menu item by ID $id: $e');
      return null;
    }
  }

  @override
  Future<List<MenuItemModel>> searchMenuItems(String query) async {
    try {
      final menuItems = await getMenuItems();
      final filteredItems = menuItems.where((item) {
        final searchQuery = query.toLowerCase();
        return item.name.toLowerCase().contains(searchQuery) ||
            (item.description?.toLowerCase().contains(searchQuery) ?? false);
      }).toList();

      log(
        '🔍 MenuLocalDataSource: Found ${filteredItems.length} menu items matching "$query"',
      );
      return filteredItems;
    } catch (e) {
      log('❌ MenuLocalDataSource: Error searching menu items: $e');
      return [];
    }
  }

  @override
  Future<List<MenuItemModel>> getMenuItemsByCategory(String category) async {
    try {
      final menuItems = await getMenuItems();
      final categoryItems = menuItems.where((item) {
        return item.category.toLowerCase() == category.toLowerCase();
      }).toList();

      log(
        '📂 MenuLocalDataSource: Found ${categoryItems.length} menu items for category $category',
      );
      return categoryItems;
    } catch (e) {
      log('❌ MenuLocalDataSource: Error getting menu items by category: $e');
      return [];
    }
  }

  @override
  Future<List<MenuItemModel>> getAvailableMenuItems() async {
    try {
      final menuItems = await getMenuItems();
      final availableItems = menuItems
          .where((item) => item.isAvailable)
          .toList();

      log(
        '✅ MenuLocalDataSource: Found ${availableItems.length} available menu items',
      );
      return availableItems;
    } catch (e) {
      log('❌ MenuLocalDataSource: Error getting available menu items: $e');
      return [];
    }
  }

  @override
  Future<List<MenuItemModel>> getFeaturedMenuItems() async {
    try {
      final menuItems = await getMenuItems();
      // MenuItemModel doesn't have isFeatured, so we'll return all items for now
      log('⭐ MenuLocalDataSource: Found ${menuItems.length} menu items');
      return menuItems;
    } catch (e) {
      log('❌ MenuLocalDataSource: Error getting featured menu items: $e');
      return [];
    }
  }

  @override
  Future<void> clearAllMenuItems() async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.delete(_menuItemsKey);
      await box.delete(_categoriesKey);
      log('🗑️ MenuLocalDataSource: Cleared all menu items from local storage');
    } catch (e) {
      log('❌ MenuLocalDataSource: Error clearing menu items: $e');
      rethrow;
    }
  }

  @override
  Future<bool> hasMenuItems() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_menuItemsKey);

      if (data == null) return false;

      final jsonData = jsonDecode(data);
      final timestamp = jsonData['timestamp'] as int;
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      final isValid = now.difference(cacheTime) < _cacheDuration;

      log('🔍 MenuLocalDataSource: Has menu items in local storage: $isValid');
      return isValid;
    } catch (e) {
      log('❌ MenuLocalDataSource: Error checking if menu items exist: $e');
      return false;
    }
  }

  @override
  Future<void> saveMenuItem(MenuItemModel menuItem) async {
    try {
      final menuItems = await getMenuItems();
      final existingIndex = menuItems.indexWhere(
        (item) => item.id == menuItem.id,
      );

      if (existingIndex != -1) {
        menuItems[existingIndex] = menuItem;
      } else {
        menuItems.add(menuItem);
      }

      await saveMenuItems(menuItems);
      log(
        '💾 MenuLocalDataSource: Saved/Updated menu item with ID: ${menuItem.id}',
      );
    } catch (e) {
      log('❌ MenuLocalDataSource: Error saving single menu item: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMenuItem(String id) async {
    try {
      final menuItems = await getMenuItems();
      menuItems.removeWhere((item) => item.id == id);
      await saveMenuItems(menuItems);
      log('🗑️ MenuLocalDataSource: Deleted menu item with ID: $id');
    } catch (e) {
      log('❌ MenuLocalDataSource: Error deleting menu item: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateMenuItemAvailability(String id, bool isAvailable) async {
    try {
      final menuItems = await getMenuItems();
      final itemIndex = menuItems.indexWhere((item) => item.id == id);

      if (itemIndex != -1) {
        final updatedItem = MenuItemModel(
          id: menuItems[itemIndex].id,
          name: menuItems[itemIndex].name,
          category: menuItems[itemIndex].category,
          rating: menuItems[itemIndex].rating,
          reviewCount: menuItems[itemIndex].reviewCount,
          price: menuItems[itemIndex].price,
          imagePath: menuItems[itemIndex].imagePath,
          description: menuItems[itemIndex].description,
          isAvailable: isAvailable,
        );

        menuItems[itemIndex] = updatedItem;
        await saveMenuItems(menuItems);
        log(
          '🔄 MenuLocalDataSource: Updated availability for menu item $id to $isAvailable',
        );
      }
    } catch (e) {
      log('❌ MenuLocalDataSource: Error updating menu item availability: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_categoriesKey);

      if (data == null) {
        log('📭 MenuLocalDataSource: No categories found in local storage');
        return [];
      }

      final jsonData = jsonDecode(data);
      final items = (jsonData['items'] as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      log(
        '📥 MenuLocalDataSource: Retrieved ${items.length} categories from local storage',
      );
      return items;
    } catch (e) {
      log('❌ MenuLocalDataSource: Error retrieving categories: $e');
      return [];
    }
  }

  @override
  Future<void> saveCategories(List<Map<String, dynamic>> categories) async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = {
        'items': categories,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await box.put(_categoriesKey, jsonEncode(data));
      log(
        '💾 MenuLocalDataSource: Saved ${categories.length} categories locally',
      );
    } catch (e) {
      log('❌ MenuLocalDataSource: Error saving categories: $e');
      rethrow;
    }
  }
}
