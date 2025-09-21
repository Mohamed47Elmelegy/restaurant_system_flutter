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
    try {
      return OrderItemModel(
        id: _parseInt(json['id'], 0),
        orderId: _parseInt(json['order_id'], 0),
        menuItemId: _parseInt(
          json['menu_item_id'],
          _parseInt(json['product_id'], 0),
        ),
        // Handle both name (frontend) and product_name_ar (backend)
        name:
            _parseString(json['name']) ??
            _parseString(json['product_name_ar']) ??
            _parseString(json['product_name']) ??
            '',
        description: _parseString(json['description']) ?? '',
        image: _parseString(json['image']) ?? '',
        unitPrice: _parseDouble(json['unit_price'], 0.0),
        quantity: _parseInt(json['quantity'], 0),
        totalPrice: _parseDouble(json['total_price'], 0.0),
        specialInstructions: _parseString(json['special_instructions']) ?? '',
        createdAt: _parseDateTime(json['created_at']),
        updatedAt: _parseDateTime(json['updated_at']),
      );
    } catch (e) {
      throw FormatException('Error parsing OrderItemModel from JSON: $e');
    }
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

  /// Safe string parsing with null handling
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString().trim().isEmpty ? null : value.toString().trim();
  }

  /// Safe int parsing with default value
  static int _parseInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    try {
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.parse(value.toString());
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safe double parsing with default value
  static double _parseDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    try {
      if (value is num) return value.toDouble();
      return double.parse(value.toString());
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safe DateTime parsing
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now();
    }
  }
}
