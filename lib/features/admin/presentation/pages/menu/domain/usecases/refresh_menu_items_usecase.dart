import '../repositories/menu_repository.dart';
import '../entities/menu_item.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class RefreshMenuItemsUseCase extends BaseUseCaseNoParams<List<MenuItem>> {
  final MenuRepository repository;

  RefreshMenuItemsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MenuItem>>> call() async {
    return await repository.refreshMenuItems();
  }
}
