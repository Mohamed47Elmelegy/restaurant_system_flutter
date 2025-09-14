import 'package:dartz/dartz.dart';

import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';

class LoadMenuItemsUseCase extends BaseUseCaseNoParams<List<MenuItem>> {
  final MenuRepository repository;

  LoadMenuItemsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MenuItem>>> call() async {
    return repository.getMenuItems();
  }
}
