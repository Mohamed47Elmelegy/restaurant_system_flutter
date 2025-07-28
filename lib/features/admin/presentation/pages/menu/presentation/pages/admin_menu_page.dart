import 'package:flutter/material.dart';
import '../../data/models/menu_item_model.dart';
import '../widgets/menu_filter_tabs.dart';
import '../widgets/menu_item_card.dart';

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  State<AdminMenuPage> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = ['All', 'Breakfast', 'Lunch', 'Dinner'];

  // Sample menu items data using models
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
      category: 'Lunch',
      rating: 4.9,
      reviewCount: 10,
      price: '25',
      imagePath: 'assets/images/chickenburger.jpg',
    ),
  ];

  List<MenuItemModel> get _filteredItems {
    if (_selectedCategoryIndex == 0) {
      return _menuItems; // Show all items
    }
    return _menuItems
        .where((item) => item.category == _categories[_selectedCategoryIndex])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            // Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MenuFilterTabs(
                categories: _categories,
                selectedIndex: _selectedCategoryIndex,
                onCategorySelected: (index) {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            // Items Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Total ${_filteredItems.length} items',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Menu Items List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    return MenuItemCard(
                      name: item.name,
                      category: item.category,
                      rating: item.rating,
                      reviewCount: item.reviewCount,
                      price: item.price,
                      imagePath: item.imagePath,
                      onEdit: () => _onEditItem(item),
                      onDelete: () => _onDeleteItem(item),
                      onTap: () => _onItemTap(item),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Title
          const Expanded(
            child: Text(
              'My Food List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onEditItem(MenuItemModel item) {
    // Handle edit item
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit ${item.name}')));
  }

  void _onDeleteItem(MenuItemModel item) {
    // Handle delete item
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete ${item.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _menuItems.remove(item);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('${item.name} deleted')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _onItemTap(MenuItemModel item) {
    // Handle item tap
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Selected ${item.name}')));
  }
}
