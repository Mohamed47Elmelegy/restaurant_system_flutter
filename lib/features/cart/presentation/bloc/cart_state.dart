import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';

/// 🟦 CartState - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل حالات السلة فقط
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية للسلة
class CartInitial extends CartState {}

/// حالة تحميل السلة
class CartLoading extends CartState {}

/// حالة تحميل السلة بنجاح
class CartLoaded extends CartState {
  final CartEntity cart;

  const CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}

/// حالة السلة فارغة
class CartEmpty extends CartState {}

/// حالة إضافة منتج إلى السلة بنجاح
class CartItemAdded extends CartState {
  final CartItemEntity cartItem;
  final String message;

  const CartItemAdded({
    required this.cartItem,
    this.message = 'تم إضافة المنتج إلى السلة',
  });

  @override
  List<Object?> get props => [cartItem, message];
}

/// حالة تحديث عنصر السلة بنجاح
class CartItemUpdated extends CartState {
  final CartItemEntity cartItem;
  final String message;

  const CartItemUpdated({
    required this.cartItem,
    this.message = 'تم تحديث الكمية',
  });

  @override
  List<Object?> get props => [cartItem, message];
}

/// حالة حذف عنصر من السلة بنجاح
class CartItemRemoved extends CartState {
  final int cartItemId;
  final String message;

  const CartItemRemoved({
    required this.cartItemId,
    this.message = 'تم حذف المنتج من السلة',
  });

  @override
  List<Object?> get props => [cartItemId, message];
}

/// حالة تفريغ السلة بنجاح
class CartCleared extends CartState {
  final String message;

  const CartCleared({this.message = 'تم تفريغ السلة'});

  @override
  List<Object?> get props => [message];
}

/// حالة خطأ في عمليات السلة
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

/// حالة خطأ في التحقق من البيانات
class CartValidationError extends CartState {
  final String message;

  const CartValidationError(this.message);

  @override
  List<Object?> get props => [message];
}

/// حالة خطأ في المصادقة
class CartAuthError extends CartState {
  final String message;

  const CartAuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// حالة خطأ في الشبكة
class CartNetworkError extends CartState {
  final String message;

  const CartNetworkError(this.message);

  @override
  List<Object?> get props => [message];
}
