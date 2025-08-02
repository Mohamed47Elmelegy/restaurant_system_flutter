import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class GetMenuItemByIdUseCase extends BaseUseCase<MenuItem?, String> {
  final MenuRepository repository;

  GetMenuItemByIdUseCase({required this.repository});

  @override
  Future<Either<Failure, MenuItem?>> call(String id) async {
    return await repository.getMenuItemById(id);
  }
}
