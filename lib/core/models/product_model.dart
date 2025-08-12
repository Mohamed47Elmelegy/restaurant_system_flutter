import 'dart:math';

import '../base/base_model.dart';
import '../entities/product.dart';
import 'main_category_model.dart';

/// 🟦 ProductModel - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحويل بيانات المنتجات فقط
class ProductModel extends BaseModel<ProductEntity> {
  final String id;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final String price;
  final String mainCategoryId;
  final String? subCategoryId;
  final String? imageUrl;
  final bool isAvailable;
  final String? rating;
  final int? reviewCount;
  final int? preparationTime;
  final List<String>? ingredients;
  final List<String>? allergens;
  final bool isFeatured;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final MainCategoryModel? mainCategory;

  ProductModel({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    required this.price,
    required this.mainCategoryId,
    this.subCategoryId,
    this.imageUrl,
    required this.isAvailable,
    this.rating,
    this.reviewCount,
    this.preparationTime,
    this.ingredients,
    this.allergens,
    required this.isFeatured,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
    this.mainCategory,
  });

  /// Constructor for creating ProductModel from existing data with int id
  factory ProductModel.fromIntId({
    int? id,
    required String name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    required String price,
    required int mainCategoryId,
    int? subCategoryId,
    String? imageUrl,
    required bool isAvailable,
    String? rating,
    int? reviewCount,
    int? preparationTime,
    List<String>? ingredients,
    List<String>? allergens,
    required bool isFeatured,
    required int sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    MainCategoryModel? mainCategory,
  }) {
    return ProductModel(
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

  /// Get price as double
  double get priceAsDouble {
    return double.tryParse(price) ?? 0.0;
  }

  /// Get rating as double
  double get ratingAsDouble {
    return rating != null ? double.tryParse(rating!) ?? 0.0 : 0.0;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      nameAr: json['name_ar'],
      description: json['description'],
      descriptionAr: json['description_ar'],
      price: json['price']?.toString() ?? '0',
      mainCategoryId: json['main_category_id']?.toString() ?? '',
      subCategoryId: json['sub_category_id']?.toString(),
      imageUrl: json['image_url'],
      isAvailable: json['is_available'] ?? true,
      rating: json['rating']?.toString(),
      reviewCount: json['review_count'],
      preparationTime: json['preparation_time'],
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : null,
      allergens: json['allergens'] != null
          ? List<String>.from(json['allergens'])
          : null,
      isFeatured: json['is_featured'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      mainCategory: json['main_category'] != null
          ? MainCategoryModel.fromJson(json['main_category'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'price': price,
      'main_category_id': mainCategoryId,
      'is_available': isAvailable,
      'is_featured': isFeatured,
      'sort_order': sortOrder,
    };

    // Only add non-null optional fields
    if (nameAr != null) data['name_ar'] = nameAr;
    if (description != null && description!.isNotEmpty) {
      data['description'] = description;
    }
    if (descriptionAr != null && descriptionAr!.isNotEmpty) {
      data['description_ar'] = descriptionAr;
    }
    if (subCategoryId != null) data['sub_category_id'] = subCategoryId;
    if (imageUrl != null) data['image_url'] = imageUrl;
    if (rating != null) data['rating'] = rating;
    if (reviewCount != null) data['review_count'] = reviewCount;
    if (preparationTime != null) data['preparation_time'] = preparationTime;
    if (ingredients != null) data['ingredients'] = ingredients;
    if (allergens != null) data['allergens'] = allergens;

    // Only add ID if it's not empty (for updates)
    if (id.isNotEmpty) data['id'] = id;

    // Only add timestamps if they exist (for updates)
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    // Add related models if they exist
    if (mainCategory != null) data['main_category'] = mainCategory!.toJson();

    return data;
  }

  @override
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      
      description: description,
      price: priceAsDouble,
      imageUrl: imageUrl,
      isAvailable: isAvailable,
      rating: rating != null ? double.tryParse(rating!) : null,
      reviewCount: reviewCount,
      preparationTime: preparationTime,
      ingredients: ingredients,
      allergens: allergens,
      isFeatured: isFeatured,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
      mainCategory: mainCategory?.toEntity(),
      mainCategoryId: intMainCategoryId.toString(),
    );
  }

  @override
  ProductModel copyWith(Map<String, dynamic> changes) {
    return ProductModel(
      id: changes['id'] ?? id,
      name: changes['name'] ?? name,
      nameAr: changes['nameAr'] ?? nameAr,
      description: changes['description'] ?? description,
      descriptionAr: changes['descriptionAr'] ?? descriptionAr,
      price: changes['price'] ?? price,
      mainCategoryId: changes['mainCategoryId'] ?? mainCategoryId,
      subCategoryId: changes['subCategoryId'] ?? subCategoryId,
      imageUrl: changes['imageUrl'] ?? imageUrl,
      isAvailable: changes['isAvailable'] ?? isAvailable,
      rating: changes['rating'] ?? rating,
      reviewCount: changes['reviewCount'] ?? reviewCount,
      preparationTime: changes['preparationTime'] ?? preparationTime,
      ingredients: changes['ingredients'] ?? ingredients,
      allergens: changes['allergens'] ?? allergens,
      isFeatured: changes['isFeatured'] ?? isFeatured,
      sortOrder: changes['sortOrder'] ?? sortOrder,
      createdAt: changes['createdAt'] ?? createdAt,
      updatedAt: changes['updatedAt'] ?? updatedAt,
      mainCategory: changes['mainCategory'] ?? mainCategory,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: $price, isAvailable: $isAvailable)';
  }

  /// Create ProductModel from ProductEntity
  static ProductModel fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price.toString(), // Convert double to string
      mainCategoryId: entity.mainCategoryId,
      imageUrl: entity.imageUrl,
      isAvailable: entity.isAvailable ,
      rating: entity.rating?.toString(),
      reviewCount: entity.reviewCount,
      preparationTime: entity.preparationTime,
      ingredients: entity.ingredients,
      allergens: entity.allergens,
      isFeatured: entity.isFeatured ,
      sortOrder: entity.sortOrder ?? 0,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,

    );
  }
}
