import '../entities/menu_item.dart';

abstract class MenuRepository {
  /// Get all menu items
  Future<List<MenuItem>> getMenuItems();

  /// Get menu items by category
  Future<List<MenuItem>> getMenuItemsByCategory(String category);

  /// Get a single menu item by ID
  Future<MenuItem?> getMenuItemById(String id);

  /// Add a new menu item
  Future<MenuItem> addMenuItem(MenuItem menuItem);

  /// Update an existing menu item
  Future<MenuItem> updateMenuItem(MenuItem menuItem);

  /// Delete a menu item
  Future<bool> deleteMenuItem(String id);

  /// Search menu items by name
  Future<List<MenuItem>> searchMenuItems(String query);

  /// Get available categories
  Future<List<String>> getCategories();
}
