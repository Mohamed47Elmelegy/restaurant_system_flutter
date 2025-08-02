import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class GetMenuItemsUseCase extends BaseUseCaseNoParams<List<MenuItem>> {
  final MenuRepository repository;

  GetMenuItemsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MenuItem>>> call() async {
    return await repository.getMenuItems();
  }
}
