import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_enums.dart';
import 'order_item_model.dart';
import 'order_status_log_model.dart';
import 'table_model.dart';

/// 🟨 Order Model - Data Layer
class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.status,
    required super.paymentStatus,
    required super.subtotalAmount,
    required super.taxAmount,
    required super.deliveryFee,
    required super.totalAmount,
    super.deliveryAddress,
    super.specialInstructions,
    super.notes,
    super.paymentMethod,
    super.table,
    super.tableId,
    required super.items,
    super.statusLogs = const [],
    required super.createdAt,
    required super.updatedAt,
  });

  /// Factory constructor from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderModel(
        id: (json['id'] is int)
            ? json['id'] as int
            : int.tryParse(json['id']?.toString() ?? '') ?? 0,
        userId: (json['user_id'] is int)
            ? json['user_id'] as int
            : int.tryParse(json['user_id']?.toString() ?? '') ?? 0,
        type: _parseOrderType(json['type']?.toString() ?? 'dine_in'),
        status: _parseOrderStatus(json['status']?.toString() ?? 'pending'),
        paymentStatus: _parsePaymentStatus(
          json['payment_status']?.toString() ?? 'unpaid',
        ),
        subtotalAmount: _parseDouble(json['subtotal_amount'], 0.0),
        taxAmount: _parseDouble(json['tax_amount'], 0.0),
        deliveryFee: _parseDouble(json['delivery_fee'], 0.0),
        totalAmount: _parseDouble(json['total_amount'], 0.0),
        deliveryAddress: _parseString(json['delivery_address']),
        specialInstructions: _parseString(json['special_instructions']),
        notes: _parseString(json['notes']),
        paymentMethod: _parseString(json['payment_method']),
        tableId: (json['table_id'] is int)
            ? json['table_id'] as int
            : int.tryParse(json['table_id']?.toString() ?? '') ?? 0,
        table: json['table'] != null
            ? TableModel.fromJson(json['table'] as Map<String, dynamic>)
            : null,
        items: _parseOrderItems(json['items']),
        statusLogs: _parseStatusLogs(json['status_logs']),
        createdAt: _parseDateTime(json['created_at']),
        updatedAt: _parseDateTime(json['updated_at']),
      );
    } catch (e) {
      throw FormatException('Error parsing OrderModel from JSON: $e');
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': _orderTypeToString(type),
      'status': _orderStatusToString(status),
      'payment_status': _paymentStatusToString(paymentStatus),
      'subtotal_amount': subtotalAmount.toStringAsFixed(2),
      'tax_amount': taxAmount.toStringAsFixed(2),
      'delivery_fee': deliveryFee.toStringAsFixed(2),
      'total_amount': totalAmount.toStringAsFixed(2),
      if (deliveryAddress != null) 'delivery_address': deliveryAddress,
      if (specialInstructions != null)
        'special_instructions': specialInstructions,
      if (notes != null) 'notes': notes,
      if (table != null) 'table': (table as TableModel).toJson(),
      'items': items.map((item) => (item as OrderItemModel).toJson()).toList(),
      'status_logs': statusLogs
          .map((log) => (log as OrderStatusLogModel).toJson())
          .toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convert from entity to model
  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      status: entity.status,
      paymentStatus: entity.paymentStatus,
      subtotalAmount: entity.subtotalAmount,
      taxAmount: entity.taxAmount,
      deliveryFee: entity.deliveryFee,
      totalAmount: entity.totalAmount,
      deliveryAddress: entity.deliveryAddress,
      paymentMethod: entity.paymentMethod,
      specialInstructions: entity.specialInstructions,
      notes: entity.notes,
      table: entity.table != null ? TableModel.fromEntity(entity.table!) : null,
      items: entity.items
          .map((item) => OrderItemModel.fromEntity(item))
          .toList(),
      statusLogs: entity.statusLogs
          .map((log) => OrderStatusLogModel.fromEntity(log))
          .toList(),
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
  static PaymentStatus _parsePaymentStatus(String status) {
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

  /// Convert payment status to string
  static String _paymentStatusToString(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.unpaid:
        return 'unpaid';
      case PaymentStatus.paid:
        return 'paid';
      case PaymentStatus.refunded:
        return 'refunded';
    }
  }

  /// Safe string parsing with null handling
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString().trim().isEmpty ? null : value.toString().trim();
  }

  /// Safe double parsing with default value
  static double _parseDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    try {
      if (value is num) return value.toDouble();
      return double.parse(value.toString());
    } catch (e) {
      return defaultValue;
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

  /// Safe order items parsing
  static List<OrderItemModel> _parseOrderItems(dynamic items) {
    if (items == null || items is! List) return [];
    try {
      return items
          .whereType<Map<String, dynamic>>()
          .map((item) => OrderItemModel.fromJson(item))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Safe status logs parsing
  static List<OrderStatusLogModel> _parseStatusLogs(dynamic logs) {
    if (logs == null || logs is! List) return [];
    try {
      return logs
          .whereType<Map<String, dynamic>>()
          .map((log) => OrderStatusLogModel.fromJson(log))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
