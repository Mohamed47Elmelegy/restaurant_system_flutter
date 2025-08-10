import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';

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
        userId: 1,
        orderNumber: '1234567890',
        status: 'running',
        totalAmount: 60.0,
        items: [
          OrderItemModel(
            id: 1,
            productId: 1,
            productName: 'Chicken Thai Biriyani',
            quantity: 1,
            price: 60.0,
            totalPrice: 60.0,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      OrderModel(
        id: 15253,
        userId: 1,
        orderNumber: '1234567890',
        status: 'running',
        totalAmount: 30.0,
        items: [
          OrderItemModel(
            id: 2,
            productId: 2,
            productName: 'Chicken Bhuna',
            quantity: 1,
            price: 30.0,
            totalPrice: 30.0,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      OrderModel(
        id: 21200,
        userId: 1,
        orderNumber: '1234567890',
        status: 'running',
        totalAmount: 35.0,
        items: [
          OrderItemModel(
            id: 3,
            productId: 3,
            productName: 'Vegetarian Poutine',
            quantity: 1,
            price: 35.0,
            totalPrice: 35.0,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      OrderModel(
        id: 53241,
        userId: 1,
        orderNumber: '1234567890',
        status: 'running',
        totalAmount: 45.0,
        items: [
          OrderItemModel(
            id: 4,
            productId: 4,
            productName: 'Turkey Bacon Strips',
            quantity: 1,
            price: 45.0,
            totalPrice: 45.0,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      OrderModel(
        id: 58464,
        userId: 1,
        orderNumber: '1234567890',
        status: 'running',
        totalAmount: 25.0,
        items: [
          OrderItemModel(
            id: 5,
            productId: 5,
            productName: 'Veggie Burrito',
            quantity: 1,
            price: 25.0,
            totalPrice: 25.0,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<OrderEntity>> getNewOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      OrderModel(
        id: 12345,
        userId: 1,
        orderNumber: 'ORD-12345',
        status: 'new',
        totalAmount: 40.0,
        items: [
          OrderItemModel(
            id: 6,
            productId: 6,
            productName: 'Margherita Pizza',
            quantity: 1,
            price: 40.0,
            totalPrice: 40.0,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      OrderModel(
        id: 67890,
        userId: 1,
        orderNumber: 'ORD-67890',
        status: 'new',
        totalAmount: 20.0,
        items: [
          OrderItemModel(
            id: 7,
            productId: 7,
            productName: 'Caesar Salad',
            quantity: 1,
            price: 20.0,
            totalPrice: 20.0,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
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
        userId: 1,
        orderNumber: 'ORD-1001',
        status: 'completed',
        totalAmount: 45.0,
        items: [
          OrderItemModel(
            id: 8,
            productId: 8,
            productName: 'Margherita Pizza',
            quantity: 1,
            price: 45.0,
            totalPrice: 45.0,
          ),
        ],
        createdAt: DateTime(now.year, now.month, now.day, 9, 30), // 9:30 AM
        updatedAt: DateTime(now.year, now.month, now.day, 9, 30),
      ),
      OrderModel(
        id: 1002,
        userId: 1,
        orderNumber: 'ORD-1002',
        status: 'completed',
        totalAmount: 35.0,
        items: [
          OrderItemModel(
            id: 9,
            productId: 9,
            productName: 'Chicken Burger',
            quantity: 1,
            price: 35.0,
            totalPrice: 35.0,
          ),
        ],
        createdAt: DateTime(now.year, now.month, now.day, 10, 15), // 10:15 AM
        updatedAt: DateTime(now.year, now.month, now.day, 10, 15),
      ),
      OrderModel(
        id: 1003,
        userId: 1,
        orderNumber: 'ORD-1003',
        status: 'completed',
        totalAmount: 25.0,
        items: [
          OrderItemModel(
            id: 10,
            productId: 10,
            productName: 'Caesar Salad',
            quantity: 1,
            price: 25.0,
            totalPrice: 25.0,
          ),
        ],
        createdAt: DateTime(now.year, now.month, now.day, 11, 0), // 11:00 AM
        updatedAt: DateTime(now.year, now.month, now.day, 11, 0),
      ),
      OrderModel(
        id: 1004,
        userId: 1,
        orderNumber: 'ORD-1004',
        status: 'completed',
        totalAmount: 55.0,
        items: [
          OrderItemModel(
            id: 11,
            productId: 11,
            productName: 'Pasta Carbonara',
            quantity: 1,
            price: 55.0,
            totalPrice: 55.0,
          ),
        ],
        createdAt: DateTime(now.year, now.month, now.day, 12, 30), // 12:30 PM
        updatedAt: DateTime(now.year, now.month, now.day, 12, 30),
      ),
      OrderModel(
        id: 1005,
        userId: 1,
        orderNumber: 'ORD-1005',
        status: 'completed',
        totalAmount: 75.0,
        items: [
          OrderItemModel(
            id: 12,
            productId: 12,
            productName: 'Grilled Salmon',
            quantity: 1,
            price: 75.0,
            totalPrice: 75.0,
          ),
        ],
        createdAt: DateTime(now.year, now.month, now.day, 13, 45), // 1:45 PM
        updatedAt: DateTime(now.year, now.month, now.day, 13, 45),
      ),
      OrderModel(
        id: 1006,
        userId: 1,
        orderNumber: 'ORD-1006',
        status: 'completed',
        totalAmount: 15.0,
        items: [
          OrderItemModel(
            id: 13,
            productId: 13,
            productName: 'Chocolate Cake',
            quantity: 1,
            price: 15.0,
            totalPrice: 15.0,
          ),
        ],
        createdAt: DateTime(now.year, now.month, now.day, 14, 20), // 2:20 PM
        updatedAt: DateTime(now.year, now.month, now.day, 14, 20),
      ),
      OrderModel(
        id: 1007,
        userId: 1,
        orderNumber: 'ORD-1007',
        status: 'completed',
        totalAmount: 85.0,
        items: [
          OrderItemModel(
            id: 14,
            productId: 14,
            productName: 'Steak with Fries',
            quantity: 1,
            price: 85.0,
            totalPrice: 85.0,
          ),
        ],
        createdAt: DateTime(now.year, now.month, now.day, 15, 10), // 3:10 PM
        updatedAt: DateTime(now.year, now.month, now.day, 15, 10),
      ),
      OrderModel(
        id: 1008,
        userId: 1,
        orderNumber: 'ORD-1008',
        status: 'completed',
        totalAmount: 12.0,
        items: [
          OrderItemModel(
            id: 15,
            productId: 15,
            productName: 'Ice Cream Sundae',
            quantity: 1,
            price: 12.0,
            totalPrice: 12.0,
          ),
        ],
        createdAt: DateTime(now.year, now.month, now.day, 16, 0), // 4:00 PM
        updatedAt: DateTime(now.year, now.month, now.day, 16, 0),
      ),
      OrderModel(
        id: 1009,
        userId: 1,
        orderNumber: 'ORD-1009',
        status: 'completed',
        totalAmount: 28.0,
        items: [
          OrderItemModel(
            id: 16,
            productId: 16,
            productName: 'Chicken Wings',
            quantity: 1,
            price: 28.0,
            totalPrice: 28.0,
          ),
        ],
        createdAt: DateTime(now.year, now.month, now.day, 17, 30), // 5:30 PM
        updatedAt: DateTime(now.year, now.month, now.day, 17, 30),
      ),
      OrderModel(
        id: 1010,
        userId: 1,
        orderNumber: 'ORD-1010',
        status: 'completed',
        totalAmount: 32.0,
        items: [
          OrderItemModel(
            id: 17,
            productId: 17,
            productName: 'Beef Tacos',
            quantity: 1,
            price: 32.0,
            totalPrice: 32.0,
          ),
        ],
        createdAt: DateTime(now.year, now.month, now.day, 18, 15), // 6:15 PM
        updatedAt: DateTime(now.year, now.month, now.day, 18, 15),
      ),
      OrderModel(
        id: 1011,
        userId: 1,
        orderNumber: 'ORD-1011',
        status: 'completed',
        totalAmount: 38.0,
        items: [
          OrderItemModel(
            id: 18,
            productId: 18,
            productName: 'Vegetable Curry',
            quantity: 1,
            price: 38.0,
            totalPrice: 38.0,
          ),
        ],
        createdAt: DateTime(now.year, now.month, now.day, 19, 0), // 7:00 PM
        updatedAt: DateTime(now.year, now.month, now.day, 19, 0),
      ),
      OrderModel(
        id: 1012,
        userId: 1,
        orderNumber: 'ORD-1012',
        status: 'completed',
        totalAmount: 18.0,
        items: [
          OrderItemModel(
            id: 19,
            productId: 19,
            productName: 'Tiramisu',
            quantity: 1,
            price: 18.0,
            totalPrice: 18.0,
          ),
        ],
        createdAt: DateTime(now.year, now.month, now.day, 20, 30), // 8:30 PM
        updatedAt: DateTime(now.year, now.month, now.day, 20, 30),
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
