import '../../../orders/data/models/order_item_model.dart';
import '../../../orders/data/models/place_order_request_model.dart';
import '../../../orders/domain/entities/order_entity.dart';

abstract class CheckOutRepository {
  Future<OrderEntity> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  );
}
