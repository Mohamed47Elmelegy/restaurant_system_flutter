import '../models/table_model.dart';

abstract class TableRemoteDataSource {
  Future<TableModel> getTableByQr(String qrCode);
  Future<void> occupyTable(int tableId);
  Future<TableModel> updateTableAvailability({
    required int tableId,
    required bool isAvailable,
  });
  Future<List<TableModel>> getAllTables();
}
