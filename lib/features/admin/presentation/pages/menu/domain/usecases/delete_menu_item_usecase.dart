import 'package:dartz/dartz.dart';

import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import '../repositories/menu_repository.dart';

class DeleteMenuItemParams {
  final String id;

  const DeleteMenuItemParams({required this.id});

  @override
  String toString() => 'DeleteMenuItemParams(id: $id)';
}

class DeleteMenuItemUseCase extends BaseUseCase<bool, DeleteMenuItemParams> {
  final MenuRepository repository;

  DeleteMenuItemUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(DeleteMenuItemParams params) async {
    try {
      if (params.id.isEmpty) {
        return const Left(ServerFailure(message: 'معرف المنتج مطلوب'));
      }

      return await repository.deleteMenuItem(params.id);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل في حذف المنتج: $e'));
    }
  }
}
