import 'package:equatable/equatable.dart';
import '../../../../meal_times/domain/entities/meal_time.dart';
import 'sub_category.dart';

class MainCategory extends Equatable {
  final int id;
  final String name;
  final String nameAr;
  final String? icon;
  final String? color;
  final String? description;
  final String? descriptionAr;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? productsCount;
  final int? subCategoriesCount;
  final List<SubCategory>? subCategories;
  final List<MealTime>? mealTimes;

  const MainCategory({
    required this.id,
    required this.name,
    required this.nameAr,
    this.icon,
    this.color,
    this.description,
    this.descriptionAr,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.productsCount,
    this.subCategoriesCount,
    this.subCategories,
    this.mealTimes,
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
    name,
    nameAr,
    icon,
    color,
    description,
    descriptionAr,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
    productsCount,
    subCategoriesCount,
    subCategories,
    mealTimes,
  ];
}
