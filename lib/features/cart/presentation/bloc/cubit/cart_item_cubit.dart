import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/cart_item_entity.dart';

part 'cart_item_state.dart';

class CartItemCubit extends Cubit<CartItemState> {
  CartItemCubit() : super(CartItemInitial());
  void updateCartItem(CartItemEntity cartItemEntity) {
    emit(CartItemUpdated(cartItemEntity));
  }
}
