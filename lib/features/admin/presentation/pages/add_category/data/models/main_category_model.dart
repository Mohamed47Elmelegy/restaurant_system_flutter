import '../../domain/entities/main_category.dart';
import '../../../../../../../core/base/base_model.dart';
import 'sub_category_model.dart';

/// 🟦 MainCategoryModel - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحويل البيانات فقط
class MainCategoryModel extends BaseModel<MainCategory> {
  final String id;
  final String name;
  final String nameAr;
  final String? icon;
  final String? color;
  final String? description;
  final String? descriptionAr;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? productsCount;
  final int? subCategoriesCount;
  final List<SubCategoryModel>? subCategories;

  MainCategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    this.icon,
    this.color,
    this.description,
    this.descriptionAr,
    required this.isActive,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
    this.productsCount,
    this.subCategoriesCount,
    this.subCategories,
  });

  /// Constructor for creating MainCategoryModel from existing data with int id
  factory MainCategoryModel.fromIntId({
    int? id,
    required String name,
    required String nameAr,
    String? icon,
    String? color,
    String? description,
    String? descriptionAr,
    required bool isActive,
    required int sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? productsCount,
    int? subCategoriesCount,
    List<SubCategoryModel>? subCategories,
  }) {
    return MainCategoryModel(
      id: id?.toString() ?? '',
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
      subCategories: subCategories,
    );
  }

  /// Get int id for backward compatibility
  int? get intId {
    return int.tryParse(id);
  }

  /// Factory method to create MainCategoryModel from MainCategory entity
  factory MainCategoryModel.fromEntity(MainCategory entity) {
    return MainCategoryModel(
      id: entity.id,
      name: entity.name,
      nameAr: entity.nameAr,
      icon: entity.icon,
      color: entity.color,
      description: entity.description,
      descriptionAr: entity.descriptionAr,
      isActive: entity.isActive,
      sortOrder: entity.sortOrder,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      productsCount: entity.productsCount,
      subCategoriesCount: entity.subCategoriesCount,
      subCategories: entity.subCategories
          ?.map((e) => SubCategoryModel.fromEntity(e))
          .toList(),
    );
  }

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
      subCategoriesCount: json['sub_categories_count'],
      subCategories: json['sub_categories'] != null
          ? (json['sub_categories'] as List)
                .map((i) => SubCategoryModel.fromJson(i))
                .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'name_ar': nameAr,
      'is_active': isActive,
      'sort_order': sortOrder,
    };

    // Only add non-null optional fields
    if (icon != null) data['icon'] = icon;
    if (color != null) data['color'] = color;
    if (description != null && description!.isNotEmpty)
      data['description'] = description;
    if (descriptionAr != null && descriptionAr!.isNotEmpty)
      data['description_ar'] = descriptionAr;

    // Only add ID if it's not empty (for updates)
    if (id.isNotEmpty) data['id'] = id;

    // Only add timestamps if they exist (for updates)
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    // Only add counts if they exist (for responses)
    if (productsCount != null) data['products_count'] = productsCount;
    if (subCategoriesCount != null)
      data['sub_categories_count'] = subCategoriesCount;

    // Only add sub-categories if they exist (for responses)
    if (subCategories != null && subCategories!.isNotEmpty) {
      data['sub_categories'] = subCategories!.map((e) => e.toJson()).toList();
    }

    return data;
  }

  @override
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
      subCategories: subCategories?.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  MainCategoryModel copyWith(Map<String, dynamic> changes) {
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
      subCategoriesCount: changes['subCategoriesCount'] ?? subCategoriesCount,
      subCategories: changes['subCategories'] ?? subCategories,
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
    return 'MainCategoryModel(id: $id, name: $name, nameAr: $nameAr, isActive: $isActive)';
  }
}
