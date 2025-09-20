import 'package:flutter/material.dart';

import '../../features/orders/domain/entities/order_enums.dart';

/// Utility class for Order related enums and their properties
class OrderUtils {
  /// Parse order type from string
  static OrderType parseOrderType(String type) {
    switch (type.toLowerCase()) {
      case 'dine_in':
        return OrderType.dineIn;
      case 'delivery':
        return OrderType.delivery;
      case 'pickup':
        return OrderType.pickup;
      default:
        throw ArgumentError('Unknown order type: $type');
    }
  }

  /// Parse order status from string
  static OrderStatus parseOrderStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'paid':
        return OrderStatus.paid;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready_to_serve':
        return OrderStatus.readyToServe;
      case 'served':
        return OrderStatus.served;
      case 'ready_for_pickup':
        return OrderStatus.readyForPickup;
      case 'picked_up':
        return OrderStatus.pickedUp;
      case 'on_the_way':
        return OrderStatus.onTheWay;
      case 'delivered':
        return OrderStatus.delivered;
      case 'completed':
        return OrderStatus.completed;
      case 'refunded':
        return OrderStatus.refunded;
      // Legacy support
      case 'delivering':
        return OrderStatus.onTheWay;
      case 'ready':
        return OrderStatus.onTheWay;
      default:
        throw ArgumentError('Unknown order status: $status');
    }
  }

  /// Parse payment status from string
  static PaymentStatus parsePaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'unpaid':
        return PaymentStatus.unpaid;
      case 'paid':
        return PaymentStatus.paid;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        throw ArgumentError('Unknown payment status: $status');
    }
  }

  /// Convert order type to string
  static String orderTypeToString(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return 'dine_in';
      case OrderType.delivery:
        return 'delivery';
      case OrderType.pickup:
        return 'pickup';
    }
  }

  /// Convert order status to string
  static String orderStatusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.paid:
        return 'paid';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.readyToServe:
        return 'ready_to_serve';
      case OrderStatus.served:
        return 'served';
      case OrderStatus.readyForPickup:
        return 'ready_for_pickup';
      case OrderStatus.pickedUp:
        return 'picked_up';
      case OrderStatus.onTheWay:
        return 'on_the_way';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.refunded:
        return 'refunded';
    }
  }

  /// Convert payment status to string
  static String paymentStatusToString(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.unpaid:
        return 'unpaid';
      case PaymentStatus.paid:
        return 'paid';
      case PaymentStatus.refunded:
        return 'refunded';
    }
  }

  /// Get status display name in Arabic
  static String getStatusDisplayName(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'في الانتظار';
      case OrderStatus.confirmed:
        return 'مؤكد';
      case OrderStatus.paid:
        return 'مدفوع';
      case OrderStatus.cancelled:
        return 'ملغي';
      case OrderStatus.preparing:
        return 'قيد التحضير';
      case OrderStatus.readyToServe:
        return 'جاهز للتقديم';
      case OrderStatus.served:
        return 'تم التقديم';
      case OrderStatus.readyForPickup:
        return 'جاهز للاستلام';
      case OrderStatus.pickedUp:
        return 'تم الاستلام';
      case OrderStatus.onTheWay:
        return 'في الطريق';
      case OrderStatus.delivered:
        return 'تم التسليم';
      case OrderStatus.completed:
        return 'مكتمل';
      case OrderStatus.refunded:
        return 'مسترد';
    }
  }

  /// Get order type display name in Arabic
  static String getOrderTypeDisplayName(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return 'داخل المطعم';
      case OrderType.delivery:
        return 'توصيل';
      case OrderType.pickup:
        return 'استلام';
    }
  }

  /// Get status color
  static int getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange.value;
      case OrderStatus.confirmed:
        return Colors.blueGrey.value;
      case OrderStatus.paid:
        return Colors.blue.value;
      case OrderStatus.preparing:
        return Colors.deepOrange.value;
      case OrderStatus.readyToServe:
      case OrderStatus.readyForPickup:
        return Colors.teal.value;
      case OrderStatus.served:
      case OrderStatus.pickedUp:
      case OrderStatus.delivered:
      case OrderStatus.completed:
        return Colors.green.value;
      case OrderStatus.onTheWay:
        return Colors.purple.value;
      case OrderStatus.cancelled:
      case OrderStatus.refunded:
        return Colors.red.value;
    }
  }

  /// Get status icon
  static int getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.hourglass_empty.codePoint;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline.codePoint;
      case OrderStatus.paid:
        return Icons.payment.codePoint;
      case OrderStatus.preparing:
        return Icons.kitchen.codePoint;
      case OrderStatus.readyToServe:
        return Icons.restaurant_menu.codePoint;
      case OrderStatus.served:
        return Icons.room_service.codePoint;
      case OrderStatus.readyForPickup:
        return Icons.shopping_bag.codePoint;
      case OrderStatus.pickedUp:
        return Icons.person_pin_circle.codePoint;
      case OrderStatus.onTheWay:
        return Icons.delivery_dining.codePoint;
      case OrderStatus.delivered:
        return Icons.check_circle.codePoint;
      case OrderStatus.completed:
        return Icons.done_all.codePoint;
      case OrderStatus.cancelled:
        return Icons.cancel.codePoint;
      case OrderStatus.refunded:
        return Icons.money_off.codePoint;
    }
  }

  /// Check if a status is a final status (cannot be changed further)
  static bool isFinalStatus(OrderStatus status) {
    return status == OrderStatus.completed ||
        status == OrderStatus.cancelled ||
        status == OrderStatus.refunded;
  }

  /// Check if an order can be cancelled based on its status
  static bool canBeCancelled(OrderStatus status) {
    return status == OrderStatus.pending ||
        status == OrderStatus.confirmed ||
        status == OrderStatus.paid ||
        status == OrderStatus.preparing;
  }

  /// Get progress percentage for a given status
  static double getProgressPercentage(OrderStatus status) {
    final allStatuses = OrderStatus.values;
    final index = allStatuses.indexOf(status);
    if (index == -1) return 0.0;
    return (index + 1) / allStatuses.length;
  }

  /// Get payment status display name in Arabic
  static String getPaymentStatusDisplayName(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.unpaid:
        return 'غير مدفوع';
      case PaymentStatus.paid:
        return 'مدفوع';
      case PaymentStatus.refunded:
        return 'مسترد';
    }
  }
}
