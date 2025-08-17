import '../../domain/entities/order_item_entity.dart';

/// 🟨 Order Item Model - Data Layer
class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.id,
    required super.orderId,
    required super.menuItemId,
    required super.name,
    super.description,
    super.image,
    required super.unitPrice,
    required super.quantity,
    required super.totalPrice,
    super.specialInstructions,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Factory constructor from JSON
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int? ?? 0,
      orderId: json['order_id'] as int? ?? 0,
      menuItemId: json['menu_item_id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      unitPrice: double.parse(json['unit_price'].toString()),
      quantity: json['quantity'] as int? ?? 0,
      totalPrice: double.parse(json['total_price'].toString()),
      specialInstructions: json['special_instructions']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'menu_item_id': menuItemId,
      'name': name,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
      'unit_price': unitPrice.toStringAsFixed(2),
      'quantity': quantity,
      'total_price': totalPrice.toStringAsFixed(2),
      if (specialInstructions != null)
        'special_instructions': specialInstructions,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  OrderItemModel copyWith({
    int? id,
    int? orderId,
    int? menuItemId,
    String? name,
    String? description,
    String? image,
    double? unitPrice,
    int? quantity,
    double? totalPrice,
    String? specialInstructions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      menuItemId: menuItemId ?? this.menuItemId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert from entity to model
  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      id: entity.id,
      orderId: entity.orderId,
      menuItemId: entity.menuItemId,
      name: entity.name,
      description: entity.description,
      image: entity.image,
      unitPrice: entity.unitPrice,
      quantity: entity.quantity,
      totalPrice: entity.totalPrice,
      specialInstructions: entity.specialInstructions,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Factory constructor from cart item (for placing orders)
  factory OrderItemModel.fromCartItem({
    required int menuItemId,
    required String name,
    String? description,
    String? image,
    required double unitPrice,
    required int quantity,
    String? specialInstructions,
  }) {
    final now = DateTime.now();
    return OrderItemModel(
      id: 0, // Will be set by backend
      orderId: 0, // Will be set by backend
      menuItemId: menuItemId,
      name: name,
      description: description,
      image: image,
      unitPrice: unitPrice,
      quantity: quantity,
      totalPrice: unitPrice * quantity,
      specialInstructions: specialInstructions,
      createdAt: now,
      updatedAt: now,
    );
  }
}
