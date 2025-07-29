import 'package:equatable/equatable.dart';

class SubCategory extends Equatable {
  final int id;
  final int mainCategoryId;
  final String name;
  final String nameAr;
  final String? icon;
  final String? description;
  final String? descriptionAr;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? productsCount;

  const SubCategory({
    required this.id,
    required this.mainCategoryId,
    required this.name,
    required this.nameAr,
    this.icon,
    this.description,
    this.descriptionAr,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.productsCount,
  });

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
} 