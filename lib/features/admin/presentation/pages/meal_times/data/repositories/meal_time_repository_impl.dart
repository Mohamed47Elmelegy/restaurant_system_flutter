import 'package:dartz/dartz.dart';
import '../../../../../../../core/error/failures.dart';
import '../../domain/entities/meal_time.dart';
import '../../domain/repositories/meal_time_repository.dart';
import '../datasources/meal_time_remote_datasource.dart';
import '../models/meal_time_model.dart';

class MealTimeRepositoryImpl implements MealTimeRepository {
  final MealTimeRemoteDataSource _remoteDataSource;

  const MealTimeRepositoryImpl({
    required MealTimeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<MealTime>>> getMealTimes({bool? isActive}) async {
    try {
      final response = await _remoteDataSource.getMealTimes(isActive: isActive);
      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MealTime>> createMealTime(MealTime mealTime) async {
    try {
      final model = MealTimeModel.fromEntity(mealTime);
      final response = await _remoteDataSource.createMealTime(model);
      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MealTime>> updateMealTime(MealTime mealTime) async {
    try {
      final model = MealTimeModel.fromEntity(mealTime);
      final response = await _remoteDataSource.updateMealTime(model);
      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMealTime(String id) async {
    try {
      final response = await _remoteDataSource.deleteMealTime(id);
      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MealTime>> toggleMealTimeStatus(
    String id,
    bool isActive,
  ) async {
    try {
      final response = await _remoteDataSource.toggleMealTimeStatus(
        id,
        isActive,
      );
      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MealTime>>> updateMealTimesOrder(
    List<MealTime> mealTimes,
  ) async {
    try {
      final models = mealTimes.map((e) => MealTimeModel.fromEntity(e)).toList();
      final response = await _remoteDataSource.updateMealTimesOrder(models);
      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
