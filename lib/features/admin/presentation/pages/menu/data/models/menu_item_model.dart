import '../../../../../../../core/base/base_model.dart';
import '../../domain/entities/menu_item.dart';

class MenuItemModel extends BaseModel<MenuItem> {
  MenuItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.imagePath,
    this.description,
    this.isAvailable = true,
  });

  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviewCount;
  final String price;
  final String imagePath;
  final String? description;
  final bool isAvailable;

  /// Constructor for creating MenuItemModel from existing data with int id
  factory MenuItemModel.fromIntId({
    int? id,
    required String name,
    required String category,
    required double rating,
    required int reviewCount,
    required String price,
    required String imagePath,
    String? description,
    bool isAvailable = true,
  }) {
    return MenuItemModel(
      id: id?.toString() ?? '',
      name: name,
      category: category,
      rating: rating,
      reviewCount: reviewCount,
      price: price,
      imagePath: imagePath,
      description: description,
      isAvailable: isAvailable,
    );
  }

  /// Get int id for backward compatibility
  int? get intId {
    return int.tryParse(id);
  }

  // Factory constructor from JSON
  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String,
      category: json['category'] as String,
      rating: _parseDouble(json['rating']),
      reviewCount: json['reviewCount'] as int? ?? 0,
      price: json['price'] as String,
      imagePath: json['imagePath'] as String,
      description: json['description'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
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

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'price': price,
      'imagePath': imagePath,
      'description': description,
      'isAvailable': isAvailable,
    };
  }

  @override
  MenuItem toEntity() {
    return MenuItem(
      id: id,
      name: name,
      category: category,
      rating: rating,
      reviewCount: reviewCount,
      price: price,
      imagePath: imagePath,
      description: description,
      isAvailable: isAvailable,
    );
  }

  @override
  MenuItemModel copyWith(Map<String, dynamic> changes) {
    return MenuItemModel(
      id: changes['id'] ?? id,
      name: changes['name'] ?? name,
      category: changes['category'] ?? category,
      rating: changes['rating'] ?? rating,
      reviewCount: changes['reviewCount'] ?? reviewCount,
      price: changes['price'] ?? price,
      imagePath: changes['imagePath'] ?? imagePath,
      description: changes['description'] ?? description,
      isAvailable: changes['isAvailable'] ?? isAvailable,
    );
  }

  // Create from entity
  factory MenuItemModel.fromEntity(MenuItem entity) {
    return MenuItemModel(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      price: entity.price,
      imagePath: entity.imagePath,
      description: entity.description,
      isAvailable: entity.isAvailable,
    );
  }

  // Comparison methods
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuItemModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MenuItemModel(id: $id, name: $name, category: $category, price: $price)';
  }
}
