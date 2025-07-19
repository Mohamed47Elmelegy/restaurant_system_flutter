import '../entities/category_entity.dart';
import '../entities/food_item_entity.dart';
import '../entities/banner_entity.dart';

abstract class HomeRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<List<FoodItemEntity>> getPopularItems();
  Future<List<FoodItemEntity>> getRecommendedItems();
  Future<List<BannerEntity>> getBanners();
}
