import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_running_orders_usecase.dart';
import '../../domain/usecases/mark_order_done_usecase.dart';
import '../../domain/usecases/cancel_order_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetRunningOrdersUseCase getRunningOrdersUseCase;
  final MarkOrderDoneUseCase markOrderDoneUseCase;
  final CancelOrderUseCase cancelOrderUseCase;

  OrderBloc({
    required this.getRunningOrdersUseCase,
    required this.markOrderDoneUseCase,
    required this.cancelOrderUseCase,
  }) : super(OrderInitial()) {
    on<LoadRunningOrders>(_onLoadRunningOrders);
    on<LoadNewOrders>(_onLoadNewOrders);
    on<MarkOrderAsDone>(_onMarkOrderAsDone);
    on<CancelOrder>(_onCancelOrder);
  }

  Future<void> _onLoadRunningOrders(
    LoadRunningOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await getRunningOrdersUseCase();
      emit(RunningOrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onLoadNewOrders(
    LoadNewOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await getRunningOrdersUseCase(); // Using same for demo
      emit(NewOrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onMarkOrderAsDone(
    MarkOrderAsDone event,
    Emitter<OrderState> emit,
  ) async {
    try {
      final success = await markOrderDoneUseCase(event.orderId);
      if (success) {
        emit(const OrderActionSuccess('Order marked as done successfully'));
      } else {
        emit(const OrderError('Failed to mark order as done'));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrderState> emit,
  ) async {
    try {
      final success = await cancelOrderUseCase(event.orderId);
      if (success) {
        emit(const OrderActionSuccess('Order cancelled successfully'));
      } else {
        emit(const OrderError('Failed to cancel order'));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
