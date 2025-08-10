import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';

class OrderEntity extends Equatable {
  final int id;
  final int userId;
  final String orderNumber;
  final String status;
  final double totalAmount;
  final String? deliveryAddress;
  final String? notes;
  final List<OrderItemEntity> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    this.deliveryAddress,
    this.notes,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if order is active (not completed or cancelled)
  bool get isActive => 
    status == 'pending' || 
    status == 'confirmed' || 
    status == 'preparing' || 
    status == 'ready' || 
    status == 'out_for_delivery';

  /// Check if order is completed
  bool get isCompleted => status == 'delivered' || status == 'completed';

  /// Check if order is cancelled
  bool get isCancelled => status == 'cancelled';

  @override
  List<Object?> get props => [
    id,
    userId,
    orderNumber,
    status,
    totalAmount,
    deliveryAddress,
    notes,
    items,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'OrderEntity(id: $id, orderNumber: $orderNumber, status: $status, totalAmount: $totalAmount)';
  }
}

