import 'package:equatable/equatable.dart';

/// 🟩 Order Item Entity - Domain Layer
class OrderItemEntity extends Equatable {
  final int id;
  final int orderId;
  final int menuItemId;
  final String name;
  final String? description;
  final String? image;
  final double unitPrice;
  final int quantity;
  final double totalPrice;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderItemEntity({
    required this.id,
    required this.orderId,
    required this.menuItemId,
    required this.name,
    this.description,
    this.image,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    this.specialInstructions,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate total price for this item
  double get calculatedTotal => unitPrice * quantity;

  /// Check if item has special instructions
  bool get hasSpecialInstructions =>
      specialInstructions != null && specialInstructions!.isNotEmpty;

  /// Get formatted unit price
  String get formattedUnitPrice => unitPrice.toStringAsFixed(2);

  /// Get formatted total price
  String get formattedTotalPrice => totalPrice.toStringAsFixed(2);

  @override
  List<Object?> get props => [
    id,
    orderId,
    menuItemId,
    name,
    description,
    image,
    unitPrice,
    quantity,
    totalPrice,
    specialInstructions,
    createdAt,
    updatedAt,
  ];
}
