import '../../../../../../../core/error/api_response.dart';
import '../models/main_category_model.dart';
import '../models/sub_category_model.dart';

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

  /// Get categories with subcategories
  Future<ApiResponse<List<MainCategoryModel>>> getCategoriesWithSubCategories();

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

  // ==================== SUB-CATEGORIES METHODS ====================

  /// Get sub-categories for a specific category
  Future<ApiResponse<List<SubCategoryModel>>> getSubCategories(int categoryId);

  /// Create new sub-category
  Future<ApiResponse<SubCategoryModel>> createSubCategory(
    int categoryId,
    SubCategoryModel subCategory,
  );

  /// Update existing sub-category
  Future<ApiResponse<SubCategoryModel>> updateSubCategory(
    int categoryId,
    int subCategoryId,
    SubCategoryModel subCategory,
  );

  /// Delete sub-category
  Future<ApiResponse<bool>> deleteSubCategory(
    int categoryId,
    int subCategoryId,
  );
}
