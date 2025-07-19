import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/food_item_entity.dart';
import '../../domain/entities/banner_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategoryEntity> categories;
  final List<FoodItemEntity> popularItems;
  final List<FoodItemEntity> recommendedItems;
  final List<BannerEntity> banners;
  final int? selectedCategoryId;

  const HomeLoaded({
    required this.categories,
    required this.popularItems,
    required this.recommendedItems,
    required this.banners,
    this.selectedCategoryId,
  });

  @override
  List<Object?> get props => [
    categories,
    popularItems,
    recommendedItems,
    banners,
    selectedCategoryId,
  ];

  HomeLoaded copyWith({
    List<CategoryEntity>? categories,
    List<FoodItemEntity>? popularItems,
    List<FoodItemEntity>? recommendedItems,
    List<BannerEntity>? banners,
    int? selectedCategoryId,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      popularItems: popularItems ?? this.popularItems,
      recommendedItems: recommendedItems ?? this.recommendedItems,
      banners: banners ?? this.banners,
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
