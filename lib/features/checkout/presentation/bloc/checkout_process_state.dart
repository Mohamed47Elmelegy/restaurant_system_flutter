import 'package:equatable/equatable.dart';

import '../../../orders/domain/entities/order_entity.dart';
import '../../domain/entities/checkout_process_entity.dart';

/// 🟦 CheckoutProcess States - Following SOLID principles
abstract class CheckoutProcessState extends Equatable {
  const CheckoutProcessState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CheckoutProcessInitial extends CheckoutProcessState {
  const CheckoutProcessInitial();
}

/// Loading state
class CheckoutProcessLoading extends CheckoutProcessState {
  final String? message;

  const CheckoutProcessLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// Checkout process loaded and active
class CheckoutProcessActive extends CheckoutProcessState {
  final CheckoutProcessEntity process;

  const CheckoutProcessActive({required this.process});

  @override
  List<Object?> get props => [process];
}

/// Step updated successfully
class CheckoutStepUpdated extends CheckoutProcessState {
  final CheckoutProcessEntity process;
  final String? message;

  const CheckoutStepUpdated({required this.process, this.message});

  @override
  List<Object?> get props => [process, message];
}

/// Navigation completed
class CheckoutNavigationCompleted extends CheckoutProcessState {
  final CheckoutProcessEntity process;

  const CheckoutNavigationCompleted({required this.process});

  @override
  List<Object?> get props => [process];
}

/// Order placed successfully
class CheckoutCompleted extends CheckoutProcessState {
  final OrderEntity order;
  final CheckoutProcessEntity process;

  const CheckoutCompleted({required this.order, required this.process});

  @override
  List<Object?> get props => [order, process];
}

/// Error state
class CheckoutProcessError extends CheckoutProcessState {
  final String message;
  final CheckoutProcessEntity? process;

  const CheckoutProcessError({required this.message, this.process});

  @override
  List<Object?> get props => [message, process];
}

/// Checkout cancelled
class CheckoutProcessCancelled extends CheckoutProcessState {
  final CheckoutProcessEntity? process;

  const CheckoutProcessCancelled({this.process});

  @override
  List<Object?> get props => [process];
}
