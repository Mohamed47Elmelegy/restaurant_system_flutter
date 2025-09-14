import '../../../../core/models/product_model.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.quantity,
    required super.unitPrice,
    required super.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // Parse product info if available
    ProductModel? productModel;
    if (json['product'] != null) {
      final productData = json['product'] as Map<String, dynamic>;
      productModel = ProductModel(
        id: productData['id']?.toString() ?? '',
        name: productData['name'] ?? '',
        price: _parseDouble(productData['price']),
        imageUrl: productData['image_url'] ?? productData['image'],
        mainCategoryId: productData['main_category_id']?.toString() ?? '',
        isAvailable: productData['is_available'] ?? false,
        isFeatured: productData['is_featured'] ?? false,
        sortOrder: productData['sort_order'] ?? 0,
      );
    }

    return CartItemModel(
      id: json['id'] ?? 0,
      quantity: json['quantity'] ?? 1,
      unitPrice: _parseDouble(json['unit_price']),
      product: productModel!,
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
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
      product: entity.product,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'quantity': quantity,
      'unit_price': unitPrice,
      'product': product.toJson(),
    };

    return data;
  }

  @override
  CartItemModel copyWith({
    int? id,
    int? quantity,
    double? unitPrice,
    ProductModel? product,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      product: product ?? this.product,
    );
  }
}
