import '../../../../core/error/api_response.dart';
import '../models/category/main_category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<ApiResponse<List<MainCategoryModel>>> getCategories({int? mealTimeId});
}
