import 'package:equatable/equatable.dart';

/// 🟦 CartEvent - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل أحداث السلة فقط
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// حدث تحميل السلة
class LoadCart extends CartEvent {}

/// حدث إضافة منتج إلى السلة
class AddToCart extends CartEvent {
  final int productId;
  final int quantity;

  const AddToCart({required this.productId, this.quantity = 1});

  @override
  List<Object?> get props => [productId, quantity];
}

/// حدث تحديث كمية عنصر في السلة
class UpdateCartItem extends CartEvent {
  final int cartItemId;
  final int quantity;

  const UpdateCartItem({required this.cartItemId, required this.quantity});

  @override
  List<Object?> get props => [cartItemId, quantity];
}

/// حدث حذف عنصر من السلة
class RemoveCartItem extends CartEvent {
  final int cartItemId;

  const RemoveCartItem({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];
}

/// حدث تفريغ السلة بالكامل
class ClearCart extends CartEvent {}

/// حدث إعادة تحميل السلة
class RefreshCart extends CartEvent {}

/// حدث إعادة تعيين حالة السلة
class ResetCartState extends CartEvent {}
