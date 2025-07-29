import '../../../presentation/pages/add_items/domain/entities/category/sub_category.dart';

class SubCategoryModel extends SubCategory {
  const SubCategoryModel({
    required super.id,
    required super.mainCategoryId,
    required super.name,
    required super.nameAr,
    super.icon,
    super.description,
    super.descriptionAr,
    required super.isActive,
    required super.sortOrder,
    required super.createdAt,
    required super.updatedAt,
    super.productsCount,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      mainCategoryId: json['main_category_id'],
      name: json['name'],
      nameAr: json['name_ar'],
      icon: json['icon'],
      description: json['description'],
      descriptionAr: json['description_ar'],
      isActive: json['is_active'],
      sortOrder: json['sort_order'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      productsCount: json['products_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main_category_id': mainCategoryId,
      'name': name,
      'name_ar': nameAr,
      'icon': icon,
      'description': description,
      'description_ar': descriptionAr,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'products_count': productsCount,
    };
  }

  SubCategory toEntity() {
    return SubCategory(
      id: id,
      mainCategoryId: mainCategoryId,
      name: name,
      nameAr: nameAr,
      icon: icon,
      description: description,
      descriptionAr: descriptionAr,
      isActive: isActive,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
      productsCount: productsCount,
    );
  }
}
