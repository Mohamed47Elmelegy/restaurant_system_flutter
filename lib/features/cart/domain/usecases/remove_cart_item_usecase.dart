import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/cart_repository.dart';

/// 🟦 RemoveCartItemUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن حذف عنصر من السلة فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class RemoveCartItemUseCase extends BaseUseCase<bool, RemoveCartItemParams> {
  final CartRepository repository;

  RemoveCartItemUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(RemoveCartItemParams params) async {
    return await repository.removeCartItem(params.cartItemId);
  }
}

/// 🟦 RemoveCartItemParams - معايير حذف عنصر من السلة
class RemoveCartItemParams extends Equatable {
  final int cartItemId;

  const RemoveCartItemParams({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];

  @override
  String toString() {
    return 'RemoveCartItemParams(cartItemId: $cartItemId)';
  }
}
