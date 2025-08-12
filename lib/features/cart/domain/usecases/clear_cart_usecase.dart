import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/cart_repository.dart';

/// 🟦 ClearCartUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تفريغ السلة بالكامل فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class ClearCartUseCase extends BaseUseCaseNoParams<bool> {
  final CartRepository repository;

  ClearCartUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call() async {
    return await repository.clearCart();
  }
}
