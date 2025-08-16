   import '../models/table_model.dart';

   abstract class TableRemoteDataSource {
     Future<TableModel> getTableByQr(String qrCode);
     Future<void> occupyTable(int tableId);
   }