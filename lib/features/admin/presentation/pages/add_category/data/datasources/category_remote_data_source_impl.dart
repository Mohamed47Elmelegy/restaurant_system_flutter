import 'package:dio/dio.dart';
import 'dart:developer';
import '../../../../../../../core/error/api_response.dart';
import '../../../../../../../core/network/api_path.dart';
import '../../../../../../../core/models/main_category_model.dart';
import 'category_remote_data_source.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl(this.dio);

  @override
  Future<ApiResponse<List<MainCategoryModel>>> getCategories({
    int? mealTimeId,
  }) async {
    try {
      log('🔵 Categories Request - URL: ${ApiPath.menuCategories()}');

      final queryParameters = <String, dynamic>{};
      if (mealTimeId != null) {
        queryParameters['meal_time_id'] = mealTimeId;
      }

      final response = await dio.get(
        ApiPath.menuCategories(),
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
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('🔴 Categories Unexpected Error: $e');
      return const ApiResponse<List<MainCategoryModel>>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<MainCategoryModel>> createCategory(
    MainCategoryModel category,
  ) async {
    try {
      log(
        '🔄 CategoryRemoteDataSourceImpl: Creating category - ${category.name}',
      );

      final requestData = category.toJson();
      log('📤 CategoryRemoteDataSourceImpl: Request data - $requestData');

      final response = await dio.post(
        ApiPath.adminCategories(),
        data: requestData,
      );

      log('✅ CategoryRemoteDataSourceImpl: Category created successfully');
      return ApiResponse.success(
        MainCategoryModel.fromJson(response.data['data']),
      );
    } on DioException catch (e) {
      log('❌ CategoryRemoteDataSourceImpl: DioException - ${e.type}');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ CategoryRemoteDataSourceImpl: Unexpected error - $e');
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  @override
  Future<ApiResponse<bool>> deleteCategory(int id) async {
    try {
      log('🔄 CategoryRemoteDataSourceImpl: Deleting category - $id');

      await dio.delete('${ApiPath.adminCategories()}/$id');

      log('✅ CategoryRemoteDataSourceImpl: Category deleted successfully');
      return ApiResponse.success(true);
    } on DioException catch (e) {
      log('❌ CategoryRemoteDataSourceImpl: Failed to delete category - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ CategoryRemoteDataSourceImpl: Failed to delete category - $e');
      return ApiResponse.error('Failed to delete category: $e');
    }
  }

  @override
  Future<ApiResponse<List<MainCategoryModel>>> getCategoriesByMealTime(
    int mealTimeId,
  ) async {
    try {
      log(
        '🔵 Categories by Meal Time Request - URL: ${ApiPath.publicMealTimeCategories(mealTimeId)}',
      );

      final response = await dio.get(
        ApiPath.publicMealTimeCategories(mealTimeId),
        queryParameters: {'meal_time_id': mealTimeId},
      );

      log('🟢 Categories by Meal Time Response Status: ${response.statusCode}');

      return ApiResponse.fromJson(response.data, (data) {
        final categoriesJson = data as List;
        return categoriesJson
            .map((json) => MainCategoryModel.fromJson(json))
            .toList();
      });
    } on DioException catch (e) {
      log('🔴 Categories by Meal Time DioException: ${e.message}');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('🔴 Categories by Meal Time Unexpected Error: $e');
      return const ApiResponse<List<MainCategoryModel>>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<List<MainCategoryModel>>> getActiveCategories() async {
    try {
      log('🔵 Active Categories Request - URL: ${ApiPath.publicCategories()}');

      final response = await dio.get(
        ApiPath.publicCategories(),
        queryParameters: {'is_active': true},
      );

      log('🟢 Active Categories Response Status: ${response.statusCode}');

      return ApiResponse.fromJson(response.data, (data) {
        final categoriesJson = data as List;
        return categoriesJson
            .map((json) => MainCategoryModel.fromJson(json))
            .toList();
      });
    } on DioException catch (e) {
      log('🔴 Active Categories DioException: ${e.message}');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('🔴 Active Categories Unexpected Error: $e');
      return const ApiResponse<List<MainCategoryModel>>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<MainCategoryModel?>> getCategoryByName(String name) async {
    try {
      log('🔵 Category by Name Request - URL: ${ApiPath.adminCategories()}');

      final response = await dio.get(
        ApiPath.adminCategories(),
        queryParameters: {'name': name},
      );

      log('🟢 Category by Name Response Status: ${response.statusCode}');

      return ApiResponse.fromJson(response.data, (data) {
        if (data == null) return null;
        return MainCategoryModel.fromJson(data);
      });
    } on DioException catch (e) {
      log('🔴 Category by Name DioException: ${e.message}');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('🔴 Category by Name Unexpected Error: $e');
      return const ApiResponse<MainCategoryModel?>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<MainCategoryModel?>> getCategoryById(int id) async {
    try {
      log('🔵 Category by ID Request - URL: ${ApiPath.adminCategory(id)}');

      final response = await dio.get(ApiPath.adminCategory(id));

      log('🟢 Category by ID Response Status: ${response.statusCode}');

      return ApiResponse.fromJson(response.data, (data) {
        if (data == null) return null;
        return MainCategoryModel.fromJson(data);
      });
    } on DioException catch (e) {
      log('🔴 Category by ID DioException: ${e.message}');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('🔴 Category by ID Unexpected Error: $e');
      return const ApiResponse<MainCategoryModel?>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<List<MainCategoryModel>>> searchCategories(
    String query,
  ) async {
    try {
      log('🔵 Search Categories Request - URL: ${ApiPath.adminCategories()}');

      final response = await dio.get(
        ApiPath.adminCategories(),
        queryParameters: {'search': query},
      );

      log('🟢 Search Categories Response Status: ${response.statusCode}');

      return ApiResponse.fromJson(response.data, (data) {
        final categoriesJson = data as List;
        return categoriesJson
            .map((json) => MainCategoryModel.fromJson(json))
            .toList();
      });
    } on DioException catch (e) {
      log('🔴 Search Categories DioException: ${e.message}');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('🔴 Search Categories Unexpected Error: $e');
      return const ApiResponse<List<MainCategoryModel>>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<List<MainCategoryModel>>> getCategoriesPaginated({
    int page = 1,
    int limit = 10,
    String? sortBy,
    bool ascending = true,
  }) async {
    try {
      log(
        '🔵 Paginated Categories Request - URL: ${ApiPath.adminCategories()}',
      );

      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
        'sort_direction': ascending ? 'asc' : 'desc',
      };

      if (sortBy != null) {
        queryParameters['sort_by'] = sortBy;
      }

      final response = await dio.get(
        ApiPath.adminCategories(),
        queryParameters: queryParameters,
      );

      log('🟢 Paginated Categories Response Status: ${response.statusCode}');

      return ApiResponse.fromJson(response.data, (data) {
        final categoriesJson = data as List;
        return categoriesJson
            .map((json) => MainCategoryModel.fromJson(json))
            .toList();
      });
    } on DioException catch (e) {
      log('🔴 Paginated Categories DioException: ${e.message}');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('🔴 Paginated Categories Unexpected Error: $e');
      return const ApiResponse<List<MainCategoryModel>>(
        status: false,
        message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  @override
  Future<ApiResponse<MainCategoryModel>> updateCategory(
    MainCategoryModel category,
  ) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }
}
