import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class UpdateMenuItemUseCase extends BaseUseCase<MenuItem, MenuItem> {
  final MenuRepository repository;

  UpdateMenuItemUseCase({required this.repository});

  @override
  Future<Either<Failure, MenuItem>> call(MenuItem menuItem) async {
    return await repository.updateMenuItem(menuItem);
  }
}
