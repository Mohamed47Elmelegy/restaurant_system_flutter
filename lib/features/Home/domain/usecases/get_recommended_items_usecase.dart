import '../entities/food_item_entity.dart';
import '../repositories/home_repository.dart';

class GetRecommendedItemsUseCase {
  final HomeRepository _repository;

  GetRecommendedItemsUseCase(this._repository);

  Future<List<FoodItemEntity>> call() async {
    return await _repository.getRecommendedItems();
  }
}
