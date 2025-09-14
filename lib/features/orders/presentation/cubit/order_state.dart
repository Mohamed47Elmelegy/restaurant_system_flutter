part of 'order_cubit.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final OrderEntity order;
  OrderSuccess(this.order);
}

class OrderFailure extends OrderState {
  final String message;
  OrderFailure(this.message);
}
