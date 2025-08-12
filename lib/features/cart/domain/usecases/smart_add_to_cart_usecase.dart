import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

/// 🟦 SmartAddToCartUseCase - منطق ذكي لإضافة المنتجات
/// يتحقق من وجود المنتج ويقرر إضافة أم تحديث
class SmartAddToCartUseCase
    extends BaseUseCase<CartItemEntity, SmartAddToCartParams> {
  final CartRepository repository;

  SmartAddToCartUseCase({required this.repository});

  @override
  Future<Either<Failure, CartItemEntity>> call(
    SmartAddToCartParams params,
  ) async {
    // 1. الحصول على السلة الحالية
    final cartResult = await repository.getCart();

    return cartResult.fold((failure) => Left(failure), (cart) async {
      // 2. التحقق من وجود المنتج
      final existingItem = cart.getItemByProductId(params.productId);

      if (existingItem != null) {
        // 3. المنتج موجود: تحديث الكمية
        final newQuantity = existingItem.quantity + params.quantity;
        return await repository.updateCartItem(
          cartItemId: existingItem.id,
          quantity: newQuantity,
        );
      } else {
        // 4. المنتج جديد: إضافة إلى السلة
        return await repository.addToCart(
          productId: params.productId,
          quantity: params.quantity,
        );
      }
    });
  }
}

/// Parameters للـ Smart Add to Cart
class SmartAddToCartParams extends Equatable {
  final int productId;
  final int quantity;

  const SmartAddToCartParams({required this.productId, this.quantity = 0});

  @override
  List<Object?> get props => [productId, quantity];
}
