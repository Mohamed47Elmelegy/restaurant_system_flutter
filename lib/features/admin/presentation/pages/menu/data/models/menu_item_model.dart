import '../../domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  const MenuItemModel({
    required super.id,
    required super.name,
    required super.category,
    required super.rating,
    required super.reviewCount,
    required super.price,
    required super.imagePath,
    super.description,
    super.isAvailable,
  });

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
  @override
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
  @override
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

  // Business logic methods
  bool get isExpensive =>
      double.tryParse(price) != null && double.parse(price) > 50;

  bool get isPopular => rating >= 4.5 && reviewCount >= 5;

  String get formattedPrice => '\$$price';

  String get ratingText => '$rating ($reviewCount Review)';

  String get categoryDisplayName {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      default:
        return category;
    }
  }

  // Validation methods
  bool get isValid {
    return id.isNotEmpty &&
        name.isNotEmpty &&
        category.isNotEmpty &&
        price.isNotEmpty &&
        rating >= 0 &&
        rating <= 5 &&
        reviewCount >= 0;
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
