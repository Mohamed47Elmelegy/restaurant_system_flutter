import 'package:equatable/equatable.dart';

abstract class CheckOutState extends Equatable {
  const CheckOutState();
  @override
  List<Object?> get props => [];
}

class CheckOutInitial extends CheckOutState {}

class CheckOutLoading extends CheckOutState {}

class CheckOutSuccess extends CheckOutState {
  final int orderId;
  final String? qrCode;
  const CheckOutSuccess({required this.orderId, this.qrCode});

  @override
  List<Object?> get props => [orderId, qrCode];
}

class CheckOutFailure extends CheckOutState {
  final String message;
  const CheckOutFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
