import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import '../models/menu_item_model.dart';

class MenuRepositoryImpl implements MenuRepository {
  // In-memory storage for demo purposes
  // In real app, this would be replaced with API calls or local database
  final List<MenuItemModel> _menuItems = [
    const MenuItemModel(
      id: '1',
      name: 'Chicken Thai Biriyani',
      category: 'Breakfast',
      rating: 4.9,
      reviewCount: 10,
      price: '60',
      imagePath: 'assets/images/chickenburger.jpg',
    ),
    const MenuItemModel(
      id: '2',
      name: 'Chicken Bhuna',
      category: 'Breakfast',
      rating: 4.9,
      reviewCount: 10,
      price: '30',
      imagePath: 'assets/images/chickenburger.jpg',
    ),
    const MenuItemModel(
      id: '3',
      name: 'Mazalichiken Halim',
      category: 'Breakfast',
      rating: 4.9,
      reviewCount: 10,
      price: '25',
      imagePath: 'assets/images/chickenburger.jpg',
    ),
  ];

  @override
  Future<List<MenuItem>> getMenuItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _menuItems.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final filteredItems = _menuItems
        .where((item) => item.category.toLowerCase() == category.toLowerCase())
        .toList();
    return filteredItems.map((model) => model.toEntity()).toList();
  }

  @override
  Future<MenuItem?> getMenuItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final item = _menuItems.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('Menu item not found'),
    );
    return item.toEntity();
  }

  @override
  Future<MenuItem> addMenuItem(MenuItem menuItem) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final model = MenuItemModel.fromEntity(menuItem);
    _menuItems.add(model);
    return model.toEntity();
  }

  @override
  Future<MenuItem> updateMenuItem(MenuItem menuItem) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _menuItems.indexWhere((item) => item.id == menuItem.id);
    if (index == -1) {
      throw Exception('Menu item not found');
    }
    final updatedModel = MenuItemModel.fromEntity(menuItem);
    _menuItems[index] = updatedModel;
    return updatedModel.toEntity();
  }

  @override
  Future<bool> deleteMenuItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _menuItems.indexWhere((item) => item.id == id);
    if (index == -1) {
      return false;
    }
    _menuItems.removeAt(index);
    return true;
  }

  @override
  Future<List<MenuItem>> searchMenuItems(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final filteredItems = _menuItems
        .where(
          (item) =>
              item.name.toLowerCase().contains(query.toLowerCase()) ||
              item.category.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return filteredItems.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final categories = _menuItems.map((item) => item.category).toSet().toList();
    return categories;
  }

  // Additional helper methods for the model layer
  List<MenuItemModel> getAllMenuItems() {
    return List.unmodifiable(_menuItems);
  }

  void addMenuItemModel(MenuItemModel model) {
    _menuItems.add(model);
  }

  void updateMenuItemModel(MenuItemModel model) {
    final index = _menuItems.indexWhere((item) => item.id == model.id);
    if (index != -1) {
      _menuItems[index] = model;
    }
  }

  void deleteMenuItemModel(String id) {
    _menuItems.removeWhere((item) => item.id == id);
  }
}
