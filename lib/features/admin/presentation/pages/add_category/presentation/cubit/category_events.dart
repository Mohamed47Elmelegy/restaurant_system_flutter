import 'package:equatable/equatable.dart';
import '../../domain/entities/main_category.dart';

/// 🟦 CategoryEvents - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن أحداث إدارة الفئات فقط
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

/// Load all categories
class LoadCategories extends CategoryEvent {
  final int? mealTimeId;

  const LoadCategories({this.mealTimeId});

  @override
  List<Object?> get props => [mealTimeId];
}

/// Create new category
class CreateCategory extends CategoryEvent {
  final MainCategory category;

  const CreateCategory(this.category);

  @override
  List<Object?> get props => [category];
}

/// Update existing category
class UpdateCategory extends CategoryEvent {
  final MainCategory category;

  const UpdateCategory(this.category);

  @override
  List<Object?> get props => [category];
}

/// Delete category
class DeleteCategory extends CategoryEvent {
  final String categoryId;

  const DeleteCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// Get category by ID
class GetCategoryById extends CategoryEvent {
  final int categoryId;

  const GetCategoryById(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// Search categories
class SearchCategories extends CategoryEvent {
  final String query;

  const SearchCategories(this.query);

  @override
  List<Object?> get props => [query];
}

/// Get active categories
class GetActiveCategories extends CategoryEvent {
  const GetActiveCategories();
}
