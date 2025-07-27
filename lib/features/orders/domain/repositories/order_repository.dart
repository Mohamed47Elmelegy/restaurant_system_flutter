import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getRunningOrders();
  Future<List<OrderEntity>> getNewOrders();
  Future<bool> markOrderAsDone(int orderId);
  Future<bool> cancelOrder(int orderId);
}
