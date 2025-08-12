import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

/// 🟦 UpdateCartItemUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحديث كمية عنصر في السلة فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class UpdateCartItemUseCase
    extends BaseUseCase<CartItemEntity, UpdateCartItemParams> {
  final CartRepository repository;

  UpdateCartItemUseCase({required this.repository});

  @override
  Future<Either<Failure, CartItemEntity>> call(
    UpdateCartItemParams params,
  ) async {
    return await repository.updateCartItem(
      cartItemId: params.cartItemId,
      quantity: params.quantity,
    );
  }
}

/// 🟦 UpdateCartItemParams - معايير تحديث عنصر السلة
class UpdateCartItemParams extends Equatable {
  final int cartItemId;
  final int quantity;

  const UpdateCartItemParams({
    required this.cartItemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [cartItemId, quantity];

  @override
  String toString() {
    return 'UpdateCartItemParams(cartItemId: $cartItemId, quantity: $quantity)';
  }
}
