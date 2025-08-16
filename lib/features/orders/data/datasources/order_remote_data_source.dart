import '../models/place_order_request_model.dart';
import '../models/order_item_model.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  );
}



