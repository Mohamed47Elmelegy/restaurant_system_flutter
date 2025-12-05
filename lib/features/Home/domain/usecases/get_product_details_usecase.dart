import 'package:dartz/dartz.dart';

import '../../../../core/entities/product.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';

class GetProductDetailsUseCase {
  final HomeRepository _repository;

  GetProductDetailsUseCase(this._repository);

  Future<Either<Failure, ProductEntity>> call(int productId) async {
    return _repository.getProductById(productId);
  }
}
