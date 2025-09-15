import '../../data/models/order_item_model.dart';
import '../../data/models/place_order_request_model.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getAllOrders();
  Future<List<OrderEntity>> getRunningOrders();
  Future<List<OrderEntity>> getNewOrders();
  Future<bool> markOrderAsDone(int orderId);
  Future<bool> cancelOrder(int orderId);

  Future<OrderEntity> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  );
}
