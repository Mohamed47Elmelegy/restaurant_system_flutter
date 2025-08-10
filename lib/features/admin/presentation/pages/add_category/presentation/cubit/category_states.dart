import 'package:equatable/equatable.dart';
import '../../../../../../../core/entities/main_category.dart';

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
  final List<CategoryEntity> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// Category created successfully
class CategoryCreated extends CategoryState {
  final CategoryEntity category;

  const CategoryCreated(this.category);

  @override
  List<Object?> get props => [category];
}

/// Category updated successfully
class CategoryUpdated extends CategoryState {
  final CategoryEntity category;

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
  final CategoryEntity category;

  const CategoryLoaded(this.category);

  @override
  List<Object?> get props => [category];
}

/// Categories searched successfully
class CategoriesSearched extends CategoryState {
  final List<CategoryEntity> categories;

  const CategoriesSearched(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// Active categories loaded
class ActiveCategoriesLoaded extends CategoryState {
  final List<CategoryEntity> categories;

  const ActiveCategoriesLoaded(this.categories);

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
