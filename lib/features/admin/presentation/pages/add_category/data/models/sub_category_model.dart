import '../../domain/entities/sub_category.dart';
import '../../../../../../../core/base/base_model.dart';

/// 🟦 SubCategoryModel - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحويل البيانات فقط
class SubCategoryModel extends BaseModel<SubCategory> {
  final String id;
  final int mainCategoryId;
  final String name;
  final String nameAr;
  final String? icon;
  final String? description;
  final String? descriptionAr;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? productsCount;

  SubCategoryModel({
    required this.id,
    required this.mainCategoryId,
    required this.name,
    required this.nameAr,
    this.icon,
    this.description,
    this.descriptionAr,
    required this.isActive,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
    this.productsCount,
  });

  /// Constructor for creating SubCategoryModel from existing data with int id
  factory SubCategoryModel.fromIntId({
    int? id,
    required int mainCategoryId,
    required String name,
    required String nameAr,
    String? icon,
    String? description,
    String? descriptionAr,
    required bool isActive,
    required int sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? productsCount,
  }) {
    return SubCategoryModel(
      id: id?.toString() ?? '',
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

  /// Get int id for backward compatibility
  int? get intId {
    return int.tryParse(id);
  }

  /// Factory method to create SubCategoryModel from SubCategory entity
  factory SubCategoryModel.fromEntity(SubCategory entity) {
    return SubCategoryModel(
      id: entity.id,
      mainCategoryId: entity.mainCategoryId,
      name: entity.name,
      nameAr: entity.nameAr,
      icon: entity.icon,
      description: entity.description,
      descriptionAr: entity.descriptionAr,
      isActive: entity.isActive,
      sortOrder: entity.sortOrder,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      productsCount: entity.productsCount,
    );
  }

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id']?.toString() ?? '',
      mainCategoryId: json['main_category_id'] is int
          ? json['main_category_id']
          : int.tryParse(json['main_category_id'].toString()) ?? 0,
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      icon: json['icon'],
      description: json['description'],
      descriptionAr: json['description_ar'],
      isActive: json['is_active'] ?? true,
      sortOrder: json['sort_order'] ?? 0,
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
    return {
      if (id.isNotEmpty) 'id': id,
      'main_category_id': mainCategoryId,
      'name': name,
      'name_ar': nameAr,
      'icon': icon,
      'description': description,
      'description_ar': descriptionAr,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'products_count': productsCount,
    };
  }

  @override
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

  @override
  SubCategoryModel copyWith(Map<String, dynamic> changes) {
    return SubCategoryModel(
      id: changes['id'] ?? id,
      mainCategoryId: changes['mainCategoryId'] ?? mainCategoryId,
      name: changes['name'] ?? name,
      nameAr: changes['nameAr'] ?? nameAr,
      icon: changes['icon'] ?? icon,
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubCategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SubCategoryModel(id: $id, name: $name, nameAr: $nameAr, isActive: $isActive)';
  }
}
