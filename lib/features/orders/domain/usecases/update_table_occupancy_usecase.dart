import '../entities/order_entity.dart';
import '../entities/table_entity.dart';
import '../repositories/table_repository.dart';

class UpdateTableOccupancyUseCase {
  final TableRepository repository;

  UpdateTableOccupancyUseCase(this.repository);

  /// Update table occupancy based on order status
  Future<TableEntity> call({
    required int tableId,
    required OrderEntity order,
  }) async {
    final shouldBeAvailable = order.shouldTableBeAvailable;

    return repository.updateTableAvailability(
      tableId: tableId,
      isAvailable: shouldBeAvailable,
    );
  }

  /// Update table occupancy for multiple orders (batch update)
  Future<List<TableEntity>> updateMultipleTablesOccupancy({
    required List<OrderEntity> orders,
  }) async {
    final List<TableEntity> updatedTables = [];

    for (final order in orders) {
      if (order.tableId != null) {
        try {
          final updatedTable = await call(
            tableId: order.tableId!,
            order: order,
          );
          updatedTables.add(updatedTable);
        } catch (e) {
          // Log error but continue with other tables
        }
      }
    }

    return updatedTables;
  }
}
