import 'package:equatable/equatable.dart';
import '../../../../../../../core/base/base_entity.dart';

/// 🟦 SubCategory Entity - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل فئة فرعية في الأعمال فقط
class SubCategory extends BaseEntity {
  final int mainCategoryId;
  final String name;
  final String nameAr;
  final String? icon;
  final String? description;
  final String? descriptionAr;
  final bool isActive;
  final int sortOrder;
  final int? productsCount;

  const SubCategory({
    required super.id,
    required this.mainCategoryId,
    required this.name,
    required this.nameAr,
    this.icon,
    this.description,
    this.descriptionAr,
    required this.isActive,
    required this.sortOrder,
    super.createdAt,
    super.updatedAt,
    this.productsCount,
  });

  /// Constructor for creating SubCategory from existing data with int id
  factory SubCategory.fromIntId({
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
    return SubCategory(
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

  /// Get display name based on current locale
  String getDisplayName({bool isArabic = true}) {
    return isArabic ? nameAr : name;
  }

  /// Get description based on current locale
  String? getDescription({bool isArabic = true}) {
    return isArabic ? descriptionAr : description;
  }

  @override
  List<Object?> get props => [
    id,
    mainCategoryId,
    name,
    nameAr,
    icon,
    description,
    descriptionAr,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
    productsCount,
  ];

  @override
  SubCategory copyWith({
    String? id,
    int? mainCategoryId,
    String? name,
    String? nameAr,
    String? icon,
    String? description,
    String? descriptionAr,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? productsCount,
  }) {
    return SubCategory(
      id: id ?? this.id,
      mainCategoryId: mainCategoryId ?? this.mainCategoryId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      productsCount: productsCount ?? this.productsCount,
    );
  }

  @override
  Map<String, dynamic> toMap() {
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
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'products_count': productsCount,
    };
  }

  @override
  bool get isValid {
    return name.isNotEmpty &&
        nameAr.isNotEmpty &&
        mainCategoryId > 0 &&
        sortOrder >= 0;
  }
}
