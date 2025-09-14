import 'package:dartz/dartz.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/meal_time.dart';
import '../repositories/meal_time_repository.dart';

class CreateMealTime {
  final MealTimeRepository _repository;

  const CreateMealTime({required MealTimeRepository repository})
    : _repository = repository;

  Future<Either<Failure, MealTime>> call(MealTime mealTime) async {
    return _repository.createMealTime(mealTime);
  }
}
