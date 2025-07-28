import '../../domain/entities/menu_item.dart';

class MenuItemModel {
  const MenuItemModel({
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

  // Factory constructor from JSON
  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      price: json['price'] as String,
      imagePath: json['imagePath'] as String,
      description: json['description'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
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

  // Convert to entity
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

  // Copy with method
  MenuItemModel copyWith({
    String? id,
    String? name,
    String? category,
    double? rating,
    int? reviewCount,
    String? price,
    String? imagePath,
    String? description,
    bool? isAvailable,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  // Data conversion methods only - no business logic
  // Business logic should be in Domain layer or Use Cases

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
