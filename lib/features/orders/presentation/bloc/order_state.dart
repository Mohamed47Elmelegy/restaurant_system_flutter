import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class RunningOrdersLoaded extends OrderState {
  final List<OrderEntity> orders;

  const RunningOrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class NewOrdersLoaded extends OrderState {
  final List<OrderEntity> orders;

  const NewOrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderActionSuccess extends OrderState {
  final String message;

  const OrderActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}
