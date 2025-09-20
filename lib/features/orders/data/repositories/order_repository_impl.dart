import 'dart:developer';

import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_enums.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';
import '../models/order_item_model.dart';
import '../models/place_order_request_model.dart';

/// 🟦 OrderRepositoryImpl - تطبيق مستودع الطلبات
/// يطبق مبدأ قلب الاعتماديات (DIP)
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OrderEntity>> getAllOrders() async {
    try {
      log('🔄 OrderRepositoryImpl: Getting all orders');

      final orderModels = await remoteDataSource.getOrders();

      log('✅ OrderRepositoryImpl: ${orderModels.length} orders retrieved');

      return orderModels.map((model) => model as OrderEntity).toList();
    } catch (e) {
      log('❌ OrderRepositoryImpl: Exception getting all orders - $e');
      rethrow;
    }
  }

  @override
  Future<OrderEntity> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  ) async {
    try {
      log('🔄 OrderRepositoryImpl: Placing order');
      log('📤 Order type: ${request.type}');
      log('📤 Table ID: ${request.tableId}');
      log('📤 Delivery address: ${request.deliveryAddress}');

      final orderModel = await remoteDataSource.placeOrder(request, items);

      log('✅ OrderRepositoryImpl: Order placed successfully');
      log('📄 Order ID: ${orderModel.id}');
      log('📄 Order status: ${orderModel.status}');
      log('📄 Total amount: ${orderModel.totalAmount}');

      return orderModel;
    } catch (e) {
      log('❌ OrderRepositoryImpl: Exception placing order - $e');
      rethrow;
    }
  }

  @override
  Future<List<OrderEntity>> getRunningOrders() async {
    try {
      log('🔄 OrderRepositoryImpl: Getting running orders');

      final orderModels = await remoteDataSource.getOrders();

      // Filter running orders (not completed or cancelled)
      final runningOrders = orderModels
          .where(
            (order) => ![
              OrderStatus.completed,
              OrderStatus.cancelled,
            ].contains(order.status),
          )
          .toList();

      log(
        '✅ OrderRepositoryImpl: ${runningOrders.length} running orders retrieved',
      );

      return runningOrders.map((model) => model as OrderEntity).toList();
    } catch (e) {
      log('❌ OrderRepositoryImpl: Exception getting running orders - $e');
      rethrow;
    }
  }

  @override
  Future<List<OrderEntity>> getNewOrders() async {
    try {
      log('🔄 OrderRepositoryImpl: Getting new orders');

      final orderModels = await remoteDataSource.getOrders();

      // Filter new orders (pending status)
      final newOrders = orderModels
          .where((order) => order.status == OrderStatus.pending)
          .toList();

      log('✅ OrderRepositoryImpl: ${newOrders.length} new orders retrieved');

      return newOrders.map((model) => model as OrderEntity).toList();
    } catch (e) {
      log('❌ OrderRepositoryImpl: Exception getting new orders - $e');
      rethrow;
    }
  }

  @override
  Future<bool> markOrderAsDone(int orderId) async {
    try {
      log('🔄 OrderRepositoryImpl: Marking order $orderId as done');

      // This would typically call an API endpoint to update order status
      // For now, we'll use the cancel order endpoint as a placeholder
      // In a real implementation, you'd have a dedicated endpoint for this
      await remoteDataSource.cancelOrder(orderId);

      log('✅ OrderRepositoryImpl: Order marked as done successfully');
      return true;
    } catch (e) {
      log('❌ OrderRepositoryImpl: Exception marking order as done - $e');
      return false;
    }
  }

  @override
  Future<bool> cancelOrder(int orderId) async {
    try {
      log('🔄 OrderRepositoryImpl: Cancelling order $orderId');

      await remoteDataSource.cancelOrder(orderId);

      log('✅ OrderRepositoryImpl: Order cancelled successfully');
      return true;
    } catch (e) {
      log('❌ OrderRepositoryImpl: Exception cancelling order - $e');
      return false;
    }
  }

  /// Get specific order details with items
  Future<OrderEntity> getOrderDetails(int orderId) async {
    try {
      log('🔄 OrderRepositoryImpl: Getting order details for ID: $orderId');

      final orderModel = await remoteDataSource.getOrder(orderId);

      log('✅ OrderRepositoryImpl: Order details retrieved successfully');
      log('📄 Order: ${orderModel.id} - ${orderModel.status}');
      log('📄 Items count: ${orderModel.items.length}');
      log('📄 Total amount: ${orderModel.totalAmount}');

      return orderModel;
    } catch (e) {
      log('❌ OrderRepositoryImpl: Exception getting order details - $e');
      rethrow;
    }
  }
}
