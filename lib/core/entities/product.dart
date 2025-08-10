import '../base/base_entity.dart';

/// 🟦 Product Entity - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل منتج في الأعمال فقط
class ProductEntity extends BaseEntity {
  final String name;
  final String? description;

  final double price;
  final int mainCategoryId;
  final String? imageUrl;
  final bool isAvailable;
  final double? rating;
  final int? reviewCount;
  final int? preparationTime;
  final List<String>? ingredients;
  final List<String>? allergens;
  final bool isFeatured;
  final int? sortOrder;

  const ProductEntity({
    required super.id,
    required this.name,
    this.description,
    
    required this.price,
    required this.mainCategoryId,
    this.imageUrl,
    this.isAvailable = true,
    this.rating,
    this.reviewCount,
    this.preparationTime,
    this.ingredients,
    this.allergens,
    this.isFeatured = false,
    this.sortOrder,
    super.createdAt,
    super.updatedAt,
  });

  /// Constructor for creating Product from existing data with int id
  factory ProductEntity.fromIntId({
    int? id,
    required String name,
    String? description,
    required double price,
    required int mainCategoryId,
    String? imageUrl,
    bool isAvailable = true,
    double? rating,
    int? reviewCount,
    int? preparationTime,
    List<String>? ingredients,
    List<String>? allergens,
    bool isFeatured = false,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductEntity(
      id: id?.toString() ?? '',
      name: name,
      description: description,
      price: price,
      mainCategoryId: mainCategoryId,
      imageUrl: imageUrl,
      isAvailable: isAvailable,
      rating: rating,
      reviewCount: reviewCount,
      preparationTime: preparationTime,
      ingredients: ingredients,
      allergens: allergens,
      isFeatured: isFeatured,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Get int id for backward compatibility
  int? get intId {
    return int.tryParse(id);
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    
    price,
    mainCategoryId,
    imageUrl,
    isAvailable,
    rating,
    reviewCount,
    preparationTime,
    ingredients,
    allergens,
    isFeatured,
    sortOrder,
    createdAt,
    updatedAt,
  ];

  @override
  ProductEntity copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    double? price,
    int? mainCategoryId,
    String? imageUrl,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
    int? preparationTime,
    List<String>? ingredients,
    List<String>? allergens,
    bool? isFeatured,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      mainCategoryId: mainCategoryId ?? this.mainCategoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      preparationTime: preparationTime ?? this.preparationTime,
      ingredients: ingredients ?? this.ingredients,
      allergens: allergens ?? this.allergens,
      isFeatured: isFeatured ?? this.isFeatured,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'main_category_id': mainCategoryId,
      'image_url': imageUrl,
      'is_available': isAvailable,
      'rating': rating,
      'review_count': reviewCount,
      'preparation_time': preparationTime,
      'ingredients': ingredients,
      'allergens': allergens,
      'is_featured': isFeatured,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool get isValid {
    return name.isNotEmpty && price > 0 && mainCategoryId > 0;
  }

  

  /// Get formatted price with currency
  String getFormattedPrice() {
    return '${price.toStringAsFixed(2)} ر.س';
  }

  /// Get preparation time text
  String getPreparationTimeText() {
    if (preparationTime == null || preparationTime == 0) {
      return 'غير محدد';
    }
    return '$preparationTime دقيقة';
  }

  /// Get rating text
  String getRatingText() {
    if (rating == null || reviewCount == null) {
      return 'لا توجد تقييمات';
    }
    return '$rating ($reviewCount تقييم)';
  }

  /// Check if product is popular
  bool get isPopular {
    return (rating ?? 0) >= 4.0 && (reviewCount ?? 0) >= 5;
  }

  /// Check if product is expensive
  bool get isExpensive {
    return price > 30.0; // يمكن تعديل هذا المعيار
  }
}
