import 'package:dio/dio.dart';
import '../../../../core/network/api_path.dart';
import '../models/table_model.dart';
import 'table_remote_datasource.dart';

class TableRemoteDataSourceImpl implements TableRemoteDataSource {
  final Dio dio;
  TableRemoteDataSourceImpl(this.dio);

  @override
  Future<TableModel> getTableByQr(String qrCode) async {
    try {
      final response = await dio.get(ApiPath.tableByQr(qrCode));
      if (response.data['success'] == true) {
        return TableModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      // Extract the actual error message from the response
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data as Map<String, dynamic>;
        final message = errorData['message'] ?? 'حدث خطأ غير متوقع';
        throw Exception(message);
      }
      // Fallback to generic error message
      throw Exception('حدث خطأ في الاتصال بالخادم');
    }
  }

  @override
  Future<void> occupyTable(int tableId) async {
    try {
      final response = await dio.post(ApiPath.occupyTable(tableId));
      if (response.data['success'] != true) {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      // Extract the actual error message from the response
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data as Map<String, dynamic>;
        final message = errorData['message'] ?? 'حدث خطأ غير متوقع';
        throw Exception(message);
      }
      // Fallback to generic error message
      throw Exception('حدث خطأ في الاتصال بالخادم');
    }
  }
}
