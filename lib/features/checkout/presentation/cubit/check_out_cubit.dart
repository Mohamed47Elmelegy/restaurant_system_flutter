import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../orders/data/models/order_item_model.dart';
import '../../../orders/data/models/place_order_request_model.dart';
import '../../domain/usecases/check_out_place_order_usecase.dart';
import 'check_out_state.dart';


class CheckOutCubit extends Cubit<CheckOutState> {
  final CheckOutPlaceOrderUseCase checkOutUseCase;
  CheckOutCubit(this.checkOutUseCase) : super(CheckOutInitial());

  Future<void> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  ) async {
    emit(CheckOutLoading());
    try {
      final order = await checkOutUseCase(request, items);
      emit(CheckOutSuccess(orderId: order.id));
    } catch (e) {
      emit(CheckOutFailure(message: e.toString()));
    }
  }
}
