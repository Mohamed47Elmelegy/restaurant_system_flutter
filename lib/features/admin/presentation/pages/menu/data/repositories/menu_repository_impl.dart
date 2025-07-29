import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import '../models/menu_item_model.dart';
import '../datasources/menu_remote_data_source.dart';
import 'dart:developer';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MenuItem>> getMenuItems() async {
    try {
      final menuItemModels = await remoteDataSource.getMenuItems();
      return menuItemModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get menu items: $e');
    }
  }

  @override
  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    try {
      final menuItemModels = await remoteDataSource.getMenuItemsByCategory(
        category,
      );
      return menuItemModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get menu items by category: $e');
    }
  }

  @override
  Future<MenuItem?> getMenuItemById(String id) async {
    try {
      final menuItemModel = await remoteDataSource.getMenuItemById(id);
      return menuItemModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to get menu item: $e');
    }
  }

  @override
  Future<MenuItem> addMenuItem(MenuItem menuItem) async {
    try {
      final menuItemModel = MenuItemModel.fromEntity(menuItem);
      final createdMenuItemModel = await remoteDataSource.addMenuItem(
        menuItemModel,
      );
      return createdMenuItemModel.toEntity();
    } catch (e) {
      throw Exception('Failed to add menu item: $e');
    }
  }

  @override
  Future<MenuItem> updateMenuItem(MenuItem menuItem) async {
    try {
      final menuItemModel = MenuItemModel.fromEntity(menuItem);
      final updatedMenuItemModel = await remoteDataSource.updateMenuItem(
        menuItemModel,
      );
      return updatedMenuItemModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update menu item: $e');
    }
  }

  @override
  Future<bool> deleteMenuItem(String id) async {
    try {
      return await remoteDataSource.deleteMenuItem(id);
    } catch (e) {
      throw Exception('Failed to delete menu item: $e');
    }
  }

  @override
  Future<List<MenuItem>> searchMenuItems(String query) async {
    try {
      final menuItemModels = await remoteDataSource.searchMenuItems(query);
      return menuItemModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search menu items: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      log('🔄 MenuRepository: Starting getCategories process...');

      // جلب الفئات من الباك إند
      final categoriesData = await remoteDataSource.getCategories();

      if (categoriesData.isEmpty) {
        log(
          '⚠️ MenuRepository: No categories received from backend, using fallback',
        );
        return [
          'Fast Food',
          'Pizza',
          'Beverages',
          'Desserts',
          'Salads',
          'Drinks',
          'Appetizers',
          'Main Course',
        ];
      }

      final categories = categoriesData
          .map((cat) => cat['name'] as String)
          .where((name) => name.isNotEmpty) // Filter out empty names
          .toList();

      log(
        '✅ MenuRepository: Successfully loaded ${categories.length} categories from backend',
      );
      log('📋 MenuRepository: Categories: $categories');

      return categories;
    } catch (e) {
      log('❌ MenuRepository: Failed to get categories from backend - $e');
      log('🔄 MenuRepository: Using fallback categories');

      // Fallback to static categories if backend fails
      return [
        'Fast Food',
        'Pizza',
        'Beverages',
        'Desserts',
        'Salads',
        'Drinks',
        'Appetizers',
        'Main Course',
      ];
    }
  }
}
