import '../entities/order_entity.dart';
import '../entities/order_enums.dart';
import '../repositories/order_repository.dart';

class UpdateOrderStatusUseCase {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<OrderEntity> call({
    required int orderId,
    required OrderStatus newStatus,
    PaymentStatus? paymentStatus,
    String? notes,
  }) async {
    return repository.updateOrderStatus(
      orderId: orderId,
      status: newStatus,
      paymentStatus: paymentStatus,
      notes: notes,
    );
  }
}
