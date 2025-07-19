import '../entities/food_item_entity.dart';
import '../repositories/home_repository.dart';

class GetPopularItemsUseCase {
  final HomeRepository _repository;

  GetPopularItemsUseCase(this._repository);

  Future<List<FoodItemEntity>> call() async {
    return await _repository.getPopularItems();
  }
}
