import '../repositories/menu_repository.dart';
import '../entities/menu_item.dart';

class LoadMenuItemsByCategoryParams {
  final String category;

  const LoadMenuItemsByCategoryParams({required this.category});

  @override
  String toString() => 'LoadMenuItemsByCategoryParams(category: $category)';
}

class LoadMenuItemsByCategoryUseCase {
  final MenuRepository repository;

  LoadMenuItemsByCategoryUseCase({required this.repository});

  Future<List<MenuItem>> call(LoadMenuItemsByCategoryParams params) async {
    try {
      if (params.category.isEmpty) {
        throw Exception('اسم الفئة مطلوب');
      }
      
      return await repository.getMenuItemsByCategory(params.category);
    } catch (e) {
      throw Exception('فشل في تحميل المنتجات للفئة ${params.category}: $e');
    }
  }
} 