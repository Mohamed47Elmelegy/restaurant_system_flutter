import 'package:dartz/dartz.dart';
import '../../../../../../../core/error/failures.dart';
import '../repositories/meal_time_repository.dart';

class DeleteMealTime {
  final MealTimeRepository _repository;

  const DeleteMealTime({required MealTimeRepository repository})
    : _repository = repository;

  Future<Either<Failure, bool>> call(String id) async {
    return await _repository.deleteMealTime(id);
  }
}
