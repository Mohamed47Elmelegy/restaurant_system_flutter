import 'package:equatable/equatable.dart';
import 'table_entity.dart';
import 'order_item_entity.dart';

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
  final TableEntity? table;
  final int? tableId;
  final List<OrderItemEntity> items;
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
    this.table,
    this.tableId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if this is a dine-in order
  bool get isDineIn => type == OrderType.dineIn;

  /// Check if this is a delivery order
  bool get isDelivery => type == OrderType.delivery;

  /// Check if order has delivery fee
  bool get hasDeliveryFee => deliveryFee > 0;

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
    createdAt,
    updatedAt,
  ];
}

/// Order Type Enum
enum OrderType { dineIn, delivery }

/// Order Status Enum
enum OrderStatus { pending, preparing, ready, completed, cancelled }

/// Payment Status Enum
enum PaymentStatus { unpaid, paid, refunded }
