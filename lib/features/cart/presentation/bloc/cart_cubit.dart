import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_cart_item_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// 🟦 CartCubit - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إدارة حالة السلة فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على Use Cases وليس Repository مباشرة
class CartCubit extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveCartItemUseCase removeCartItemUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartCubit({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartItemUseCase,
    required this.removeCartItemUseCase,
    required this.clearCartUseCase,
  }) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateCartItem>(_onUpdateCartItem);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<ClearCart>(_onClearCart);
    on<RefreshCart>(_onRefreshCart);
    on<ResetCartState>(_onResetCartState);
  }

  /// تحميل السلة
  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      log('🔄 CartCubit: Loading cart...');

      final result = await getCartUseCase();

      result.fold(
        (failure) {
          log('❌ CartCubit: Failed to load cart - $failure');
          emit(CartError(failure.message));
        },
        (cart) {
          log(
            '✅ CartCubit: Cart loaded successfully - ${cart.items.length} items',
          );
          if (cart.isEmpty) {
            emit(CartEmpty());
          } else {
            emit(CartLoaded(cart));
          }
        },
      );
    } catch (e) {
      log('❌ CartCubit: Failed to load cart - $e');
      emit(const CartError('حدث خطأ غير متوقع أثناء تحميل السلة'));
    }
  }

  /// إضافة منتج إلى السلة
  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      log(
        '🔄 CartCubit: Smart adding product ${event.productId} to cart (quantity: ${event.quantity})',
      );

      final params = AddToCartParams(
        productId: event.productId,
        quantity: event.quantity,
      );

      final result = await addToCartUseCase(params);

      result.fold(
        (failure) {
          log('❌ CartCubit: Failed to add item to cart - $failure');
          emit(CartError(failure.message));
        },
        (cartItem) {
          log('✅ CartCubit: Item added/updated in cart successfully');
          emit(CartItemAdded(cartItem: cartItem));
          // إعادة تحميل السلة لعرض التحديثات
          add(LoadCart());
        },
      );
    } catch (e) {
      log('❌ CartCubit: Failed to add item to cart - $e');
      emit(const CartError('حدث خطأ غير متوقع أثناء إضافة المنتج'));
    }
  }

  /// تحديث كمية عنصر في السلة
  Future<void> _onUpdateCartItem(
    UpdateCartItem event,
    Emitter<CartState> emit,
  ) async {
    try {
      log(
        '🔄 CartCubit: Updating cart item  [200m${event.cartItemId} [0m (quantity: ${event.quantity})',
      );

      final params = UpdateCartItemParams(
        cartItemId: event.cartItemId,
        quantity: event.quantity,
      );

      final result = await updateCartItemUseCase(params);

      result.fold(
        (failure) {
          log('❌ CartCubit: Failed to update cart item - $failure');
          emit(CartError(failure.message));
        },
        (cartItem) {
          log('✅ CartCubit: Cart item updated successfully');
          emit(
            CartItemQuantityUpdated(
              cartItemId: event.cartItemId,
              quantity: event.quantity,
            ),
          );
          // لا تعيد تحميل السلة بالكامل هنا
        },
      );
    } catch (e) {
      log('❌ CartCubit: Failed to update cart item - $e');
      emit(const CartError('حدث خطأ غير متوقع أثناء تحديث العنصر'));
    }
  }

  /// حذف عنصر من السلة
  Future<void> _onRemoveCartItem(
    RemoveCartItem event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      log('🔄 CartCubit: Removing cart item ${event.cartItemId}');

      final params = RemoveCartItemParams(cartItemId: event.cartItemId);

      final result = await removeCartItemUseCase(params);

      result.fold(
        (failure) {
          log('❌ CartCubit: Failed to remove cart item - $failure');
          emit(CartError(failure.message));
        },
        (success) {
          log('✅ CartCubit: Cart item removed successfully');
          emit(CartItemRemoved(cartItemId: event.cartItemId));
          // إعادة تحميل السلة لعرض التحديثات
          add(LoadCart());
        },
      );
    } catch (e) {
      log('❌ CartCubit: Failed to remove cart item - $e');
      emit(const CartError('حدث خطأ غير متوقع أثناء حذف العنصر'));
    }
  }

  /// تفريغ السلة بالكامل
  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      log('🔄 CartCubit: Clearing cart');

      final result = await clearCartUseCase();

      result.fold(
        (failure) {
          log('❌ CartCubit: Failed to clear cart - $failure');
          emit(CartError(failure.message));
        },
        (success) {
          log('✅ CartCubit: Cart cleared successfully');
          emit(const CartCleared());
          // عرض السلة الفارغة
          emit(CartEmpty());
        },
      );
    } catch (e) {
      log('❌ CartCubit: Failed to clear cart - $e');
      emit(const CartError('حدث خطأ غير متوقع أثناء تفريغ السلة'));
    }
  }

  /// إعادة تحميل السلة
  Future<void> _onRefreshCart(
    RefreshCart event,
    Emitter<CartState> emit,
  ) async {
    log('🔄 CartCubit: Refreshing cart');
    add(LoadCart());
  }

  /// إعادة تعيين حالة السلة
  void _onResetCartState(ResetCartState event, Emitter<CartState> emit) {
    log('🔄 CartCubit: Resetting cart state');
    emit(CartInitial());
  }

  /// الحصول على عدد العناصر في السلة
  int get cartItemsCount {
    if (state is CartLoaded) {
      return (state as CartLoaded).cart.uniqueItemsCount;
    }
    return 0;
  }

  /// الحصول على العدد الإجمالي للكمية في السلة
  int get totalQuantity {
    if (state is CartLoaded) {
      return (state as CartLoaded).cart.totalItemsCount;
    }
    return 0;
  }

  /// التحقق من وجود منتج في السلة
  bool hasProduct(int productId) {
    if (state is CartLoaded) {
      return (state as CartLoaded).cart.hasProduct(productId);
    }
    return false;
  }

  /// الحصول على إجمالي السعر
  double get totalPrice {
    if (state is CartLoaded) {
      return (state as CartLoaded).cart.subtotal;
    }
    return 0.0;
  }
}
