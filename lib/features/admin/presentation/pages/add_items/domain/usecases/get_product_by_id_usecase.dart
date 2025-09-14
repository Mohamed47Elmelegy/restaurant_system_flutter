import 'package:dartz/dartz.dart';

import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/entities/product.dart';
import '../../../../../../../core/error/failures.dart';
import '../repositories/product_repository.dart';

/// 🟦 GetProductByIdUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن جلب منتج واحد فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class GetProductByIdUseCase extends BaseUseCase<ProductEntity?, int> {
  final ProductRepository repository;

  GetProductByIdUseCase({required this.repository});

  @override
  Future<Either<Failure, ProductEntity?>> call(int id) async {
    return repository.getProductById(id);
  }
}
