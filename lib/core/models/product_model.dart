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
    this.mainCategory,
  });

  /// Constructor for creating ProductModel from existing data with int id
  factory ProductModel.fromIntId({
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
    return double.tryParse(price.toString()) ?? 0.0;
  }

  /// Get rating as double
  double get ratingAsDouble {
    return rating ?? 0.0;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    try {
      return ProductModel(
        id: _parseString(json['id']) ?? '',
        name: _parseString(json['name']) ?? '',
        nameAr: _parseString(json['name_ar']),
        description: _parseString(json['description']),
        descriptionAr: _parseString(json['description_ar']),
        price: _parseDouble(json['price'], 0.0),
        mainCategoryId: _parseString(json['main_category_id']) ?? '',
        subCategoryId: _parseString(json['sub_category_id']),
        imageUrl: _parseString(json['image_url']),
        isAvailable: json['is_available'] ?? true,
        rating: _parseDoubleNullable(json['rating']),
        reviewCount: _parseIntNullable(json['review_count']),
        preparationTime: _parseIntNullable(json['preparation_time']),
        ingredients: json['ingredients'] != null
            ? _parseIngredients(json['ingredients'])
            : null,
        allergens: json['allergens'] != null
            ? _parseAllergens(json['allergens'])
            : null,
        isFeatured: json['is_featured'] ?? false,
        sortOrder: _parseIntNullable(json['sort_order']),
        createdAt: _parseDateTimeNullable(json['created_at']),
        updatedAt: _parseDateTimeNullable(json['updated_at']),
        mainCategory: json['main_category'] != null
            ? MainCategoryModel.fromJson(json['main_category'])
            : null,
      );
    } catch (e) {
      throw FormatException('Error parsing ProductModel from JSON: $e');
    }
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
      nameAr: nameAr,
      description: description,
      descriptionAr: descriptionAr,
      price: price,
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
      mainCategory: mainCategory?.toEntity(),
      mainCategoryId: mainCategoryId,
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
      nameAr: entity.nameAr,
      description: entity.description,
      descriptionAr: entity.descriptionAr,
      price: entity.price,
      mainCategoryId: entity.mainCategoryId,
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

  /// Parse ingredients from JSON - handles both String and List formats
  static List<String>? _parseIngredients(dynamic ingredients) {
    if (ingredients == null) return null;

    if (ingredients is List) {
      return List<String>.from(ingredients);
    } else if (ingredients is String) {
      // Split by newlines and filter out empty strings
      return ingredients
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return null;
  }

  /// Parse allergens from JSON - handles both String and List formats
  static List<String>? _parseAllergens(dynamic allergens) {
    if (allergens == null) return null;

    if (allergens is List) {
      return List<String>.from(allergens);
    } else if (allergens is String) {
      // Split by commas and filter out empty strings
      return allergens
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return null;
  }

  /// Safe string parsing with null handling
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString().trim().isEmpty ? null : value.toString().trim();
  }

  /// Safe double parsing with default value
  static double _parseDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    try {
      if (value is num) return value.toDouble();
      return double.parse(value.toString());
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safe double parsing with nullable result
  static double? _parseDoubleNullable(dynamic value) {
    if (value == null) return null;
    try {
      if (value is num) return value.toDouble();
      return double.parse(value.toString());
    } catch (e) {
      return null;
    }
  }

  /// Safe int parsing with nullable result
  static int? _parseIntNullable(dynamic value) {
    if (value == null) return null;
    try {
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.parse(value.toString());
    } catch (e) {
      return null;
    }
  }

  /// Safe DateTime parsing with nullable result
  static DateTime? _parseDateTimeNullable(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return null;
    }
  }
}
