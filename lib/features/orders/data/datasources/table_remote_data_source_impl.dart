import 'package:dio/dio.dart';
import '../../../../core/network/api_path.dart';
import '../models/table_model.dart';
import 'table_remote_datasource.dart';

class TableRemoteDataSourceImpl implements TableRemoteDataSource {
  final Dio dio;
  TableRemoteDataSourceImpl(this.dio);

  @override
  Future<TableModel> getTableByQr(String qrCode) async {
    final response = await dio.get(ApiPath.tableByQr(qrCode));
    if (response.data['success'] == true) {
      return TableModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message']);
    }
  }

  @override
  Future<void> occupyTable(int tableId) async {
    final response = await dio.post(ApiPath.occupyTable(tableId));
    if (response.data['success'] != true) {
      throw Exception(response.data['message']);
    }
  }
}
