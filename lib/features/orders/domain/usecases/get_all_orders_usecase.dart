import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetAllOrdersUseCase {
  final OrderRepository repository;

  GetAllOrdersUseCase(this.repository);

  Future<List<OrderEntity>> call() async {
    return repository.getAllOrders();
  }
}
