import 'package:dio/dio.dart';
import 'package:restaurant_system_flutter/core/error/api_response.dart';
import 'package:restaurant_system_flutter/core/error/failures.dart';
import 'package:restaurant_system_flutter/core/network/dio_client.dart';
import 'package:restaurant_system_flutter/core/network/endpoints.dart';

import '../../../orders/data/models/order_item_model.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../orders/data/models/place_order_request_model.dart';
import '../../../orders/domain/entities/order_entity.dart';

abstract class CheckOutRemoteDataSource {
  Future<OrderEntity> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  );
}

class CheckOutRemoteDataSourceImpl implements CheckOutRemoteDataSource {
  final DioClient dioClient;
  CheckOutRemoteDataSourceImpl(this.dioClient);

  @override
  Future<OrderEntity> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  ) async {
    final data = request.toJson();
    data['items'] = items.map((e) => e.toJson()).toList();
    try {
      final response = await dioClient.dio.post(
        Endpoints.placeOrder,
        data: data,
      );
      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => OrderModel.fromJson(json as Map<String, dynamic>),
      );
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Failure.fromAppError(apiResponse.toAppError());
      }
    } catch (e) {
      if (e is Failure) rethrow;
      if (e is DioException) {
        final apiError = ApiResponse<OrderModel>.fromDioException(e);
        throw Failure.fromAppError(apiError.toAppError());
      }
      throw ServerFailure.custom(e.toString());
    }
  }
}
