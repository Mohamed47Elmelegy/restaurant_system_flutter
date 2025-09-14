import 'package:dartz/dartz.dart';

import '../../../../core/entities/product.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';

class GetRecommendedItemsUseCase {
  final HomeRepository _repository;

  GetRecommendedItemsUseCase(this._repository);

  Future<Either<Failure, List<ProductEntity>>> call() async {
    return _repository.getRecommendedItems();
  }
}
