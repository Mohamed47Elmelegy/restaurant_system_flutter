import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/cart_entity.dart';
import '../entities/cart_item_entity.dart';

/// 🟦 CartRepository - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحديد عمليات السلة فقط
///
/// 🟦 مبدأ الفتح والإغلاق (OCP)
/// يمكن إضافة repositories جديدة بدون تعديل CartRepository
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstraction وليس implementation
abstract class CartRepository {
  /// Get cart contents
  Future<Either<Failure, CartEntity>> getCart();

  /// Add item to cart
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    int quantity = 1,
  });

  /// Update cart item quantity
  Future<Either<Failure, CartItemEntity>> updateCartItem({
    required int cartItemId,
    required int quantity,
  });

  /// Remove item from cart
  Future<Either<Failure, bool>> removeCartItem(int cartItemId);

  /// Clear entire cart
  Future<Either<Failure, bool>> clearCart();
}
