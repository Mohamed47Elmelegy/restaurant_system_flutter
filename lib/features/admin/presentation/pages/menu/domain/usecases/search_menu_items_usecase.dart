import '../repositories/menu_repository.dart';
import '../entities/menu_item.dart';

class SearchMenuItemsParams {
  final String query;

  const SearchMenuItemsParams({required this.query});

  @override
  String toString() => 'SearchMenuItemsParams(query: $query)';
}

class SearchMenuItemsUseCase {
  final MenuRepository repository;

  SearchMenuItemsUseCase({required this.repository});

  Future<List<MenuItem>> call(SearchMenuItemsParams params) async {
    try {
      if (params.query.trim().isEmpty) {
        throw Exception('نص البحث مطلوب');
      }
      
      if (params.query.trim().length < 2) {
        throw Exception('نص البحث يجب أن يكون على الأقل حرفين');
      }
      
      return await repository.searchMenuItems(params.query.trim());
    } catch (e) {
      throw Exception('فشل في البحث عن المنتجات: $e');
    }
  }
} 