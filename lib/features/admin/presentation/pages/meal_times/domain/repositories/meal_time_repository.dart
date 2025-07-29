import 'package:dartz/dartz.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/meal_time.dart';

abstract class MealTimeRepository {
  Future<Either<Failure, List<MealTime>>> getMealTimes({bool? isActive});
  Future<Either<Failure, MealTime>> createMealTime(MealTime mealTime);
  Future<Either<Failure, MealTime>> updateMealTime(MealTime mealTime);
  Future<Either<Failure, bool>> deleteMealTime(String id);
  Future<Either<Failure, MealTime>> toggleMealTimeStatus(
    String id,
    bool isActive,
  );
  Future<Either<Failure, List<MealTime>>> updateMealTimesOrder(
    List<MealTime> mealTimes,
  );
}
