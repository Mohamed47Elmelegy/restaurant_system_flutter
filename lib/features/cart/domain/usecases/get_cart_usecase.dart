import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

/// 🟦 GetCartUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن جلب محتويات السلة فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class GetCartUseCase extends BaseUseCaseNoParams<CartEntity> {
  final CartRepository repository;

  GetCartUseCase({required this.repository});

  @override
  Future<Either<Failure, CartEntity>> call() async {
    return await repository.getCart();
  }
}
