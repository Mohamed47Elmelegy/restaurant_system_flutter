import 'package:equatable/equatable.dart';
import '../../../../core/entities/main_category.dart';
import '../../../../core/entities/product.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategoryEntity> categories;
  final List<ProductEntity> popularItems;
  final List<ProductEntity> recommendedItems;
  final int? selectedCategoryId;

  const HomeLoaded({
    required this.categories,
    required this.popularItems,
    required this.recommendedItems,
    this.selectedCategoryId,
  });

  @override
  List<Object?> get props => [
    categories,
    popularItems,
    recommendedItems,
    selectedCategoryId,
  ];

  HomeLoaded copyWith({
    List<CategoryEntity>? categories,
    List<ProductEntity>? popularItems,
    List<ProductEntity>? recommendedItems,
    int? selectedCategoryId,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      popularItems: popularItems ?? this.popularItems,
      recommendedItems: recommendedItems ?? this.recommendedItems,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
