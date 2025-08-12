/// 🟦 UpdateCartItemRequest - طلب تحديث كمية عنصر في السلة
class UpdateCartItemRequest {
  final int quantity;

  const UpdateCartItemRequest({required this.quantity});

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {'quantity': quantity};
  }

  @override
  String toString() {
    return 'UpdateCartItemRequest(quantity: $quantity)';
  }
}
