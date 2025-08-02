import 'package:equatable/equatable.dart';
import '../../../../add_category/domain/entities/main_category.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoriesLoaded extends CategoryState {
  final List<MainCategory> categories;
  final int? mealTimeId;

  const CategoriesLoaded({required this.categories, this.mealTimeId});

  @override
  List<Object?> get props => [categories, mealTimeId];
}

class CategoryError extends CategoryState {
  final String message;
  final String? errorCode;

  const CategoryError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}
