import '../models/order_item_model.dart';
import '../models/order_model.dart';
import '../models/order_status_log_model.dart';
import '../models/place_order_request_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  );

  Future<OrderModel> cancelOrder(int orderId);

  Future<OrderModel> markOrderAsPaid(int orderId);

  Future<List<OrderModel>> getOrders({int page = 1});

  Future<List<OrderModel>> getRunningOrders();

  Future<OrderModel> getOrder(int orderId);

  Future<List<OrderStatusLogModel>> getOrderStatusHistory(int orderId);

  // Admin methods
  Future<OrderModel> updateOrderStatus({
    required int orderId,
    required String status,
    String? paymentStatus,
    String? notes,
  });

  Future<Map<String, dynamic>> getNextStatuses(int orderId);
}
