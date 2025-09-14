import 'package:dartz/dartz.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/meal_time.dart';
import '../repositories/meal_time_repository.dart';

class UpdateMealTimesOrder {
  final MealTimeRepository _repository;

  const UpdateMealTimesOrder({required MealTimeRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<MealTime>>> call(List<MealTime> mealTimes) async {
    return _repository.updateMealTimesOrder(mealTimes);
  }
}
