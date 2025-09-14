import 'package:dartz/dartz.dart';

import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/entities/product.dart';
import '../../../../../../../core/error/failures.dart';
import '../repositories/product_repository.dart';

/// 🟦 GetProductsUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن جلب المنتجات فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class GetProductsUseCase extends BaseUseCaseNoParams<List<ProductEntity>> {
  final ProductRepository repository;

  GetProductsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call() async {
    return repository.getProducts();
  }
}
