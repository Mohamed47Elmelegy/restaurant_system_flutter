import 'dart:developer';

import '../../../../core/di/service_locator.dart';
import '../../features/orders/domain/entities/order_entity.dart';
import '../../features/orders/domain/entities/order_enums.dart';
import '../../features/orders/domain/repositories/order_repository.dart';

/// Service for managing order editing capabilities
class OrderEditingService {
  static OrderEditingService? _instance;
  static OrderEditingService get instance =>
      _instance ??= OrderEditingService._();

  OrderEditingService._();

  final OrderRepository _orderRepository = getIt<OrderRepository>();

  /// Check if an order can be edited based on business rules
  bool canEditOrder(OrderEntity order) {
    // Delivery orders can be edited until they're out for delivery
    if (order.type == OrderType.delivery) {
      return _canEditDeliveryOrder(order);
    }

    // Pickup orders can be edited until they're ready for pickup
    if (order.type == OrderType.pickup) {
      return _canEditPickupOrder(order);
    }

    // Dine-in orders can have items added until paid
    if (order.type == OrderType.dineIn) {
      return _canEditDineInOrder(order);
    }

    return false;
  }

  /// Check if delivery order can be edited
  bool _canEditDeliveryOrder(OrderEntity order) {
    return order.status == OrderStatus.pending ||
        order.status == OrderStatus.confirmed ||
        order.status == OrderStatus.paid ||
        order.status == OrderStatus.preparing;
  }

  /// Check if pickup order can be edited
  bool _canEditPickupOrder(OrderEntity order) {
    return order.status == OrderStatus.pending ||
        order.status == OrderStatus.confirmed ||
        order.status == OrderStatus.paid ||
        order.status == OrderStatus.preparing;
  }

  /// Check if dine-in order can be edited
  bool _canEditDineInOrder(OrderEntity order) {
    // Dine-in orders can have items added until paid
    return order.paymentStatus == PaymentStatus.unpaid &&
        (order.status == OrderStatus.pending ||
            order.status == OrderStatus.confirmed ||
            order.status == OrderStatus.preparing ||
            order.status == OrderStatus.readyToServe);
  }

  /// Get the reason why an order cannot be edited
  String getEditingDisabledReason(OrderEntity order) {
    if (order.isFinalStatus) {
      return 'لا يمكن تعديل الطلبات المكتملة أو الملغية';
    }

    switch (order.type) {
      case OrderType.delivery:
        if (order.status == OrderStatus.onTheWay) {
          return 'لا يمكن تعديل طلب التوصيل بعد خروجه للتوصيل';
        } else if (order.status == OrderStatus.delivered) {
          return 'تم تسليم الطلب بالفعل';
        }
        break;

      case OrderType.pickup:
        if (order.status == OrderStatus.readyForPickup) {
          return 'الطلب جاهز للاستلام';
        } else if (order.status == OrderStatus.pickedUp) {
          return 'تم استلام الطلب بالفعل';
        }
        break;

      case OrderType.dineIn:
        if (order.paymentStatus == PaymentStatus.paid) {
          return 'تم الدفع بالفعل - لا يمكن إضافة منتجات';
        } else if (order.status == OrderStatus.served) {
          return 'تم تقديم الطلب بالفعل';
        }
        break;
    }

    return 'لا يمكن تعديل هذا الطلب في الوقت الحالي';
  }

  /// Get editing capabilities for an order
  OrderEditingCapabilities getEditingCapabilities(OrderEntity order) {
    if (!canEditOrder(order)) {
      return OrderEditingCapabilities(
        canAddItems: false,
        canRemoveItems: false,
        canModifyItems: false,
        canChangeQuantity: false,
        reason: getEditingDisabledReason(order),
      );
    }

    switch (order.type) {
      case OrderType.delivery:
      case OrderType.pickup:
        return const OrderEditingCapabilities(
          canAddItems: true,
          canRemoveItems: true,
          canModifyItems: true,
          canChangeQuantity: true,
          reason: null,
        );

      case OrderType.dineIn:
        return const OrderEditingCapabilities(
          canAddItems: true,
          canRemoveItems: false, // Usually don't remove items in dine-in
          canModifyItems: true,
          canChangeQuantity: true,
          reason: null,
        );
    }
  }

  /// Update order status and check if editing capabilities changed
  Future<OrderEntity?> updateOrderStatus({
    required int orderId,
    required OrderStatus newStatus,
    PaymentStatus? paymentStatus,
    String? notes,
  }) async {
    try {
      final updatedOrder = await _orderRepository.updateOrderStatus(
        orderId: orderId,
        status: newStatus,
        paymentStatus: paymentStatus,
        notes: notes,
      );

      log(
        "Order $orderId status updated to $newStatus",
        name: 'OrderEditingService',
      );
      return updatedOrder;
    } catch (e) {
      log("Failed to update order status: $e", name: 'OrderEditingService');
      return null;
    }
  }

  /// Get next available statuses for an order
  List<OrderStatus> getNextAvailableStatuses(OrderEntity order) {
    return order.nextPossibleStatuses;
  }

  /// Check if status transition is valid
  bool isValidStatusTransition(
    OrderStatus currentStatus,
    OrderStatus newStatus,
  ) {
    final validTransitions = {
      OrderStatus.pending: [OrderStatus.confirmed, OrderStatus.cancelled],
      OrderStatus.confirmed: [
        OrderStatus.paid,
        OrderStatus.preparing,
        OrderStatus.cancelled,
      ],
      OrderStatus.paid: [OrderStatus.preparing, OrderStatus.cancelled],
      OrderStatus.preparing: [
        OrderStatus.readyToServe,
        OrderStatus.readyForPickup,
        OrderStatus.onTheWay,
        OrderStatus.cancelled,
      ],
      OrderStatus.readyToServe: [OrderStatus.served],
      OrderStatus.served: [OrderStatus.completed],
      OrderStatus.readyForPickup: [OrderStatus.pickedUp],
      OrderStatus.pickedUp: [OrderStatus.completed],
      OrderStatus.onTheWay: [OrderStatus.delivered],
      OrderStatus.delivered: [OrderStatus.completed],
    };

    return validTransitions[currentStatus]?.contains(newStatus) ?? false;
  }
}

/// Represents the editing capabilities for an order
class OrderEditingCapabilities {
  final bool canAddItems;
  final bool canRemoveItems;
  final bool canModifyItems;
  final bool canChangeQuantity;
  final String? reason;

  const OrderEditingCapabilities({
    required this.canAddItems,
    required this.canRemoveItems,
    required this.canModifyItems,
    required this.canChangeQuantity,
    this.reason,
  });

  bool get canEdit =>
      canAddItems || canRemoveItems || canModifyItems || canChangeQuantity;
}
