import 'package:dio/dio.dart';
import 'dart:developer';
import '../../../../../../../core/network/dio_client.dart';
import '../../../../../../../core/network/api_path.dart';
import '../../../../../../../core/error/api_response.dart';
import '../../../../../../../core/error/simple_error.dart';
import '../models/meal_time_model.dart';
import 'meal_time_remote_datasource.dart';

class MealTimeRemoteDataSourceImpl implements MealTimeRemoteDataSource {
  final DioClient _dioClient;

  const MealTimeRemoteDataSourceImpl({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
  Future<ApiResponse<List<MealTimeModel>>> getMealTimes({
    bool? isActive,
  }) async {
    try {
      log('🔵 MealTimes Request - URL: ${ApiPath.adminMealTimes()}');

      final queryParameters = <String, dynamic>{};
      if (isActive != null) {
        queryParameters['is_active'] = isActive;
      }

      final response = await _dioClient.dio.get(
        ApiPath.adminMealTimes(),
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      log('🟢 MealTimes Response Status: ${response.statusCode}');
      log('🟢 MealTimes Response Data: ${response.data}');

      return ApiResponse.fromJson(response.data, (data) {
        final mealTimesJson = data as List;
        return mealTimesJson
            .map((json) => MealTimeModel.fromJson(json))
            .toList();
      });
    } on DioException catch (e) {
      log('🔴 MealTimes DioException: ${e.message}');
      log('🔴 MealTimes DioException Response: ${e.response?.data}');

      final apiError = AppError.fromDioException(e);
      return ApiResponse<List<MealTimeModel>>(
        status: false,
        message: apiError.userMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      log('🔴 MealTimes Unexpected Error: $e');
      return const ApiResponse<List<MealTimeModel>>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<MealTimeModel?>> getCurrentMealTime() async {
    try {
      log('🔵 CurrentMealTime Request - URL: ${ApiPath.publicCurrentMealTime()}');

      final response = await _dioClient.dio.get(ApiPath.publicCurrentMealTime());

      log('🟢 CurrentMealTime Response Status: ${response.statusCode}');
      log('🟢 CurrentMealTime Response Data: ${response.data}');

      return ApiResponse.fromJson(
        response.data,
        (data) => data != null ? MealTimeModel.fromJson(data) : null,
      );
    } on DioException catch (e) {
      log('🔴 CurrentMealTime DioException: ${e.message}');
      log('🔴 CurrentMealTime DioException Response: ${e.response?.data}');

      final apiError = AppError.fromDioException(e);
      return ApiResponse<MealTimeModel?>(
        status: false,
        message: apiError.userMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      log('🔴 CurrentMealTime Unexpected Error: $e');
      return const ApiResponse<MealTimeModel?>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<MealTimeModel>> createMealTime(
    MealTimeModel mealTime,
  ) async {
    try {
      log('🔵 CreateMealTime Request - URL: ${ApiPath.adminMealTimes()}');
      log('🔵 CreateMealTime Request Data: ${mealTime.toJson()}');

      final response = await _dioClient.dio.post(
        ApiPath.adminMealTimes(),
        data: mealTime.toJson(),
      );

      log('🟢 CreateMealTime Response Status: ${response.statusCode}');
      log('🟢 CreateMealTime Response Data: ${response.data}');

      return ApiResponse.fromJson(
        response.data,
        (data) => MealTimeModel.fromJson(data),
      );
    } on DioException catch (e) {
      log('🔴 CreateMealTime DioException: ${e.message}');
      log('🔴 CreateMealTime DioException Response: ${e.response?.data}');

      final apiError = AppError.fromDioException(e);
      return ApiResponse<MealTimeModel>(
        status: false,
        message: apiError.userMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      log('🔴 CreateMealTime Unexpected Error: $e');
      return ApiResponse<MealTimeModel>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<MealTimeModel>> updateMealTime(
    MealTimeModel mealTime,
  ) async {
    try {
      log(
        '🔵 UpdateMealTime Request - URL: ${ApiPath.adminMealTime(int.parse(mealTime.id))}',
      );
      log('🔵 UpdateMealTime Request Data: ${mealTime.toJson()}');

      final response = await _dioClient.dio.put(
        ApiPath.adminMealTime(int.parse(mealTime.id)),
        data: mealTime.toJson(),
      );

      log('🟢 UpdateMealTime Response Status: ${response.statusCode}');
      log('🟢 UpdateMealTime Response Data: ${response.data}');

      return ApiResponse.fromJson(
        response.data,
        (data) => MealTimeModel.fromJson(data),
      );
    } on DioException catch (e) {
      log('🔴 UpdateMealTime DioException: ${e.message}');
      log('🔴 UpdateMealTime DioException Response: ${e.response?.data}');

      final apiError = AppError.fromDioException(e);
      return ApiResponse<MealTimeModel>(
        status: false,
        message: apiError.userMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      log('🔴 UpdateMealTime Unexpected Error: $e');
      return ApiResponse<MealTimeModel>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<bool>> deleteMealTime(String id) async {
    try {
      log(
        '🔵 DeleteMealTime Request - URL: ${ApiPath.adminMealTime(int.parse(id))}',
      );

      final response = await _dioClient.dio.delete(
        ApiPath.adminMealTime(int.parse(id)),
      );

      log('🟢 DeleteMealTime Response Status: ${response.statusCode}');
      log('🟢 DeleteMealTime Response Data: ${response.data}');

      return ApiResponse.fromJson(response.data, (data) => true);
    } on DioException catch (e) {
      log('🔴 DeleteMealTime DioException: ${e.message}');
      log('🔴 DeleteMealTime DioException Response: ${e.response?.data}');

      final apiError = AppError.fromDioException(e);
      return ApiResponse<bool>(
        status: false,
        message: apiError.userMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      log('🔴 DeleteMealTime Unexpected Error: $e');
      return const ApiResponse<bool>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<MealTimeModel>> toggleMealTimeStatus(
    String id,
    bool isActive,
  ) async {
    try {
      log(
        '🔵 ToggleMealTimeStatus Request - URL: ${ApiPath.adminMealTimeToggle(int.parse(id))}',
      );
      log('🔵 ToggleMealTimeStatus Request Data: {"is_active": $isActive}');

      final response = await _dioClient.dio.patch(
        ApiPath.adminMealTimeToggle(int.parse(id)),
        data: {'is_active': isActive},
      );

      log('🟢 ToggleMealTimeStatus Response Status: ${response.statusCode}');
      log('🟢 ToggleMealTimeStatus Response Data: ${response.data}');

      return ApiResponse.fromJson(
        response.data,
        (data) => MealTimeModel.fromJson(data),
      );
    } on DioException catch (e) {
      log('🔴 ToggleMealTimeStatus DioException: ${e.message}');
      log('🔴 ToggleMealTimeStatus DioException Response: ${e.response?.data}');

      final apiError = AppError.fromDioException(e);
      return ApiResponse<MealTimeModel>(
        status: false,
        message: apiError.userMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      log('🔴 ToggleMealTimeStatus Unexpected Error: $e');
      return ApiResponse<MealTimeModel>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<List<MealTimeModel>>> updateMealTimesOrder(
    List<MealTimeModel> mealTimes,
  ) async {
    try {
      log(
        '🔵 UpdateMealTimesOrder Request - URL: ${ApiPath.adminMealTimesReorder()}',
      );
      final data = {
        'meal_times': mealTimes
            .map((e) => {'id': e.id, 'sort_order': e.sortOrder})
            .toList(),
      };
      log('🔵 UpdateMealTimesOrder Request Data: $data');

      final response = await _dioClient.dio.post(
            ApiPath.adminMealTimesReorder(),
        data: data,
      );

      log('🟢 UpdateMealTimesOrder Response Status: ${response.statusCode}');
      log('🟢 UpdateMealTimesOrder Response Data: ${response.data}');

      return ApiResponse.fromJson(response.data, (data) {
        final mealTimesJson = data as List;
        return mealTimesJson
            .map((json) => MealTimeModel.fromJson(json))
            .toList();
      });
    } on DioException catch (e) {
      log('🔴 UpdateMealTimesOrder DioException: ${e.message}');
      log('🔴 UpdateMealTimesOrder DioException Response: ${e.response?.data}');

      final apiError = AppError.fromDioException(e);
      return ApiResponse<List<MealTimeModel>>(
        status: false,
        message: apiError.userMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      log('🔴 UpdateMealTimesOrder Unexpected Error: $e');
      return ApiResponse<List<MealTimeModel>>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }
}
