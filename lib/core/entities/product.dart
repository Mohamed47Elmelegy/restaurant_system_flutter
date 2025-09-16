import 'package:restaurant_system_flutter/core/entities/main_category.dart';

import '../base/base_entity.dart';

/// 🟦 Product Entity - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل منتج في الأعمال فقط
class ProductEntity extends BaseEntity {
  final String name;
  final String? nameAr; // إضافة الحقل
  final String? description;
  final String? descriptionAr; // إضافة الحقل
  final double price;
  final String mainCategoryId;
  final String? subCategoryId;
  final String? imageUrl;
  final bool isAvailable;
  final double? rating;
  final int? reviewCount;
  final int? preparationTime;
  final List<String>? ingredients;
  final List<String>? allergens;
  final bool isFeatured;
  final int? sortOrder;
  final CategoryEntity? mainCategory;

  const ProductEntity({
    required super.id,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    required this.price,
    required this.mainCategoryId,
    this.subCategoryId,
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
    this.mainCategory,
  });

  /// Constructor for creating Product from existing data with int id
  factory ProductEntity.fromIntId({
    int? id,
    required String name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    required double price,
    required int mainCategoryId,
    int? subCategoryId,
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
    CategoryEntity? mainCategory,
  }) {
    return ProductEntity(
      id: id?.toString() ?? '',
      name: name,
      nameAr: nameAr,
      description: description,
      descriptionAr: descriptionAr,
      price: price,
      mainCategoryId: mainCategoryId.toString(),
      subCategoryId: subCategoryId?.toString(),
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
      mainCategory: mainCategory,
    );
  }

  /// Get int id for backward compatibility
  int? get intId {
    return int.tryParse(id);
  }

  /// Get int main category id for backward compatibility
  int? get intMainCategoryId {
    return int.tryParse(mainCategoryId);
  }

  /// Get int sub category id for backward compatibility
  int? get intSubCategoryId {
    return subCategoryId != null ? int.tryParse(subCategoryId!) : null;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    nameAr,
    description,
    descriptionAr,
    price,
    mainCategoryId,
    subCategoryId,
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
    mainCategory,
  ];

  @override
  ProductEntity copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    double? price,
    String? mainCategoryId,
    String? subCategoryId,
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
    CategoryEntity? mainCategory,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      price: price ?? this.price,
      mainCategoryId: mainCategoryId ?? this.mainCategoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
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
      mainCategory: mainCategory ?? this.mainCategory,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'description_ar': descriptionAr,
      'price': price,
      'main_category_id': mainCategoryId,
      'sub_category_id': subCategoryId,
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
    return name.isNotEmpty &&
        nameAr != null &&
        nameAr!.isNotEmpty &&
        price > 0 &&
        mainCategoryId.isNotEmpty &&
        imageUrl != null &&
        imageUrl!.isNotEmpty;
  }

  factory ProductEntity.fake() {
    return const ProductEntity(
      id: '0',
      name: 'Test Product',
      nameAr: 'منتج تجريبي',
      price: 25.0,
      imageUrl: 'https://via.placeholder.com/300',
      mainCategoryId: '1',
    );
  }

  /// Get formatted price with currency
  String getFormattedPrice() {
    return '${price.toStringAsFixed(2)} EGP';
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
