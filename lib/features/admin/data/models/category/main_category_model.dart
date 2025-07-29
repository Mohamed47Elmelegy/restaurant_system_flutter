import '../../../presentation/pages/add_items/domain/entities/category/main_category.dart';
import 'sub_category_model.dart';

class MainCategoryModel extends MainCategory {
  const MainCategoryModel({
    required super.id,
    required super.name,
    required super.nameAr,
    super.icon,
    super.color,
    super.description,
    super.descriptionAr,
    required super.isActive,
    required super.sortOrder,
    required super.createdAt,
    required super.updatedAt,
    super.productsCount,
    super.subCategoriesCount,
    super.subCategories,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      id: json['id'],
      name: json['name'],
      nameAr: json['name_ar'],
      icon: json['icon'],
      color: json['color'],
      description: json['description'],
      descriptionAr: json['description_ar'],
      isActive: json['is_active'],
      sortOrder: json['sort_order'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      productsCount: json['products_count'],
      subCategoriesCount: json['sub_categories_count'],
      subCategories: json['sub_categories'] != null
          ? (json['sub_categories'] as List)
                .map((i) => SubCategoryModel.fromJson(i))
                .toList()
          : null,
    );
  }

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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'products_count': productsCount,
      'sub_categories_count': subCategoriesCount,
      'sub_categories': subCategories
          ?.map((e) => (e as SubCategoryModel).toJson())
          .toList(),
    };
  }

  MainCategory toEntity() {
    return MainCategory(
      id: id,
      name: name,
      nameAr: nameAr,
      icon: icon,
      color: color,
      description: description,
      descriptionAr: descriptionAr,
      isActive: isActive,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
      productsCount: productsCount,
      subCategoriesCount: subCategoriesCount,
      subCategories: subCategories?.map((e) => e).toList(),
    );
  }
}
