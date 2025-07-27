import '../repositories/order_repository.dart';

class CancelOrderUseCase {
  final OrderRepository repository;

  CancelOrderUseCase(this.repository);

  Future<bool> call(int orderId) async {
    return await repository.cancelOrder(orderId);
  }
}
