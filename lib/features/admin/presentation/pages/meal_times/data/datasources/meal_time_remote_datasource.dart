import '../../../../../../../core/error/api_response.dart';
import '../models/meal_time_model.dart';

abstract class MealTimeRemoteDataSource {
  /// Get all meal times
  ///
  /// [isActive] filter meal times by active status
  Future<ApiResponse<List<MealTimeModel>>> getMealTimes({bool? isActive});

  /// Get current meal time based on current time
  Future<ApiResponse<MealTimeModel?>> getCurrentMealTime();

  /// Create a new meal time
  Future<ApiResponse<MealTimeModel>> createMealTime(MealTimeModel mealTime);

  /// Update an existing meal time
  Future<ApiResponse<MealTimeModel>> updateMealTime(MealTimeModel mealTime);

  /// Delete a meal time by ID
  Future<ApiResponse<bool>> deleteMealTime(String id);

  /// Toggle meal time active status
  Future<ApiResponse<MealTimeModel>> toggleMealTimeStatus(
    String id,
    bool isActive,
  );

  /// Update meal times order
  Future<ApiResponse<List<MealTimeModel>>> updateMealTimesOrder(
    List<MealTimeModel> mealTimes,
  );
}
