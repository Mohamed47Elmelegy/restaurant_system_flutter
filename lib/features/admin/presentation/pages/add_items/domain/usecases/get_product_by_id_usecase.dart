import '../../../../../../../core/entities/product.dart';
import '../repositories/product_repository.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

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
    return await repository.getProductById(id);
  }
}
