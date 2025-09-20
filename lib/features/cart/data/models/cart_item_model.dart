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
    try {
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
      } else {
        // Create a minimal product model from cart item data
        productModel = ProductModel(
          id: json['product_id']?.toString() ?? '',
          name:
              json['product_name']?.toString() ??
              json['product_name_ar']?.toString() ??
              'Unknown Product',
          price: _parseDouble(json['unit_price']),
          imageUrl: json['product_image']?.toString(),
          mainCategoryId: json['main_category_id']?.toString() ?? '',
          isAvailable: true,
          isFeatured: false,
          sortOrder: 0,
        );
      }

      return CartItemModel(
        id: _parseInt(json['id'], 0),
        quantity: _parseInt(json['quantity'], 1),
        unitPrice: _parseDouble(json['unit_price']),
        product: productModel,
      );
    } catch (e) {
      throw FormatException('Error parsing CartItemModel from JSON: $e');
    }
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

  /// Safely parse int values from various data types
  static int _parseInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }

    return defaultValue;
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
