import '../../../../../../../core/error/api_response.dart';
import '../models/main_category_model.dart';

/// 🟦 CategoryRemoteDataSource - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن استدعاء API الفئات فقط
abstract class CategoryRemoteDataSource {
  /// Get all categories
  Future<ApiResponse<List<MainCategoryModel>>> getCategories({int? mealTimeId});

  /// Get categories by meal time
  Future<ApiResponse<List<MainCategoryModel>>> getCategoriesByMealTime(
    int mealTimeId,
  );

  /// Get active categories only
  Future<ApiResponse<List<MainCategoryModel>>> getActiveCategories();

  /// Get category by name
  Future<ApiResponse<MainCategoryModel?>> getCategoryByName(String name);

  /// Get category by ID
  Future<ApiResponse<MainCategoryModel?>> getCategoryById(int id);

  /// Create new category
  Future<ApiResponse<MainCategoryModel>> createCategory(
    MainCategoryModel category,
  );

  /// Update existing category
  Future<ApiResponse<MainCategoryModel>> updateCategory(
    MainCategoryModel category,
  );

  /// Delete category
  Future<ApiResponse<bool>> deleteCategory(int id);

  /// Search categories
  Future<ApiResponse<List<MainCategoryModel>>> searchCategories(String query);

  /// Get paginated categories
  Future<ApiResponse<List<MainCategoryModel>>> getCategoriesPaginated({
    int page = 1,
    int limit = 10,
    String? sortBy,
    bool ascending = true,
  });
}
