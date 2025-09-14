import '../../data/models/order_item_model.dart';
import '../../data/models/place_order_request_model.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class PlaceOrderUseCase {
  final OrderRepository repository;
  PlaceOrderUseCase(this.repository);

  Future<OrderEntity> call(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  ) {
    return repository.placeOrder(request, items);
  }
}
