import 'package:dartz/dartz.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/meal_time.dart';
import '../repositories/meal_time_repository.dart';

class ToggleMealTimeParams {
  final String id;
  final bool isActive;

  const ToggleMealTimeParams({required this.id, required this.isActive});
}

class ToggleMealTimeStatus {
  final MealTimeRepository _repository;

  const ToggleMealTimeStatus({required MealTimeRepository repository})
    : _repository = repository;

  Future<Either<Failure, MealTime>> call(ToggleMealTimeParams params) async {
    return await _repository.toggleMealTimeStatus(params.id, params.isActive);
  }
}
