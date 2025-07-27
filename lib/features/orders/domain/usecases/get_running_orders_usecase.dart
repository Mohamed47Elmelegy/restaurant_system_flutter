import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetRunningOrdersUseCase {
  final OrderRepository repository;

  GetRunningOrdersUseCase(this.repository);

  Future<List<OrderEntity>> call() async {
    return await repository.getRunningOrders();
  }
}
