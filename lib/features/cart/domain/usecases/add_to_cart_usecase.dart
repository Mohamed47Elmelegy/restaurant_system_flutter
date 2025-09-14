import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

/// 🟦 AddToCartUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إضافة المنتجات إلى السلة بذكاء
/// يتحقق من وجود المنتج ويقرر إضافة جديد أم تحديث موجود
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class AddToCartUseCase extends BaseUseCase<CartItemEntity, AddToCartParams> {
  final CartRepository repository;

  AddToCartUseCase({required this.repository});

  @override
  Future<Either<Failure, CartItemEntity>> call(AddToCartParams params) async {
    print(
      '🔍 AddToCartUseCase: Called with productId=${params.productId}, quantity=${params.quantity}',
    );

    // 1. الحصول على السلة الحالية للتحقق من وجود المنتج
    final cartResult = await repository.getCart();

    return cartResult.fold((failure) => Left(failure), (cart) async {
      print('🔍 AddToCartUseCase: Current cart has ${cart.items.length} items');

      // 2. التحقق من وجود المنتج في السلة
      final existingItem = cart.getItemByProductId(params.productId);

      if (existingItem != null) {
        // 3. المنتج موجود: تحديث الكمية
        final newQuantity = existingItem.quantity + params.quantity;
        print(
          '🔍 AddToCartUseCase: Product EXISTS - updating quantity from ${existingItem.quantity} to $newQuantity',
        );
        return repository.updateCartItem(
          cartItemId: existingItem.id,
          quantity: newQuantity,
        );
      } else {
        // 4. المنتج جديد: إضافة إلى السلة
        print(
          '🔍 AddToCartUseCase: Product NEW - adding with quantity ${params.quantity}',
        );
        return repository.addToCart(
          productId: params.productId,
          quantity: params.quantity,
        );
      }
    });
  }
}

/// 🟦 AddToCartParams - معايير إضافة المنتج إلى السلة
class AddToCartParams extends Equatable {
  final int productId;
  final int quantity;

  const AddToCartParams({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];

  @override
  String toString() {
    return 'AddToCartParams(productId: $productId, quantity: $quantity)';
  }
}
