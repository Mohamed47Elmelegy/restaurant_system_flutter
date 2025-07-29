import 'package:dartz/dartz.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/meal_time.dart';
import '../repositories/meal_time_repository.dart';

class GetMealTimes {
  final MealTimeRepository _repository;

  const GetMealTimes({required MealTimeRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<MealTime>>> call({bool? isActive}) async {
    return await _repository.getMealTimes(isActive: isActive);
  }
}
