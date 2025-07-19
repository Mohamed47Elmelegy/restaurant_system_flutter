abstract class HomeDataSource {
  Future<List<Map<String, dynamic>>> getCategories();
  Future<List<Map<String, dynamic>>> getPopularItems();
  Future<List<Map<String, dynamic>>> getRecommendedItems();
  Future<List<Map<String, dynamic>>> getBanners();
}

class HomeDataSourceImpl implements HomeDataSource {
  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {'id': 1, 'name': 'Pizza', 'icon': '🍕', 'color': 0xFFFF6B6B},
      {'id': 2, 'name': 'Burger', 'icon': '🍔', 'color': 0xFF4ECDC4},
      {'id': 3, 'name': 'Sushi', 'icon': '🍣', 'color': 0xFF45B7D1},
      {'id': 4, 'name': 'Dessert', 'icon': '🍰', 'color': 0xFF96CEB4},
      {'id': 5, 'name': 'Drinks', 'icon': '🥤', 'color': 0xFFFECA57},
      {'id': 6, 'name': 'Salad', 'icon': '🥗', 'color': 0xFFDDA0DD},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getPopularItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'id': 1,
        'name': 'Margherita Pizza',
        'description': 'Classic tomato sauce with mozzarella',
        'price': 12.99,
        'rating': 4.5,
        'image': 'assets/images/pizza_margherita.jpg',
        'category': 'Pizza',
      },
      {
        'id': 2,
        'name': 'Chicken Burger',
        'description': 'Grilled chicken with fresh vegetables',
        'price': 8.99,
        'rating': 4.3,
        'image': 'assets/images/burger_chicken.jpg',
        'category': 'Burger',
      },
      {
        'id': 3,
        'name': 'California Roll',
        'description': 'Avocado, cucumber, and crab',
        'price': 15.99,
        'rating': 4.7,
        'image': 'assets/images/sushi_california.jpg',
        'category': 'Sushi',
      },
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendedItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'id': 4,
        'name': 'Chocolate Cake',
        'description': 'Rich chocolate with cream filling',
        'price': 6.99,
        'rating': 4.8,
        'image': 'assets/images/cake_chocolate.jpg',
        'category': 'Dessert',
      },
      {
        'id': 5,
        'name': 'Fresh Smoothie',
        'description': 'Mixed berries with yogurt',
        'price': 4.99,
        'rating': 4.4,
        'image': 'assets/images/smoothie_berries.jpg',
        'category': 'Drinks',
      },
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getBanners() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'id': 1,
        'title': 'Special Offer',
        'subtitle': '50% off on all pizzas',
        'image': 'assets/images/banner_pizza.jpg',
        'action': 'Order Now',
      },
      {
        'id': 2,
        'title': 'New Menu',
        'subtitle': 'Try our new sushi collection',
        'image': 'assets/images/banner_sushi.jpg',
        'action': 'Explore',
      },
    ];
  }
}
