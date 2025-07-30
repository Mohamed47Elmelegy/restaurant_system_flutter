import '../repositories/menu_repository.dart';
import '../entities/menu_item.dart';

class LoadMenuItemsUseCase {
  final MenuRepository repository;

  LoadMenuItemsUseCase({required this.repository});

  Future<List<MenuItem>> call() async {
    try {
      return await repository.getMenuItems();
    } catch (e) {
      throw Exception('فشل في تحميل المنتجات: $e');
    }
  }
} 