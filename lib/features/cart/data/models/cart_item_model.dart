import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.productId,
    required super.quantity,
    required super.unitPrice,
    super.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // Parse product info if available
    ProductInfo? productInfo;
    if (json['product'] != null) {
      final productData = json['product'] as Map<String, dynamic>;
      productInfo = ProductInfo(
        id: productData['id'] ?? 0,
        name: productData['name'] ?? '',
        price: productData['price']?.toString() ?? '0',
        imageUrl: productData['image_url'] ?? productData['image'],
      );
    }

    return CartItemModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      quantity: json['quantity'] ?? 1,
      unitPrice: _parseDouble(json['unit_price']),
      product: productInfo,
    );
  }

  /// Safely parse double values from various data types
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      id: entity.id,
      productId: entity.productId,
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
      product: entity.product,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
    };

    // Add product info if available
    if (product != null) {
      data['product'] = {
        'id': product!.id,
        'name': product!.name,
        'price': product!.price,
        'image_url': product!.imageUrl,
      };
    }

    return data;
  }

  CartItemModel copyWith({
    int? id,
    int? productId,
    int? quantity,
    double? unitPrice,
    ProductInfo? product,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      product: product ?? this.product,
    );
  }
}
