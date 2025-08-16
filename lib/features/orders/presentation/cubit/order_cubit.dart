import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/place_order_usecase.dart';
import '../../data/models/place_order_request_model.dart';
import '../../data/models/order_item_model.dart';
import '../../domain/entities/order_entity.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final PlaceOrderUseCase placeOrderUseCase;
  OrderCubit(this.placeOrderUseCase) : super(OrderInitial());

  Future<void> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  ) async {
    emit(OrderLoading());
    try {
      final order = await placeOrderUseCase(request, items);
      emit(OrderSuccess(order));
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }
}


