import 'package:dio/dio.dart';
import 'dart:developer';
import '../../../../../../../core/error/api_response.dart';
import '../../../../../../../core/error/simple_error.dart';
import '../../../../../../../core/network/api_path.dart';
import '../models/category/main_category_model.dart';
import 'category_remote_data_source.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl(this.dio);

  @override
  Future<ApiResponse<List<MainCategoryModel>>> getCategories({
    int? mealTimeId,
  }) async {
    try {
      log('🔵 Categories Request - URL: ${ApiPath.mealTimes()}');

      final queryParameters = <String, dynamic>{};
      if (mealTimeId != null) {
        queryParameters['meal_time_id'] = mealTimeId;
      }

      final response = await dio.get(
        ApiPath.mealTimes(),
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      log('🟢 Categories Response Status: ${response.statusCode}');
      log('🟢 Categories Response Data: ${response.data}');

      return ApiResponse.fromJson(response.data, (data) {
        final categoriesJson = data as List;
        return categoriesJson
            .map((json) => MainCategoryModel.fromJson(json))
            .toList();
      });
    } on DioException catch (e) {
      log('🔴 Categories DioException: ${e.message}');
      log('🔴 Categories DioException Response: ${e.response?.data}');

      final apiError = ApiError.fromDioException(e);
      return ApiResponse<List<MainCategoryModel>>(
        status: false,
        message: apiError.userMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      log('🔴 Categories Unexpected Error: $e');
      return const ApiResponse<List<MainCategoryModel>>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }
}
