import 'package:equatable/equatable.dart';

/// 🟦 CartItem Entity - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل عنصر في سلة التسوق فقط
class CartItemEntity extends Equatable {
  final int id;
  final int productId;
  final int quantity;
  final double price;
  final String productName;
  final String? productImage;
  final String? productDescription;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productName,
    this.productImage,
    this.productDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate total price for this cart item
  double get totalPrice => price * quantity;

  /// Check if quantity is valid
  bool get isValidQuantity => quantity > 0;

  @override
  List<Object?> get props => [
    id,
    productId,
    quantity,
    price,
    productName,
    productImage,
    productDescription,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'CartItemEntity(id: $id, productId: $productId, quantity: $quantity, price: $price, productName: $productName)';
  }
}