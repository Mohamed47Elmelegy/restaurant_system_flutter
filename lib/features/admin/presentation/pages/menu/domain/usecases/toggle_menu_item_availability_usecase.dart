import '../repositories/menu_repository.dart';
import '../entities/menu_item.dart';

class ToggleMenuItemAvailabilityParams {
  final String id;
  final bool isAvailable;

  const ToggleMenuItemAvailabilityParams({
    required this.id,
    required this.isAvailable,
  });

  @override
  String toString() =>
      'ToggleMenuItemAvailabilityParams(id: $id, isAvailable: $isAvailable)';
}

class ToggleMenuItemAvailabilityUseCase {
  final MenuRepository repository;

  ToggleMenuItemAvailabilityUseCase({required this.repository});

  Future<MenuItem> call(ToggleMenuItemAvailabilityParams params) async {
    try {
      if (params.id.isEmpty) {
        throw Exception('معرف المنتج مطلوب');
      }

      // Get current menu item
      final currentItem = await repository.getMenuItemById(params.id);
      if (currentItem == null) {
        throw Exception('المنتج غير موجود');
      }

      // Create updated item with new availability
      final updatedItem = currentItem.copyWith(isAvailable: params.isAvailable);

      // Update the item
      return await repository.updateMenuItem(updatedItem);
    } catch (e) {
      throw Exception('فشل في تغيير حالة توفر المنتج: $e');
    }
  }
}
