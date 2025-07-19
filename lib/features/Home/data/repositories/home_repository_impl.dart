import '../datasources/home_datasource.dart';
import '../models/category_model.dart';
import '../models/food_item_model.dart';
import '../models/banner_model.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/food_item_entity.dart';
import '../../domain/entities/banner_entity.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final data = await _dataSource.getCategories();
      final models = data.map((json) => CategoryModel.fromJson(json)).toList();
      return models
          .map(
            (model) => CategoryEntity(
              id: model.id,
              name: model.name,
              icon: model.icon,
              color: model.color,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  @override
  Future<List<FoodItemEntity>> getPopularItems() async {
    try {
      final data = await _dataSource.getPopularItems();
      final models = data.map((json) => FoodItemModel.fromJson(json)).toList();
      return models
          .map(
            (model) => FoodItemEntity(
              id: model.id,
              name: model.name,
              description: model.description,
              price: model.price,
              rating: model.rating,
              image: model.image,
              category: model.category,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load popular items: $e');
    }
  }

  @override
  Future<List<FoodItemEntity>> getRecommendedItems() async {
    try {
      final data = await _dataSource.getRecommendedItems();
      final models = data.map((json) => FoodItemModel.fromJson(json)).toList();
      return models
          .map(
            (model) => FoodItemEntity(
              id: model.id,
              name: model.name,
              description: model.description,
              price: model.price,
              rating: model.rating,
              image: model.image,
              category: model.category,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load recommended items: $e');
    }
  }

  @override
  Future<List<BannerEntity>> getBanners() async {
    try {
      final data = await _dataSource.getBanners();
      final models = data.map((json) => BannerModel.fromJson(json)).toList();
      return models
          .map(
            (model) => BannerEntity(
              id: model.id,
              title: model.title,
              subtitle: model.subtitle,
              image: model.image,
              action: model.action,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load banners: $e');
    }
  }
}
