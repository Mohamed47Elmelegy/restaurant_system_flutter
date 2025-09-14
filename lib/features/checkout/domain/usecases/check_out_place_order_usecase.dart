import '../../../orders/data/models/order_item_model.dart';
import '../../../orders/data/models/place_order_request_model.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../repositories/check_out_repository.dart';

class CheckOutPlaceOrderUseCase {
  final CheckOutRepository repository;
  CheckOutPlaceOrderUseCase(this.repository);

  Future<OrderEntity> call(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  ) {
    return repository.placeOrder(request, items);
  }
}
