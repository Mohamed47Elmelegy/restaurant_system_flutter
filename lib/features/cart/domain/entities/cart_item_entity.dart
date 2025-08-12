import 'package:equatable/equatable.dart';

/// 🟦 CartItem Entity - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل عنصر في سلة التسوق فقط
class CartItemEntity extends Equatable {
  final int id;
  final int productId;
  final int quantity;
  final double unitPrice;
  final ProductInfo? product;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.product,
  });

  /// Calculate total price for this cart item
  double get totalPrice => unitPrice * quantity;

  /// Check if quantity is valid
  bool get isValidQuantity => quantity > 0;

  /// Get product name safely
  String get productName => product?.name ?? 'Unknown Product';

  /// Get product price safely
  String get productPrice => product?.price ?? unitPrice.toString();

  @override
  List<Object?> get props => [id, productId, quantity, unitPrice, product];

  @override
  String toString() {
    return 'CartItemEntity(id: $id, productId: $productId, quantity: $quantity, unitPrice: $unitPrice, product: $product)';
  }
}

/// 🟦 ProductInfo - معلومات المنتج المرفقة مع عنصر السلة
class ProductInfo extends Equatable {
  final int id;
  final String name;
  final String price;
  final String? imageUrl;

  const ProductInfo({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, price, imageUrl];

  @override
  String toString() {
    return 'ProductInfo(id: $id, name: $name, price: $price, imageUrl: $imageUrl)';
  }
}
