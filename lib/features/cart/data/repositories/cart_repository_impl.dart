import 'package:dartz/dartz.dart';
import 'dart:developer';

import '../../../../core/error/failures.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/add_to_cart_request.dart';
import '../models/update_cart_item_request.dart';

/// 🟦 CartRepositoryImpl - تطبيق مستودع السلة
/// يطبق مبدأ قلب الاعتماديات (DIP)
class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      log('🔄 CartRepositoryImpl: Getting cart contents');

      final response = await remoteDataSource.getCart();

      if (response.status) {
        final cart = response.data!;
        log(
          '✅ CartRepositoryImpl: Cart loaded successfully - ${cart.items.length} items',
        );
        return Right(cart);
      } else {
        log('❌ CartRepositoryImpl: Failed to get cart - ${response.message}');
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CartRepositoryImpl: Exception getting cart - $e');
      return Left(ServerFailure(message: 'حدث خطأ أثناء تحميل السلة'));
    }
  }

  @override
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    int quantity = 1,
  }) async {
    try {
      log(
        '🔄 CartRepositoryImpl: Adding product $productId to cart (quantity: $quantity)',
      );

      final request = AddToCartRequest(
        productId: productId,
        quantity: quantity,
      );

      final response = await remoteDataSource.addToCart(request);

      if (response.status) {
        final cartItem = response.data!;
        log('✅ CartRepositoryImpl: Item added to cart successfully');
        return Right(cartItem);
      } else {
        log(
          '❌ CartRepositoryImpl: Failed to add item to cart - ${response.message}',
        );
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CartRepositoryImpl: Exception adding item to cart - $e');
      return Left(
        ServerFailure(message: 'حدث خطأ أثناء إضافة المنتج إلى السلة'),
      );
    }
  }

  @override
  Future<Either<Failure, CartItemEntity>> updateCartItem({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      log(
        '🔄 CartRepositoryImpl: Updating cart item $cartItemId (quantity: $quantity)',
      );

      final request = UpdateCartItemRequest(quantity: quantity);

      final response = await remoteDataSource.updateCartItem(
        cartItemId,
        request,
      );

      if (response.status) {
        final cartItem = response.data!;
        log('✅ CartRepositoryImpl: Cart item updated successfully');
        return Right(cartItem);
      } else {
        log(
          '❌ CartRepositoryImpl: Failed to update cart item - ${response.message}',
        );
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CartRepositoryImpl: Exception updating cart item - $e');
      return Left(ServerFailure(message: 'حدث خطأ أثناء تحديث عنصر السلة'));
    }
  }

  @override
  Future<Either<Failure, bool>> removeCartItem(int cartItemId) async {
    try {
      log('🔄 CartRepositoryImpl: Removing cart item $cartItemId');

      final response = await remoteDataSource.removeCartItem(cartItemId);

      if (response.status) {
        log('✅ CartRepositoryImpl: Cart item removed successfully');
        return const Right(true);
      } else {
        log(
          '❌ CartRepositoryImpl: Failed to remove cart item - ${response.message}',
        );
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CartRepositoryImpl: Exception removing cart item - $e');
      return Left(ServerFailure(message: 'حدث خطأ أثناء حذف عنصر السلة'));
    }
  }

  @override
  Future<Either<Failure, bool>> clearCart() async {
    try {
      log('🔄 CartRepositoryImpl: Clearing cart');

      final response = await remoteDataSource.clearCart();

      if (response.status) {
        log('✅ CartRepositoryImpl: Cart cleared successfully');
        return const Right(true);
      } else {
        log('❌ CartRepositoryImpl: Failed to clear cart - ${response.message}');
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ CartRepositoryImpl: Exception clearing cart - $e');
      return Left(ServerFailure(message: 'حدث خطأ أثناء تفريغ السلة'));
    }
  }
}
