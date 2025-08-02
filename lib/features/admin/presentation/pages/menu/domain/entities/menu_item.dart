import '../../../../../../../core/base/base_entity.dart';

class MenuItem extends BaseEntity {
  const MenuItem({
    required super.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.imagePath,
    this.description,
    this.isAvailable = true,
    super.createdAt,
    super.updatedAt,
  });

  final String name;
  final String category;
  final double rating;
  final int reviewCount;
  final String price;
  final String imagePath;
  final String? description;
  final bool isAvailable;

  /// Constructor for creating MenuItem from existing data with int id
  factory MenuItem.fromIntId({
    int? id,
    required String name,
    required String category,
    required double rating,
    required int reviewCount,
    required String price,
    required String imagePath,
    String? description,
    bool isAvailable = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuItem(
      id: id?.toString() ?? '',
      name: name,
      category: category,
      rating: rating,
      reviewCount: reviewCount,
      price: price,
      imagePath: imagePath,
      description: description,
      isAvailable: isAvailable,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Get int id for backward compatibility
  int? get intId {
    return int.tryParse(id);
  }

  @override
  MenuItem copyWith({
    String? id,
    String? name,
    String? category,
    double? rating,
    int? reviewCount,
    String? price,
    String? imagePath,
    String? description,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'rating': rating,
      'review_count': reviewCount,
      'price': price,
      'image_path': imagePath,
      'description': description,
      'is_available': isAvailable,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool get isValid {
    return name.isNotEmpty &&
        category.isNotEmpty &&
        price.isNotEmpty &&
        imagePath.isNotEmpty &&
        rating >= 0 &&
        reviewCount >= 0;
  }

  // Business logic methods
  String get formattedPrice => '\$$price';
  String get ratingText => '$rating (${reviewCount} reviews)';
  bool get isExpensive => (double.tryParse(price) ?? 0) > 20;
  bool get isPopular => rating >= 4.0 && reviewCount >= 10;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MenuItem(id: $id, name: $name, category: $category, price: $price)';
  }
}
