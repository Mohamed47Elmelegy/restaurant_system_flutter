import '../../domain/entities/order_enums.dart';
import '../../domain/entities/order_status_log_entity.dart';

/// 🟨 Order Status Log Model - Data Layer
class OrderStatusLogModel extends OrderStatusLogEntity {
  const OrderStatusLogModel({
    required super.id,
    required super.orderId,
    super.userId,
    required super.orderType,
    required super.status,
    super.previousStatus,
    super.notes,
    super.changedBy,
    super.metadata,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Factory constructor from JSON
  factory OrderStatusLogModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderStatusLogModel(
        id: _parseInt(json['id'], 0),
        orderId: _parseInt(json['order_id'], 0),
        userId: _parseIntNullable(json['user_id']),
        orderType: _parseOrderType(json['order_type']?.toString() ?? 'dine_in'),
        status: _parseOrderStatus(json['status']?.toString() ?? 'pending'),
        previousStatus: json['previous_status'] != null
            ? _parseOrderStatus(
                json['previous_status']?.toString() ?? 'pending',
              )
            : null,
        notes: _parseString(json['notes']),
        changedBy: _parseString(json['changed_by']),
        metadata: json['metadata'] != null
            ? Map<String, dynamic>.from(json['metadata'] as Map)
            : null,
        createdAt: _parseDateTime(json['created_at']),
        updatedAt: _parseDateTime(json['updated_at']),
      );
    } catch (e) {
      throw FormatException('Error parsing OrderStatusLogModel from JSON: $e');
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      if (userId != null) 'user_id': userId,
      'order_type': _orderTypeToString(orderType),
      'status': _orderStatusToString(status),
      if (previousStatus != null)
        'previous_status': _orderStatusToString(previousStatus!),
      if (notes != null) 'notes': notes,
      if (changedBy != null) 'changed_by': changedBy,
      if (metadata != null) 'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convert from entity to model
  factory OrderStatusLogModel.fromEntity(OrderStatusLogEntity entity) {
    return OrderStatusLogModel(
      id: entity.id,
      orderId: entity.orderId,
      userId: entity.userId,
      orderType: entity.orderType,
      status: entity.status,
      previousStatus: entity.previousStatus,
      notes: entity.notes,
      changedBy: entity.changedBy,
      metadata: entity.metadata,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Parse order type from string
  static OrderType _parseOrderType(String type) {
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
  static OrderStatus _parseOrderStatus(String status) {
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
      default:
        throw ArgumentError('Unknown order status: $status');
    }
  }

  /// Convert order type to string
  static String _orderTypeToString(OrderType type) {
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
  static String _orderStatusToString(OrderStatus status) {
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

  /// Safe string parsing with null handling
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString().trim().isEmpty ? null : value.toString().trim();
  }

  /// Safe int parsing with default value
  static int _parseInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    try {
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.parse(value.toString());
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safe int parsing with nullable result
  static int? _parseIntNullable(dynamic value) {
    if (value == null) return null;
    try {
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.parse(value.toString());
    } catch (e) {
      return null;
    }
  }

  /// Safe DateTime parsing
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now();
    }
  }
}
