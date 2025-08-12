import '../base/base_model.dart';
import '../entities/main_category.dart';

class MainCategoryModel extends BaseModel<CategoryEntity> {
  final String id;
  final String name;
  final String? nameAr;
  final String? icon;
  final String? color;
  final String? description;
  final String? descriptionAr;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? productsCount;

  MainCategoryModel({
    required this.id,
    required this.name,
    this.nameAr,
    this.icon,
    this.color,
    this.description,
    this.descriptionAr,
    required this.isActive,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
    this.productsCount,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'],
      nameAr: json['name_ar'],
      icon: json['icon'],
      color: json['color'],
      description: json['description'],
      descriptionAr: json['description_ar'],
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
  BaseModel<CategoryEntity> copyWith(Map<String, dynamic> changes) {
    return MainCategoryModel(
      id: changes['id'] ?? id,
      name: changes['name'] ?? name,
      nameAr: changes['nameAr'] ?? nameAr,
      icon: changes['icon'] ?? icon,
      color: changes['color'] ?? color,
      description: changes['description'] ?? description,
      descriptionAr: changes['descriptionAr'] ?? descriptionAr,
      isActive: changes['isActive'] ?? isActive,
      sortOrder: changes['sortOrder'] ?? sortOrder,
      createdAt: changes['createdAt'] ?? createdAt,
      updatedAt: changes['updatedAt'] ?? updatedAt,
      productsCount: changes['productsCount'] ?? productsCount,
    );
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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'icon': icon,
      'color': color,
      'description': description,
      'description_ar': descriptionAr,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'products_count': productsCount,
    };
  }

  static MainCategoryModel fromEntity(CategoryEntity entity) {
    return MainCategoryModel(
      id: entity.id,
      name: entity.name,
      nameAr: entity.nameAr, // هذا الحقل كان مفقود
      icon: entity.icon,
      color: entity.color,
      description: entity.description,
      descriptionAr: entity.descriptionAr, // هذا الحقل كان مفقود أيضاً
      isActive: entity.isActive,
      sortOrder: entity.sortOrder,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      productsCount: entity.productsCount,
    );
  }
}
