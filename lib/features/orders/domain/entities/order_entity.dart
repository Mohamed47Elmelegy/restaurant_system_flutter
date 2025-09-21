import 'package:equatable/equatable.dart';

import '../../../../core/utils/order_utils.dart';
import 'order_enums.dart';
import 'order_item_entity.dart';
import 'order_status_log_entity.dart';
import 'table_entity.dart';

/// 🟩 Order Entity - Domain Layer
class OrderEntity extends Equatable {
  final int id;
  final int userId;
  final OrderType type;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final double subtotalAmount;
  final double taxAmount;
  final double deliveryFee;
  final double totalAmount;
  final String? deliveryAddress;
  final String? specialInstructions;
  final String? notes;
  final String? paymentMethod;
  final TableEntity? table;
  final int? tableId;
  final List<OrderItemEntity> items;
  final List<OrderStatusLogEntity> statusLogs;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.paymentStatus,
    required this.subtotalAmount,
    required this.taxAmount,
    required this.deliveryFee,
    required this.totalAmount,
    this.deliveryAddress,
    this.specialInstructions,
    this.notes,
    this.paymentMethod,
    this.table,
    this.tableId,
    required this.items,
    this.statusLogs = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if this is a dine-in order
  bool get isDineIn => type == OrderType.dineIn;

  /// Check if this is a delivery order
  bool get isDelivery => type == OrderType.delivery;

  /// Check if this is a pickup order
  bool get isPickup => type == OrderType.pickup;

  /// Check if order has delivery fee
  bool get hasDeliveryFee => deliveryFee > 0;

  /// Get status display name in Arabic
  String get statusDisplayName => OrderUtils.getStatusDisplayName(status);

  /// Get order type display name in Arabic
  String get typeDisplayName => OrderUtils.getOrderTypeDisplayName(type);

  /// Get status color
  int get statusColor => OrderUtils.getStatusColor(status);

  /// Get status icon
  int get statusIcon => OrderUtils.getStatusIcon(status);

  /// Check if this is a final status
  bool get isFinalStatus => OrderUtils.isFinalStatus(status);

  /// Check if order can be cancelled
  bool get canBeCancelled => OrderUtils.canBeCancelled(status);

  /// Check if order can be edited
  bool get canBeEdited => OrderUtils.canEditOrder(status, type, paymentStatus);

  /// Check if table should be available based on this order
  bool get shouldTableBeAvailable =>
      OrderUtils.shouldTableBeAvailable(status, type);

  /// Get next possible statuses for this order
  List<OrderStatus> get nextPossibleStatuses =>
      OrderUtils.getNextPossibleStatuses(status, type);

  /// Get progress percentage
  double get progressPercentage => OrderUtils.getProgressPercentage(status);

  /// Get latest status log
  OrderStatusLogEntity? get latestStatusLog {
    if (statusLogs.isEmpty) return null;
    return statusLogs.first; // Assuming they're ordered by created_at desc
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    status,
    paymentStatus,
    subtotalAmount,
    taxAmount,
    deliveryFee,
    totalAmount,
    deliveryAddress,
    specialInstructions,
    notes,
    table,
    tableId,
    items,
    statusLogs,
    createdAt,
    updatedAt,
  ];
}
