import 'package:equatable/equatable.dart';
import '../../domain/entities/main_category.dart';
import '../../domain/entities/sub_category.dart';

/// 🟦 CategoryStates - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن حالات إدارة الفئات فقط
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

/// Loading state
class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

/// Categories loaded successfully
class CategoriesLoaded extends CategoryState {
  final List<MainCategory> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// Category created successfully
class CategoryCreated extends CategoryState {
  final MainCategory category;

  const CategoryCreated(this.category);

  @override
  List<Object?> get props => [category];
}

/// Category updated successfully
class CategoryUpdated extends CategoryState {
  final MainCategory category;

  const CategoryUpdated(this.category);

  @override
  List<Object?> get props => [category];
}

/// Category deleted successfully
class CategoryDeleted extends CategoryState {
  final String categoryId;

  const CategoryDeleted(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// Category loaded successfully
class CategoryLoaded extends CategoryState {
  final MainCategory category;

  const CategoryLoaded(this.category);

  @override
  List<Object?> get props => [category];
}

/// Categories searched successfully
class CategoriesSearched extends CategoryState {
  final List<MainCategory> categories;

  const CategoriesSearched(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// Active categories loaded
class ActiveCategoriesLoaded extends CategoryState {
  final List<MainCategory> categories;

  const ActiveCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// Categories with subcategories loaded
class CategoriesWithSubCategoriesLoaded extends CategoryState {
  final List<MainCategory> categories;

  const CategoriesWithSubCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// Authentication error
class CategoryAuthError extends CategoryState {
  final String message;

  const CategoryAuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// General error
class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// ==================== SUB-CATEGORIES STATES ====================

/// Sub-categories loaded successfully
class SubCategoriesLoaded extends CategoryState {
  final List<SubCategory> subCategories;

  const SubCategoriesLoaded(this.subCategories);

  @override
  List<Object?> get props => [subCategories];
}

/// Sub-category created successfully
class SubCategoryCreated extends CategoryState {
  final SubCategory subCategory;

  const SubCategoryCreated(this.subCategory);

  @override
  List<Object?> get props => [subCategory];
}

/// Sub-category updated successfully
class SubCategoryUpdated extends CategoryState {
  final SubCategory subCategory;

  const SubCategoryUpdated(this.subCategory);

  @override
  List<Object?> get props => [subCategory];
}

/// Sub-category deleted successfully
class SubCategoryDeleted extends CategoryState {
  final int categoryId;
  final int subCategoryId;

  const SubCategoryDeleted(this.categoryId, this.subCategoryId);

  @override
  List<Object?> get props => [categoryId, subCategoryId];
}
