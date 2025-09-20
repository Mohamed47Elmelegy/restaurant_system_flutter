import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:restaurant_system_flutter/core/error/failures.dart';
import 'package:restaurant_system_flutter/core/network/api_path.dart';

import '../../../../core/utils/debug_console_messages.dart';
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
  final Dio dio;
  CheckOutRemoteDataSourceImpl(this.dio);

  @override
  Future<OrderEntity> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  ) async {
    try {
      final data = request.toJson();
      // Don't send items - Backend will get them from cart
      // data['items'] = items.map((e) => e.toJson()).toList();

      // Logging
      log(
        DebugConsoleMessages.info('🔄 CheckOutRemoteDataSource: Placing order'),
      );
      log(DebugConsoleMessages.info('📤 Request data: $data'));

      final response = await dio.post(ApiPath.placeOrder(), data: data);

      log(
        DebugConsoleMessages.success(
          '✅ CheckOutRemoteDataSource: Order placed successfully',
        ),
      );
      log(DebugConsoleMessages.success('📄 Response data: ${response.data}'));

      final orderData = response.data['data'];
      if (orderData == null) {
        throw const ServerFailure(message: 'No order data returned from API');
      }
      return OrderModel.fromJson(orderData);
    } on DioException catch (e) {
      log('❌ CheckOutRemoteDataSource: Failed to place order - $e');
      throw ServerFailure(message: e.message ?? 'Failed to place order');
    } catch (e) {
      log('❌ CheckOutRemoteDataSource: Failed to place order - $e');
      throw ServerFailure(message: e.toString());
    }
  }
}
