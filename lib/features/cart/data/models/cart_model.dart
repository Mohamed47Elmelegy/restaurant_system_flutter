import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import 'cart_item_model.dart';

/// 🟦 CartModel - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحويل بيانات السلة من وإلى JSON فقط
class CartModel extends CartEntity {
  const CartModel({required super.items, required super.subtotal});

  /// Create CartModel from JSON response
  factory CartModel.fromJson(Map<String, dynamic> json) {
    final itemsData = json['items'] as List<dynamic>? ?? [];
    final items = itemsData
        .map((item) => CartItemModel.fromJson(item))
        .toList();

    return CartModel(items: items, subtotal: _parseDouble(json['subtotal']));
  }

  /// Convert CartModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => (item as CartItemModel).toJson()).toList(),
      'subtotal': subtotal,
    };
  }

  /// Create CartModel from CartEntity
  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      items: entity.items
          .map((item) => CartItemModel.fromEntity(item))
          .toList(),
      subtotal: entity.subtotal,
    );
  }

  /// Convert to CartEntity
  CartEntity toEntity() {
    return CartEntity(items: items, subtotal: subtotal);
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

  /// Create copy with changes
  CartModel copyWith({List<CartItemEntity>? items, double? subtotal}) {
    return CartModel(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}
