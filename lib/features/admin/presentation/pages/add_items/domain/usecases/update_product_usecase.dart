import '../../../../../../../core/entities/product.dart';
import '../repositories/product_repository.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

/// 🟦 UpdateProductUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحديث المنتج فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class UpdateProductUseCase extends BaseUseCase<ProductEntity, ProductEntity> {
  final ProductRepository repository;

  UpdateProductUseCase({required this.repository});

  @override
  Future<Either<Failure, ProductEntity>> call(ProductEntity product) async {
    return await repository.updateProduct(product);
  }
}
