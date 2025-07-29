import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    super.id,
    required super.name,
    required super.nameAr,
    super.description,
    super.descriptionAr,
    required super.price,
    required super.mainCategoryId,
    super.subCategoryId,
    super.imageUrl,
    super.isAvailable,
    super.rating,
    super.reviewCount,
    super.preparationTime,
    super.ingredients,
    super.allergens,
    super.isFeatured,
    super.sortOrder,
    super.createdAt,
    super.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      description: json['description'],
      descriptionAr: json['description_ar'],
      price: _parsePrice(json['price']),
      mainCategoryId: json['main_category_id'] ?? 0,
      subCategoryId: json['sub_category_id'],
      imageUrl: json['image_url'],
      isAvailable: json['is_available'] ?? true,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      reviewCount: json['review_count'],
      preparationTime: json['preparation_time'],
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : null,
      allergens: json['allergens'] != null
          ? List<String>.from(json['allergens'])
          : null,
      isFeatured: json['is_featured'] ?? false,
      sortOrder: json['sort_order'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Parse price from various data types (string, num, double)
  /// Fixes the NoSuchMethodError when API returns price as string "23.00"
  ///
  /// Problem: Laravel API returns price as string "23.00" but Flutter expects num
  /// Solution: Handle both string and numeric types safely
  ///
  /// Example error:
  /// NoSuchMethodError: Class 'String' has no instance method 'toDouble'.
  /// Receiver: "23.00"
  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;

    if (price is num) {
      return price.toDouble();
    }

    if (price is String) {
      return double.tryParse(price) ?? 0.0;
    }

    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'name_ar': nameAr,
      if (description != null) 'description': description,
      if (descriptionAr != null) 'description_ar': descriptionAr,
      'price': price,
      'main_category_id': mainCategoryId,
      if (subCategoryId != null) 'sub_category_id': subCategoryId,
      if (imageUrl != null) 'image_url': imageUrl,
      'is_available': isAvailable,
      if (rating != null) 'rating': rating,
      if (reviewCount != null) 'review_count': reviewCount,
      if (preparationTime != null) 'preparation_time': preparationTime,
      if (ingredients != null) 'ingredients': ingredients,
      if (allergens != null) 'allergens': allergens,
      'is_featured': isFeatured,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      nameAr: nameAr,
      description: description,
      descriptionAr: descriptionAr,
      price: price,
      mainCategoryId: mainCategoryId,
      subCategoryId: subCategoryId,
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
}
