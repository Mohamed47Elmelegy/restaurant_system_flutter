import 'dart:developer';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_path.dart';
import '../../../../core/utils/debug_console_messages.dart';
import '../models/order_item_model.dart';
import '../models/order_model.dart';
import '../models/order_status_log_model.dart';
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

  @override
  Future<OrderModel> markOrderAsPaid(int orderId) async {
    try {
      log(
        DebugConsoleMessages.info(
          '🔄 OrderRemoteDataSource: Marking order $orderId as paid',
        ),
      );

      final response = await dio.patch(ApiPath.markOrderPaid(orderId));

      log(
        DebugConsoleMessages.success(
          '✅ OrderRemoteDataSource: Order marked as paid successfully',
        ),
      );
      log(DebugConsoleMessages.success('📄 Response data: ${response.data}'));

      final orderData = response.data['data'];
      if (orderData == null) {
        throw const ServerFailure(message: 'No order data returned from API');
      }

      return OrderModel.fromJson(orderData);
    } on DioException catch (e) {
      log('❌ OrderRemoteDataSource: Failed to mark order as paid - $e');
      throw ServerFailure(message: e.message ?? 'Failed to mark order as paid');
    } catch (e) {
      log('❌ OrderRemoteDataSource: Failed to mark order as paid - $e');
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<OrderModel>> getRunningOrders() async {
    try {
      log(
        DebugConsoleMessages.info(
          '🔄 OrderRemoteDataSource: Getting running orders',
        ),
      );

      final response = await dio.get('${ApiPath.orders()}/running');

      log(
        DebugConsoleMessages.success(
          '✅ OrderRemoteDataSource: Running orders retrieved successfully',
        ),
      );
      log(DebugConsoleMessages.success('📄 Response data: ${response.data}'));

      final ordersData = response.data['data'] as List?;
      if (ordersData == null) {
        return [];
      }

      return ordersData
          .map((orderJson) => OrderModel.fromJson(orderJson))
          .toList();
    } on DioException catch (e) {
      log('❌ OrderRemoteDataSource: Failed to get running orders - $e');
      throw ServerFailure(message: e.message ?? 'Failed to get running orders');
    } catch (e) {
      log('❌ OrderRemoteDataSource: Failed to get running orders - $e');
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<OrderStatusLogModel>> getOrderStatusHistory(int orderId) async {
    try {
      log(
        DebugConsoleMessages.info(
          '🔄 OrderRemoteDataSource: Getting order status history for $orderId',
        ),
      );

      final response = await dio.get(ApiPath.orderStatusHistory(orderId));

      log(
        DebugConsoleMessages.success(
          '✅ OrderRemoteDataSource: Order status history retrieved successfully',
        ),
      );
      log(DebugConsoleMessages.success('📄 Response data: ${response.data}'));

      final logsData = response.data['data'] as List?;
      if (logsData == null) {
        return [];
      }

      return logsData
          .map((logJson) => OrderStatusLogModel.fromJson(logJson))
          .toList();
    } on DioException catch (e) {
      log('❌ OrderRemoteDataSource: Failed to get order status history - $e');
      throw ServerFailure(
        message: e.message ?? 'Failed to get order status history',
      );
    } catch (e) {
      log('❌ OrderRemoteDataSource: Failed to get order status history - $e');
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<OrderModel> updateOrderStatus({
    required int orderId,
    required String status,
    String? paymentStatus,
    String? notes,
  }) async {
    try {
      log(
        DebugConsoleMessages.info(
          '🔄 OrderRemoteDataSource: Updating order $orderId status to $status',
        ),
      );

      final data = <String, dynamic>{
        'status': status,
        if (paymentStatus != null) 'payment_status': paymentStatus,
        if (notes != null) 'notes': notes,
      };

      final response = await dio.patch(
        ApiPath.adminOrderStatus(orderId),
        data: data,
      );

      log(
        DebugConsoleMessages.success(
          '✅ OrderRemoteDataSource: Order status updated successfully',
        ),
      );
      log(DebugConsoleMessages.success('📄 Response data: ${response.data}'));

      final orderData = response.data['data'];
      if (orderData == null) {
        throw const ServerFailure(message: 'No order data returned from API');
      }

      return OrderModel.fromJson(orderData);
    } on DioException catch (e) {
      log('❌ OrderRemoteDataSource: Failed to update order status - $e');
      throw ServerFailure(
        message: e.message ?? 'Failed to update order status',
      );
    } catch (e) {
      log('❌ OrderRemoteDataSource: Failed to update order status - $e');
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getNextStatuses(int orderId) async {
    try {
      log(
        DebugConsoleMessages.info(
          '🔄 OrderRemoteDataSource: Getting next statuses for order $orderId',
        ),
      );

      final response = await dio.get(ApiPath.adminOrderNextStatuses(orderId));

      log(
        DebugConsoleMessages.success(
          '✅ OrderRemoteDataSource: Next statuses retrieved successfully',
        ),
      );
      log(DebugConsoleMessages.success('📄 Response data: ${response.data}'));

      final statusData = response.data['data'];
      if (statusData == null) {
        throw const ServerFailure(message: 'No status data returned from API');
      }

      return Map<String, dynamic>.from(statusData);
    } on DioException catch (e) {
      log('❌ OrderRemoteDataSource: Failed to get next statuses - $e');
      throw ServerFailure(message: e.message ?? 'Failed to get next statuses');
    } catch (e) {
      log('❌ OrderRemoteDataSource: Failed to get next statuses - $e');
      throw ServerFailure(message: e.toString());
    }
  }
}
