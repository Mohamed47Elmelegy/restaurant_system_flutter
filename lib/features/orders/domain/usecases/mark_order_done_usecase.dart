import '../repositories/order_repository.dart';

class MarkOrderDoneUseCase {
  final OrderRepository repository;

  MarkOrderDoneUseCase(this.repository);

  Future<bool> call(int orderId) async {
    return repository.markOrderAsDone(orderId);
  }
}
