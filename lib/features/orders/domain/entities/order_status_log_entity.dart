import 'package:equatable/equatable.dart';

import '../../../../core/utils/order_utils.dart';
import 'order_enums.dart';

/// 🟩 Order Status Log Entity - Domain Layer
class OrderStatusLogEntity extends Equatable {
  final int id;
  final int orderId;
  final int? userId;
  final OrderType orderType;
  final OrderStatus status;
  final OrderStatus? previousStatus;
  final String? notes;
  final String? changedBy;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderStatusLogEntity({
    required this.id,
    required this.orderId,
    this.userId,
    required this.orderType,
    required this.status,
    this.previousStatus,
    this.notes,
    this.changedBy,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get status display name in Arabic
  String get statusDisplayName => OrderUtils.getStatusDisplayName(status);

  /// Get previous status display name in Arabic
  String? get previousStatusDisplayName => previousStatus != null
      ? OrderUtils.getStatusDisplayName(previousStatus!)
      : null;

  /// Get order type display name in Arabic
  String get orderTypeDisplayName =>
      OrderUtils.getOrderTypeDisplayName(orderType);

  @override
  List<Object?> get props => [
    id,
    orderId,
    userId,
    orderType,
    status,
    previousStatus,
    notes,
    changedBy,
    metadata,
    createdAt,
    updatedAt,
  ];
}
