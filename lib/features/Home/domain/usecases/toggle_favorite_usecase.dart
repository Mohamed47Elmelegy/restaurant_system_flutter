import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';

class ToggleFavoriteUseCase {
  final HomeRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<Either<Failure, bool>> call(int productId) async {
    return _repository.toggleFavorite(productId);
  }
}
