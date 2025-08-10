import '../../../../../../../core/entities/product.dart';
import '../repositories/product_repository.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

/// 🟦 CreateProductUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إنشاء المنتج فقط - لا يتحكم في البيانات
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class CreateProductUseCase extends BaseUseCase<ProductEntity, ProductEntity> {
  final ProductRepository repository;

  CreateProductUseCase({required this.repository});

  @override
  Future<Either<Failure, ProductEntity>> call(ProductEntity product) async {
    return await repository.createProduct(product);
  }
}
