import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllOrders extends OrderEvent {
  const LoadAllOrders();
}

class LoadRunningOrders extends OrderEvent {
  const LoadRunningOrders();
}

class LoadNewOrders extends OrderEvent {
  const LoadNewOrders();
}

class MarkOrderAsDone extends OrderEvent {
  final int orderId;

  const MarkOrderAsDone(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class CancelOrder extends OrderEvent {
  final int orderId;

  const CancelOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
