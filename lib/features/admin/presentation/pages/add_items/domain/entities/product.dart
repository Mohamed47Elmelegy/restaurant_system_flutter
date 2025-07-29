import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int? id;
  final String name;
  final String nameAr;
  final String? description;
  final String? descriptionAr;
  final double price;
  final int mainCategoryId;
  final int? subCategoryId;
  final String? imageUrl;
  final bool isAvailable;
  final double? rating;
  final int? reviewCount;
  final int? preparationTime;
  final List<String>? ingredients;
  final List<String>? allergens;
  final bool isFeatured;
  final int? sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Product({
    this.id,
    required this.name,
    required this.nameAr,
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
    this.createdAt,
    this.updatedAt,
  });

  /// Get display name based on current locale
  String getDisplayName({bool isArabic = true}) {
    return isArabic ? nameAr : name;
  }

  /// Get description based on current locale
  String? getDescription({bool isArabic = true}) {
    return isArabic ? descriptionAr : description;
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
  ];

  Product copyWith({
    int? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    double? price,
    int? mainCategoryId,
    int? subCategoryId,
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
    return Product(
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
    );
  }
}
