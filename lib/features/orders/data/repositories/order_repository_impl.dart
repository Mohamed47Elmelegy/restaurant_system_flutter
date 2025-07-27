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
