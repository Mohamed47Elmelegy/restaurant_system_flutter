import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<List<OrderEntity>> getRunningOrders() async {
    // Mock data based on the image description
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate API call

    return [
      OrderModel(
        id: 32053,
        name: 'Chicken Thai Biriyani',
        category: 'Breakfast',
        price: 60.0,
        status: 'running',
        createdAt: DateTime.now(),
      ),
      OrderModel(
        id: 15253,
        name: 'Chicken Bhuna',
        category: 'Breakfast',
        price: 30.0,
        status: 'running',
        createdAt: DateTime.now(),
      ),
      OrderModel(
        id: 21200,
        name: 'Vegetarian Poutine',
        category: 'Breakfast',
        price: 35.0,
        status: 'running',
        createdAt: DateTime.now(),
      ),
      OrderModel(
        id: 53241,
        name: 'Turkey Bacon Strips',
        category: 'Breakfast',
        price: 45.0,
        status: 'running',
        createdAt: DateTime.now(),
      ),
      OrderModel(
        id: 58464,
        name: 'Veggie Burrito',
        category: 'Breakfast',
        price: 25.0,
        status: 'running',
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<OrderEntity>> getNewOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      OrderModel(
        id: 12345,
        name: 'Margherita Pizza',
        category: 'Lunch',
        price: 40.0,
        status: 'new',
        createdAt: DateTime.now(),
      ),
      OrderModel(
        id: 67890,
        name: 'Caesar Salad',
        category: 'Lunch',
        price: 20.0,
        status: 'new',
        createdAt: DateTime.now(),
      ),
    ];
  }

  /// جلب الطلبات المكتملة لعرض الإيرادات
  Future<List<OrderEntity>> getCompletedOrders() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();

    return [
      // طلبات مكتملة في أوقات مختلفة من اليوم
      OrderModel(
        id: 1001,
        name: 'Margherita Pizza',
        category: 'Pizza',
        price: 45.0,
        status: 'completed',
        createdAt: DateTime(now.year, now.month, now.day, 9, 30), // 9:30 AM
      ),
      OrderModel(
        id: 1002,
        name: 'Chicken Burger',
        category: 'Burger',
        price: 35.0,
        status: 'completed',
        createdAt: DateTime(now.year, now.month, now.day, 10, 15), // 10:15 AM
      ),
      OrderModel(
        id: 1003,
        name: 'Caesar Salad',
        category: 'Salad',
        price: 25.0,
        status: 'completed',
        createdAt: DateTime(now.year, now.month, now.day, 11, 0), // 11:00 AM
      ),
      OrderModel(
        id: 1004,
        name: 'Pasta Carbonara',
        category: 'Pasta',
        price: 55.0,
        status: 'completed',
        createdAt: DateTime(now.year, now.month, now.day, 12, 30), // 12:30 PM
      ),
      OrderModel(
        id: 1005,
        name: 'Grilled Salmon',
        category: 'Seafood',
        price: 75.0,
        status: 'completed',
        createdAt: DateTime(now.year, now.month, now.day, 13, 45), // 1:45 PM
      ),
      OrderModel(
        id: 1006,
        name: 'Chocolate Cake',
        category: 'Dessert',
        price: 15.0,
        status: 'completed',
        createdAt: DateTime(now.year, now.month, now.day, 14, 20), // 2:20 PM
      ),
      OrderModel(
        id: 1007,
        name: 'Steak with Fries',
        category: 'Main Course',
        price: 85.0,
        status: 'completed',
        createdAt: DateTime(now.year, now.month, now.day, 15, 10), // 3:10 PM
      ),
      OrderModel(
        id: 1008,
        name: 'Ice Cream Sundae',
        category: 'Dessert',
        price: 12.0,
        status: 'completed',
        createdAt: DateTime(now.year, now.month, now.day, 16, 0), // 4:00 PM
      ),
      OrderModel(
        id: 1009,
        name: 'Chicken Wings',
        category: 'Appetizer',
        price: 28.0,
        status: 'completed',
        createdAt: DateTime(now.year, now.month, now.day, 17, 30), // 5:30 PM
      ),
      OrderModel(
        id: 1010,
        name: 'Beef Tacos',
        category: 'Mexican',
        price: 32.0,
        status: 'completed',
        createdAt: DateTime(now.year, now.month, now.day, 18, 15), // 6:15 PM
      ),
      OrderModel(
        id: 1011,
        name: 'Vegetable Curry',
        category: 'Indian',
        price: 38.0,
        status: 'completed',
        createdAt: DateTime(now.year, now.month, now.day, 19, 0), // 7:00 PM
      ),
      OrderModel(
        id: 1012,
        name: 'Tiramisu',
        category: 'Dessert',
        price: 18.0,
        status: 'completed',
        createdAt: DateTime(now.year, now.month, now.day, 20, 30), // 8:30 PM
      ),
    ];
  }

  @override
  Future<bool> markOrderAsDone(int orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real implementation, this would call the API
    return true;
  }

  @override
  Future<bool> cancelOrder(int orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real implementation, this would call the API
    return true;
  }
}
