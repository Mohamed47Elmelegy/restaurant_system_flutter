import 'package:dio/dio.dart';
import 'order_remote_data_source.dart';
import '../models/place_order_request_model.dart';
import '../models/order_item_model.dart';
import '../models/order_model.dart';

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;
  OrderRemoteDataSourceImpl(this.dio);

  @override
  Future<OrderModel> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  ) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
