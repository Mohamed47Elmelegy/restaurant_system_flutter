import '../../domain/entities/order_entity.dart';
import 'order_item_model.dart';
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
    required super.items,
    required super.createdAt,
    required super.updatedAt,
    super.tableId, // أضف هذا السطرg
  });

  /// Factory constructor from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      userId: (json['user_id'] is int)
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? '') ?? 0,
      type: _parseOrderType(json['type'] as String),
      status: _parseOrderStatus(json['status'] as String),
      paymentStatus: _parsePaymentStatus(json['payment_status'] as String),
      subtotalAmount: double.parse(json['subtotal_amount'].toString()),
      taxAmount: double.parse(json['tax_amount'].toString()),
      deliveryFee: double.parse(json['delivery_fee'].toString()),
      totalAmount: double.parse(json['total_amount'].toString()),
      deliveryAddress: json['delivery_address']?.toString() ?? '',
      specialInstructions: json['special_instructions']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? '',
      tableId: (json['table_id'] is int)
          ? json['table_id'] as int
          : int.tryParse(json['table_id']?.toString() ?? '') ?? 0,
      table: json['table'] != null
          ? TableModel.fromJson(json['table'] as Map<String, dynamic>)
          : null,
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (item) => OrderItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
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
      default:
        throw ArgumentError('Unknown order type: $type');
    }
  }

  /// Parse order status from string
  static OrderStatus _parseOrderStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'paid':
        return OrderStatus.paid;
      case 'preparing':
        return OrderStatus.preparing;
      case 'delivering':
        return OrderStatus.delivering;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      // Legacy support for 'ready' -> 'delivering'
      case 'ready':
        return OrderStatus.delivering;
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
    }
  }

  /// Convert order status to string
  static String _orderStatusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.paid:
        return 'paid';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.delivering:
        return 'delivering';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.cancelled:
        return 'cancelled';
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
}
