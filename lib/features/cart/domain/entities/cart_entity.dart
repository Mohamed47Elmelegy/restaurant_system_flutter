import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

/// 🟦 Cart Entity - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل السلة كاملة فقط
class CartEntity extends Equatable {
  final List<CartItemEntity> items;
  final double subtotal;

  const CartEntity({required this.items, required this.subtotal});

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Get total items count (sum of quantities)
  int get totalItemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Get unique items count (number of different products)
  int get uniqueItemsCount => items.length;

  /// Get item by product ID
  CartItemEntity? getItemByProductId(int productId) {
    try {
      return items.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  /// Check if product exists in cart
  bool hasProduct(int productId) {
    return items.any((item) => item.productId == productId);
  }

  @override
  List<Object?> get props => [items, subtotal];

  @override
  String toString() {
    return 'CartEntity(items: ${items.length}, subtotal: $subtotal)';
  }
}
