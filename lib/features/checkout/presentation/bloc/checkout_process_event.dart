import 'package:equatable/equatable.dart';

import '../../../cart/domain/entities/cart_entity.dart';
import '../../domain/entities/checkout_step_entity.dart';

/// 🟦 CheckoutProcess Events - Following SOLID principles
abstract class CheckoutProcessEvent extends Equatable {
  const CheckoutProcessEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize checkout process with cart
class InitializeCheckout extends CheckoutProcessEvent {
  final CartEntity cart;

  const InitializeCheckout({required this.cart});

  @override
  List<Object?> get props => [cart];
}

/// Update step data
class UpdateCheckoutStep extends CheckoutProcessEvent {
  final CheckoutStepType stepType;
  final Map<String, dynamic> stepData;

  const UpdateCheckoutStep({required this.stepType, required this.stepData});

  @override
  List<Object?> get props => [stepType, stepData];
}

/// Update step data and automatically navigate to next step
class UpdateCheckoutStepAndProceed extends CheckoutProcessEvent {
  final CheckoutStepType stepType;
  final Map<String, dynamic> stepData;

  const UpdateCheckoutStepAndProceed({
    required this.stepType,
    required this.stepData,
  });

  @override
  List<Object?> get props => [stepType, stepData];
}

/// Navigate to next step
class NavigateToNextStep extends CheckoutProcessEvent {
  const NavigateToNextStep();
}

/// Navigate to previous step
class NavigateToPreviousStep extends CheckoutProcessEvent {
  const NavigateToPreviousStep();
}

/// Navigate to specific step
class NavigateToStep extends CheckoutProcessEvent {
  final int stepIndex;

  const NavigateToStep({required this.stepIndex});

  @override
  List<Object?> get props => [stepIndex];
}

/// Complete checkout and place order
class CompleteCheckout extends CheckoutProcessEvent {
  const CompleteCheckout();
}

/// Cancel checkout process
class CancelCheckout extends CheckoutProcessEvent {
  const CancelCheckout();
}

/// Reset checkout process
class ResetCheckout extends CheckoutProcessEvent {
  const ResetCheckout();
}
