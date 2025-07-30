import '../repositories/menu_repository.dart';

class DeleteMenuItemParams {
  final String id;

  const DeleteMenuItemParams({required this.id});

  @override
  String toString() => 'DeleteMenuItemParams(id: $id)';
}

class DeleteMenuItemUseCase {
  final MenuRepository repository;

  DeleteMenuItemUseCase({required this.repository});

  Future<bool> call(DeleteMenuItemParams params) async {
    try {
      if (params.id.isEmpty) {
        throw Exception('معرف المنتج مطلوب');
      }
      
      return await repository.deleteMenuItem(params.id);
    } catch (e) {
      throw Exception('فشل في حذف المنتج: $e');
    }
  }
} 