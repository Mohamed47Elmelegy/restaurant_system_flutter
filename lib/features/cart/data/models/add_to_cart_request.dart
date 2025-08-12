/// 🟦 AddToCartRequest - طلب إضافة منتج إلى السلة
class AddToCartRequest {
  final int productId;
  final int quantity;

  const AddToCartRequest({required this.productId, required this.quantity});

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {'product_id': productId, 'quantity': quantity};
  }

  @override
  String toString() {
    return 'AddToCartRequest(productId: $productId, quantity: $quantity)';
  }
}
