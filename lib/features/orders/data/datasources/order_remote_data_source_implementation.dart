import 'dart:developer';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_path.dart';
import '../../../../core/utils/debug_console_messages.dart';
import '../models/order_item_model.dart';
import '../models/order_model.dart';
import '../models/place_order_request_model.dart';
import 'order_remote_data_source.dart';

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;
  OrderRemoteDataSourceImpl(this.dio);

  @override
  Future<OrderModel> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  ) async {
    try {
      final data = request.toJson();
      // Items are handled by cart, so we don't need to send them here
      // The API will get items from the user's cart

      // Logging
      log(DebugConsoleMessages.info('🔄 OrderRemoteDataSource: Placing order'));
      log(DebugConsoleMessages.info('📤 Request data: $data'));

      final response = await dio.post(ApiPath.placeOrder(), data: data);

      log(
        DebugConsoleMessages.success(
          '✅ OrderRemoteDataSource: Order placed successfully',
        ),
      );
      log(DebugConsoleMessages.success('📄 Response data: ${response.data}'));

      final orderData = response.data['data'];
      if (orderData == null) {
        throw const ServerFailure(message: 'No order data returned from API');
      }

      return OrderModel.fromJson(orderData);
    } on DioException catch (e) {
      log('❌ OrderRemoteDataSource: Failed to place order - $e');
      throw ServerFailure(message: e.message ?? 'Failed to place order');
    } catch (e) {
      log('❌ OrderRemoteDataSource: Failed to place order - $e');
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<OrderModel> cancelOrder(int orderId) async {
    try {
      log(
        DebugConsoleMessages.info(
          '🔄 OrderRemoteDataSource: Canceling order $orderId',
        ),
      );

      final response = await dio.patch(ApiPath.cancelOrder(orderId));

      log(
        DebugConsoleMessages.success(
          '✅ OrderRemoteDataSource: Order canceled successfully',
        ),
      );
      log(DebugConsoleMessages.success('📄 Response data: ${response.data}'));

      final orderData = response.data['data'];
      if (orderData == null) {
        throw const ServerFailure(message: 'No order data returned from API');
      }

      return OrderModel.fromJson(orderData);
    } on DioException catch (e) {
      log('❌ OrderRemoteDataSource: Failed to cancel order - $e');
      throw ServerFailure(message: e.message ?? 'Failed to cancel order');
    } catch (e) {
      log('❌ OrderRemoteDataSource: Failed to cancel order - $e');
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<OrderModel>> getOrders({int page = 1}) async {
    try {
      log(
        DebugConsoleMessages.info(
          '🔄 OrderRemoteDataSource: Getting orders page $page',
        ),
      );

      final response = await dio.get(
        ApiPath.orders(),
        queryParameters: {'page': page},
      );

      log(
        DebugConsoleMessages.success(
          '✅ OrderRemoteDataSource: Orders retrieved successfully',
        ),
      );
      log(DebugConsoleMessages.success('📄 Response data: ${response.data}'));

      final ordersData = response.data['data']['data'] as List?;
      if (ordersData == null) {
        return [];
      }

      return ordersData
          .map((orderJson) => OrderModel.fromJson(orderJson))
          .toList();
    } on DioException catch (e) {
      log('❌ OrderRemoteDataSource: Failed to get orders - $e');
      throw ServerFailure(message: e.message ?? 'Failed to get orders');
    } catch (e) {
      log('❌ OrderRemoteDataSource: Failed to get orders - $e');
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<OrderModel> getOrder(int orderId) async {
    try {
      log(
        DebugConsoleMessages.info(
          '🔄 OrderRemoteDataSource: Getting order $orderId',
        ),
      );

      final response = await dio.get(ApiPath.order(orderId));

      log(
        DebugConsoleMessages.success(
          '✅ OrderRemoteDataSource: Order retrieved successfully',
        ),
      );
      log(DebugConsoleMessages.success('📄 Response data: ${response.data}'));

      final orderData = response.data['data'];
      if (orderData == null) {
        throw const ServerFailure(message: 'No order data returned from API');
      }

      return OrderModel.fromJson(orderData);
    } on DioException catch (e) {
      log('❌ OrderRemoteDataSource: Failed to get order - $e');
      throw ServerFailure(message: e.message ?? 'Failed to get order');
    } catch (e) {
      log('❌ OrderRemoteDataSource: Failed to get order - $e');
      throw ServerFailure(message: e.toString());
    }
  }
}
