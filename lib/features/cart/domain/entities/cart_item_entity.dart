import 'package:equatable/equatable.dart';

import '../../../../core/models/product_model.dart';

/// 🟦 CartItem Entity - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل عنصر في سلة التسوق فقط
// ignore: must_be_immutable
class CartItemEntity extends Equatable {
  final int id;
  final int quantity;
  final double unitPrice;
  final ProductModel product;

  const CartItemEntity({
    required this.id,
    required this.quantity,
    required this.unitPrice,
    required this.product,
  });

  /// Calculate total price for this cart item
  double get totalPrice => unitPrice * quantity;

  /// Check if quantity is valid
  bool get isValidQuantity => quantity > 0;

  /// Get product name safely
  String get productName => product.name;

  /// Get product price safely
  String get productPrice => product.price;

  CartItemEntity copyWith({
    int? quantity,
    double? unitPrice,
    ProductModel? product,
  }) {
    return CartItemEntity(
      id: id,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      product: product ?? this.product,
    );
  }

  @override
  List<Object?> get props => [id, product.id, quantity, unitPrice, product];

  @override
  String toString() {
    return 'CartItemEntity(id: $id, productId:  [200m${product.id} [0m, quantity: $quantity, unitPrice: $unitPrice, product: $product)';
  }
}
