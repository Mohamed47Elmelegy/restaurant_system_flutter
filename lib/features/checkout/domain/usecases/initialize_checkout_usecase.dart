import '../../../cart/domain/entities/cart_entity.dart';
import '../entities/checkout_process_entity.dart';
import '../entities/checkout_step_entity.dart';

/// 🟦 InitializeCheckoutUseCase - Domain Layer
/// Single Responsibility: Initialize checkout process with proper steps
class InitializeCheckoutUseCase {
  /// Initialize checkout process with cart data
  CheckoutProcessEntity call(CartEntity cart) {
    final steps = _createCheckoutSteps();
    final checkoutData = const CheckoutDataEntity();

    return CheckoutProcessEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cart: cart,
      steps: steps,
      currentStepIndex: 0,
      status: CheckoutProcessStatus.initialized,
      checkoutData: checkoutData,
      createdAt: DateTime.now(),
    );
  }

  /// Create list of checkout steps
  List<CheckoutStepEntity> _createCheckoutSteps() {
    return [
      CheckoutStepEntity(
        type: CheckoutStepType.orderType,
        title: CheckoutStepType.orderType.title,
        description: CheckoutStepType.orderType.description,
        isActive: true,
        isEnabled: true,
      ),
      CheckoutStepEntity(
        type: CheckoutStepType.addressSelection,
        title: CheckoutStepType.addressSelection.title,
        description: CheckoutStepType.addressSelection.description,
        isEnabled: false, // Will be enabled based on order type
      ),
      CheckoutStepEntity(
        type: CheckoutStepType.tableSelection,
        title: CheckoutStepType.tableSelection.title,
        description: CheckoutStepType.tableSelection.description,
        isEnabled: false, // Will be enabled based on order type
      ),
      CheckoutStepEntity(
        type: CheckoutStepType.orderReview,
        title: CheckoutStepType.orderReview.title,
        description: CheckoutStepType.orderReview.description,
        isEnabled: false,
      ),
      CheckoutStepEntity(
        type: CheckoutStepType.paymentMethod,
        title: CheckoutStepType.paymentMethod.title,
        description: CheckoutStepType.paymentMethod.description,
        isEnabled: false,
      ),
      CheckoutStepEntity(
        type: CheckoutStepType.confirmation,
        title: CheckoutStepType.confirmation.title,
        description: CheckoutStepType.confirmation.description,
        isEnabled: false,
      ),
    ];
  }
}
