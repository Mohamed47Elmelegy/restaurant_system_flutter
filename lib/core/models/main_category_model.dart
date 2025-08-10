import '../entities/main_category.dart';
import '../base/base_model.dart';

/// 🟦 MainCategoryModel - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحويل البيانات فقط
class MainCategoryModel extends BaseModel<CategoryEntity> {
  final String id;
  final String name;
  final String? icon;
  final String? color;
  final String? description;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? productsCount;

  MainCategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    this.description,
    required this.isActive,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
    this.productsCount,
  });

  /// Constructor for creating MainCategoryModel from existing data with int id
  factory MainCategoryModel.fromIntId({
    int? id,
    required String name,
    String? icon,
    String? color,
    String? description,
    required bool isActive,
    required int sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? productsCount,
  }) {
    return MainCategoryModel(
      id: id?.toString() ?? '',
      name: name,
      icon: icon,
      color: color,
      description: description,
      isActive: isActive,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
      productsCount: productsCount,
    );
  }

  /// Get int id for backward compatibility
  int? get intId {
    return int.tryParse(id);
  }

  /// Factory method to create MainCategoryModel from MainCategory entity
  factory MainCategoryModel.fromEntity(CategoryEntity entity) {
    return MainCategoryModel(
      id: entity.id,
      name: entity.name,

      icon: entity.icon,
      color: entity.color,
      description: entity.description,

      isActive: entity.isActive,
      sortOrder: entity.sortOrder,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      productsCount: entity.productsCount,
    );
  }

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'],

      icon: json['icon'],
      color: json['color'],
      description: json['description'],

      isActive: json['is_active'],
      sortOrder: json['sort_order'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      productsCount: json['products_count'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,

      'is_active': isActive,
      'sort_order': sortOrder,
    };

    // Only add non-null optional fields
    if (icon != null) data['icon'] = icon;
    if (color != null) data['color'] = color;
    if (description != null && description!.isNotEmpty)
      data['description'] = description;

    // Only add ID if it's not empty (for updates)
    if (id.isNotEmpty) data['id'] = id;

    // Only add timestamps if they exist (for updates)
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    // Only add counts if they exist (for responses)
    if (productsCount != null) data['products_count'] = productsCount;

    return data;
  }

  @override
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      icon: icon,
      color: color,
      description: description,
      isActive: isActive,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
      productsCount: productsCount,
    );
  }

  @override
  MainCategoryModel copyWith(Map<String, dynamic> changes) {
    return MainCategoryModel(
      id: changes['id'] ?? id,
      name: changes['name'] ?? name,

      icon: changes['icon'] ?? icon,
      color: changes['color'] ?? color,
      description: changes['description'] ?? description,

      isActive: changes['isActive'] ?? isActive,
      sortOrder: changes['sortOrder'] ?? sortOrder,
      createdAt: changes['createdAt'] ?? createdAt,
      updatedAt: changes['updatedAt'] ?? updatedAt,
      productsCount: changes['productsCount'] ?? productsCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MainCategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MainCategoryModel(id: $id, name: $name, isActive: $isActive)';
  }
}
