// import 'package:dartz/dartz.dart';
// import 'dart:developer';

// import '../../../../core/error/failures.dart';
// import '../../domain/entities/order_entity.dart';
// import '../../domain/repositories/order_repository.dart';
// import '../datasources/order_remote_data_source.dart';
// import '../models/place_order_request_model.dart';

// /// 🟦 OrderRepositoryImpl - تطبيق مستودع الطلبات
// /// يطبق مبدأ قلب الاعتماديات (DIP)
// class OrderRepositoryImpl implements OrderRepository {
//   final OrderRemoteDataSource remoteDataSource;

//   OrderRepositoryImpl({required this.remoteDataSource});

//   @override
//   Future<Either<Failure, OrderEntity>> placeOrder(
//     PlaceOrderRequestEntity request,
//   ) async {
//     try {
//       log('🔄 OrderRepositoryImpl: Placing order');
//       log('📤 Order type: ${request.type}');
//       log('📤 Table ID: ${request.tableId}');
//       log('📤 Delivery address: ${request.deliveryAddress}');

//       final requestModel = PlaceOrderRequestModel.fromEntity(request);
//       final response = await remoteDataSource.placeOrder(requestModel);

//       if (response.status) {
//         final order = response.data!;
//         log('✅ OrderRepositoryImpl: Order placed successfully');
//         log('📄 Order ID: ${order.id}');
//         log('📄 Order status: ${order.status}');
//         log('📄 Total amount: ${order.totalAmount}');
//         return Right(order);
//       } else {
//         log(
//           '❌ OrderRepositoryImpl: Failed to place order - ${response.message}',
//         );
//         return Left(ServerFailure(message: response.message));
//       }
//     } catch (e) {
//       log('❌ OrderRepositoryImpl: Exception placing order - $e');
//       return Left(ServerFailure(message: 'حدث خطأ أثناء إنشاء الطلب'));
//     }
//   }

//   @override
//   Future<Either<Failure, List<OrderEntity>>> getUserOrders({
//     OrderType? type,
//     OrderStatus? status,
//   }) async {
//     try {
//       log('🔄 OrderRepositoryImpl: Getting user orders');
//       log('📤 Filters - Type: $type, Status: $status');

//       final response = await remoteDataSource.getUserOrders(
//         type: type,
//         status: status,
//       );

//       if (response.status) {
//         final orders = response.data!;
//         log('✅ OrderRepositoryImpl: ${orders.length} orders retrieved');

//         // إضافة تفاصيل إضافية للتسجيل
//         if (orders.isNotEmpty) {
//           log('📄 Order types: ${orders.map((o) => o.type).toSet()}');
//           log('📄 Order statuses: ${orders.map((o) => o.status).toSet()}');
//         }

//         return Right(orders);
//       } else {
//         log(
//           '❌ OrderRepositoryImpl: Failed to get orders - ${response.message}',
//         );
//         return Left(ServerFailure(message: response.message));
//       }
//     } catch (e) {
//       log('❌ OrderRepositoryImpl: Exception getting orders - $e');
//       return Left(ServerFailure(message: 'حدث خطأ أثناء جلب الطلبات'));
//     }
//   }

//   @override
//   Future<Either<Failure, OrderEntity>> getOrderDetails(int orderId) async {
//     try {
//       log('🔄 OrderRepositoryImpl: Getting order details for ID: $orderId');

//       final response = await remoteDataSource.getOrderDetails(orderId);

//       if (response.status) {
//         final order = response.data!;
//         log('✅ OrderRepositoryImpl: Order details retrieved successfully');
//         log('📄 Order: ${order.id} - ${order.status}');
//         log('📄 Items count: ${order.items.length}');
//         log('📄 Total amount: ${order.totalAmount}');
//         return Right(order);
//       } else {
//         log(
//           '❌ OrderRepositoryImpl: Failed to get order details - ${response.message}',
//         );
//         return Left(ServerFailure(message: response.message));
//       }
//     } catch (e) {
//       log('❌ OrderRepositoryImpl: Exception getting order details - $e');
//       return Left(ServerFailure(message: 'حدث خطأ أثناء جلب تفاصيل الطلب'));
//     }
//   }

//   @override
//   Future<Either<Failure, bool>> cancelOrder(int orderId) async {
//     try {
//       log('🔄 OrderRepositoryImpl: Cancelling order $orderId');

//       final response = await remoteDataSource.cancelOrder(orderId);

//       if (response.status) {
//         log('✅ OrderRepositoryImpl: Order cancelled successfully');
//         return const Right(true);
//       } else {
//         log(
//           '❌ OrderRepositoryImpl: Failed to cancel order - ${response.message}',
//         );
//         return Left(ServerFailure(message: response.message));
//       }
//     } catch (e) {
//       log('❌ OrderRepositoryImpl: Exception cancelling order - $e');
//       return Left(ServerFailure(message: 'حدث خطأ أثناء إلغاء الطلب'));
//     }
//   }

//   @override
//   Future<Either<Failure, OrderEntity>> updateOrderStatus(
//     int orderId,
//     OrderStatus status,
//   ) async {
//     try {
//       log('🔄 OrderRepositoryImpl: Updating order $orderId status to $status');

//       final response = await remoteDataSource.updateOrderStatus(
//         orderId,
//         status,
//       );

//       if (response.status) {
//         final order = response.data!;
//         log('✅ OrderRepositoryImpl: Order status updated successfully');
//         return Right(order);
//       } else {
//         log(
//           '❌ OrderRepositoryImpl: Failed to update order status - ${response.message}',
//         );
//         return Left(ServerFailure(message: response.message));
//       }
//     } catch (e) {
//       log('❌ OrderRepositoryImpl: Exception updating order status - $e');
//       return Left(ServerFailure(message: 'حدث خطأ أثناء تحديث حالة الطلب'));
//     }
//   }

//   @override
//   Future<Either<Failure, OrderEntity>> getOrderTracking(int orderId) async {
//     try {
//       log('🔄 OrderRepositoryImpl: Getting order tracking for ID: $orderId');

//       final response = await remoteDataSource.getOrderTracking(orderId);

//       if (response.status) {
//         final order = response.data!;
//         log('✅ OrderRepositoryImpl: Order tracking retrieved successfully');
//         return Right(order);
//       } else {
//         log(
//           '❌ OrderRepositoryImpl: Failed to get order tracking - ${response.message}',
//         );
//         return Left(ServerFailure(message: response.message));
//       }
//     } catch (e) {
//       log('❌ OrderRepositoryImpl: Exception getting order tracking - $e');
//       return Left(ServerFailure(message: 'حدث خطأ أثناء جلب تتبع الطلب'));
//     }
//   }

//   @override
//   Future<List<OrderEntity>> getNewOrders() {
//     // TODO: implement getNewOrders
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<OrderEntity>> getRunningOrders() {
//     // TODO: implement getRunningOrders
//     throw UnimplementedError();
//   }

//   @override
//   Future<bool> markOrderAsDone(int orderId) {
//     // TODO: implement markOrderAsDone
//     throw UnimplementedError();
//   }
// }
