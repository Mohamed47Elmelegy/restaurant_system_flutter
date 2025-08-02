import '../../domain/entities/product.dart';
import '../../../../../../../core/base/base_model.dart';

/// 🟦 ProductModel - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحويل البيانات من/إلى JSON والـ Entity
class ProductModel extends BaseModel<Product> {
  final String id;
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

  ProductModel({
    required this.id,
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

  /// Constructor for creating ProductModel from existing data with int id
  factory ProductModel.fromIntId({
    int? id,
    required String name,
    required String nameAr,
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
  }) {
    return ProductModel(
      id: id?.toString() ?? '',
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

  /// Get int id for backward compatibility
  int? get intId {
    return int.tryParse(id);
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
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

  /// Create ProductModel from Product entity
  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      nameAr: entity.nameAr,
      description: entity.description,
      descriptionAr: entity.descriptionAr,
      price: entity.price,
      mainCategoryId: entity.mainCategoryId,
      subCategoryId: entity.subCategoryId,
      imageUrl: entity.imageUrl,
      isAvailable: entity.isAvailable,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      preparationTime: entity.preparationTime,
      ingredients: entity.ingredients,
      allergens: entity.allergens,
      isFeatured: entity.isFeatured,
      sortOrder: entity.sortOrder,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
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
}
