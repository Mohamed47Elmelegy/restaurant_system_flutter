import 'package:dio/dio.dart';
import 'dart:developer';
import '../../../../../../../core/error/api_response.dart';
import '../../../../../../../core/network/api_path.dart';
import '../models/main_category_model.dart';
import '../models/sub_category_model.dart';
import 'category_remote_data_source.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl(this.dio);

  @override
  Future<ApiResponse<List<MainCategoryModel>>> getCategories({
    int? mealTimeId,
  }) async {
    try {
      log('🔵 Categories Request - URL: ${ApiPath.categories()}');

      final queryParameters = <String, dynamic>{};
      if (mealTimeId != null) {
        queryParameters['meal_time_id'] = mealTimeId;
      }

      final response = await dio.get(
        ApiPath.categories(),
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
  Future<ApiResponse<List<MainCategoryModel>>> getActiveCategories() async {
    try {
      log('🔄 CategoryRemoteDataSourceImpl: Getting active categories');

      final response = await dio.get('${ApiPath.adminCategories()}?active=1');

      final List<dynamic> data = response.data['data'];
      final categories = data
          .map((json) => MainCategoryModel.fromJson(json))
          .toList();

      log(
        '✅ CategoryRemoteDataSourceImpl: Active categories loaded - ${categories.length}',
      );
      return ApiResponse.success(categories);
    } on DioException catch (e) {
      log(
        '❌ CategoryRemoteDataSourceImpl: Failed to get active categories - $e',
      );
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log(
        '❌ CategoryRemoteDataSourceImpl: Failed to get active categories - $e',
      );
      return ApiResponse.error('Failed to get active categories: $e');
    }
  }

  @override
  Future<ApiResponse<List<MainCategoryModel>>> getCategoriesByMealTime(
    int mealTimeId,
  ) async {
    try {
      log(
        '🔄 CategoryRemoteDataSourceImpl: Getting categories by meal time - $mealTimeId',
      );

      final response = await dio.get(
        '${ApiPath.adminCategories()}?meal_time_id=$mealTimeId',
      );

      final List<dynamic> data = response.data['data'];
      final categories = data
          .map((json) => MainCategoryModel.fromJson(json))
          .toList();

      log(
        '✅ CategoryRemoteDataSourceImpl: Categories by meal time loaded - ${categories.length}',
      );
      return ApiResponse.success(categories);
    } on DioException catch (e) {
      log(
        '❌ CategoryRemoteDataSourceImpl: Failed to get categories by meal time - $e',
      );
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log(
        '❌ CategoryRemoteDataSourceImpl: Failed to get categories by meal time - $e',
      );
      return ApiResponse.error('Failed to get categories by meal time: $e');
    }
  }

  @override
  Future<ApiResponse<List<MainCategoryModel>>> getCategoriesPaginated({
    int page = 1,
    int limit = 10,
    String? sortBy,
    bool ascending = true,
  }) {
    // TODO: implement getCategoriesPaginated
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<List<MainCategoryModel>>>
  getCategoriesWithSubCategories() {
    // TODO: implement getCategoriesWithSubCategories
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<MainCategoryModel?>> getCategoryById(int id) {
    // TODO: implement getCategoryById
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<MainCategoryModel?>> getCategoryByName(String name) {
    // TODO: implement getCategoryByName
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<List<MainCategoryModel>>> searchCategories(String query) {
    // TODO: implement searchCategories
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<MainCategoryModel>> updateCategory(
    MainCategoryModel category,
  ) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }

  // ==================== SUB-CATEGORIES IMPLEMENTATION ====================

  @override
  Future<ApiResponse<List<SubCategoryModel>>> getSubCategories(
    int categoryId,
  ) async {
    try {
      log(
        '🔄 CategoryRemoteDataSourceImpl: Getting sub-categories for category - $categoryId',
      );

      final response = await dio.get(
        ApiPath.adminCategorySubCategories(categoryId),
      );

      final List<dynamic> data = response.data['data'];
      final subCategories = data
          .map((json) => SubCategoryModel.fromJson(json))
          .toList();

      log(
        '✅ CategoryRemoteDataSourceImpl: Sub-categories loaded - ${subCategories.length}',
      );
      return ApiResponse.success(subCategories);
    } on DioException catch (e) {
      log('❌ CategoryRemoteDataSourceImpl: Failed to get sub-categories - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ CategoryRemoteDataSourceImpl: Failed to get sub-categories - $e');
      return ApiResponse.error('Failed to get sub-categories: $e');
    }
  }

  @override
  Future<ApiResponse<SubCategoryModel>> createSubCategory(
    int categoryId,
    SubCategoryModel subCategory,
  ) async {
    try {
      log(
        '🔄 CategoryRemoteDataSourceImpl: Creating sub-category - ${subCategory.name}',
      );

      final response = await dio.post(
        ApiPath.adminCategorySubCategories(categoryId),
        data: subCategory.toJson(),
      );

      log('✅ CategoryRemoteDataSourceImpl: Sub-category created successfully');
      return ApiResponse.success(
        SubCategoryModel.fromJson(response.data['data']),
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
  Future<ApiResponse<SubCategoryModel>> updateSubCategory(
    int categoryId,
    int subCategoryId,
    SubCategoryModel subCategory,
  ) async {
    try {
      log(
        '🔄 CategoryRemoteDataSourceImpl: Updating sub-category - $subCategoryId',
      );

      final response = await dio.put(
        '${ApiPath.adminCategorySubCategories(categoryId)}/$subCategoryId',
        data: subCategory.toJson(),
      );

      log('✅ CategoryRemoteDataSourceImpl: Sub-category updated successfully');
      return ApiResponse.success(
        SubCategoryModel.fromJson(response.data['data']),
      );
    } on DioException catch (e) {
      log('❌ CategoryRemoteDataSourceImpl: Failed to update sub-category - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ CategoryRemoteDataSourceImpl: Failed to update sub-category - $e');
      return ApiResponse.error('Failed to update sub-category: $e');
    }
  }

  @override
  Future<ApiResponse<bool>> deleteSubCategory(
    int categoryId,
    int subCategoryId,
  ) async {
    try {
      log(
        '🔄 CategoryRemoteDataSourceImpl: Deleting sub-category - $subCategoryId',
      );

      await dio.delete(
        '${ApiPath.adminCategorySubCategories(categoryId)}/$subCategoryId',
      );

      log('✅ CategoryRemoteDataSourceImpl: Sub-category deleted successfully');
      return ApiResponse.success(true);
    } on DioException catch (e) {
      log('❌ CategoryRemoteDataSourceImpl: Failed to delete sub-category - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ CategoryRemoteDataSourceImpl: Failed to delete sub-category - $e');
      return ApiResponse.error('Failed to delete sub-category: $e');
    }
  }
}
