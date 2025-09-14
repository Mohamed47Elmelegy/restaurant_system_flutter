import '../models/order_item_model.dart';
import '../models/order_model.dart';
import '../models/place_order_request_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  );

  Future<OrderModel> cancelOrder(int orderId);

  Future<List<OrderModel>> getOrders({int page = 1});

  Future<OrderModel> getOrder(int orderId);
}
