import '../../../orders/domain/entities/order_enums.dart';
import '../entities/checkout_process_entity.dart';
import '../entities/checkout_step_entity.dart';

/// 🟦 UpdateCheckoutStepUseCase - Domain Layer
/// Single Responsibility: Update checkout step data and validation
class UpdateCheckoutStepUseCase {
  /// Update checkout process with step data
  CheckoutProcessEntity call({
    required CheckoutProcessEntity currentProcess,
    required CheckoutStepType stepType,
    required Map<String, dynamic> stepData,
  }) {
    // Update checkout data based on step type
    final updatedCheckoutData = _updateCheckoutData(
      currentProcess.checkoutData,
      stepType,
      stepData,
    );

    // Update steps based on new data
    final updatedSteps = _updateSteps(
      currentProcess.steps,
      stepType,
      updatedCheckoutData,
    );

    return currentProcess.copyWith(
      checkoutData: updatedCheckoutData,
      steps: updatedSteps,
      status: CheckoutProcessStatus.inProgress,
    );
  }

  /// Update checkout data based on step type
  CheckoutDataEntity _updateCheckoutData(
    CheckoutDataEntity currentData,
    CheckoutStepType stepType,
    Map<String, dynamic> stepData,
  ) {
    switch (stepType) {
      case CheckoutStepType.orderType:
        return currentData.copyWith(
          orderType: stepData['orderType'] as OrderType?,
        );

      case CheckoutStepType.addressSelection:
        return currentData.copyWith(
          selectedAddressId: stepData['addressId'] as int?,
          deliveryAddress: stepData['deliveryAddress'] as String?,
        );

      case CheckoutStepType.tableSelection:
        return currentData.copyWith(
          selectedTableId: stepData['tableId'] as int?,
          tableQrCode: stepData['qrCode'] as String?,
        );

      case CheckoutStepType.orderReview:
        return currentData.copyWith(
          specialInstructions: stepData['specialInstructions'] as String?,
          notes: stepData['notes'] as String?,
        );

      case CheckoutStepType.paymentMethod:
        return currentData.copyWith(
          selectedPaymentMethod: stepData['paymentMethod'] as String?,
        );

      case CheckoutStepType.confirmation:
        return currentData; // No data to update for confirmation
    }
  }

  /// Update steps based on checkout data
  List<CheckoutStepEntity> _updateSteps(
    List<CheckoutStepEntity> currentSteps,
    CheckoutStepType completedStepType,
    CheckoutDataEntity checkoutData,
  ) {
    return currentSteps.map((step) {
      // Mark completed step as completed
      if (step.type == completedStepType) {
        return step.copyWith(
          isCompleted: _isStepDataValid(step.type, checkoutData),
          isActive: false,
        );
      }

      // Enable/disable steps based on order type
      if (step.type == CheckoutStepType.addressSelection) {
        final isDelivery = checkoutData.orderType == OrderType.delivery;
        return step.copyWith(
          isEnabled: isDelivery,
          isActive:
              isDelivery && completedStepType == CheckoutStepType.orderType,
        );
      }

      if (step.type == CheckoutStepType.tableSelection) {
        final isDineIn = checkoutData.orderType == OrderType.dineIn;
        return step.copyWith(
          isEnabled: isDineIn,
          isActive: isDineIn && completedStepType == CheckoutStepType.orderType,
        );
      }

      // Enable next available step if current step is completed
      final currentStepIndex = currentSteps.indexWhere(
        (s) => s.type == completedStepType,
      );
      final stepIndex = currentSteps.indexOf(step);

      final isCurrentStepCompleted = _isStepDataValid(
        completedStepType,
        checkoutData,
      );

      // For order type step, enable the appropriate next step based on order type
      if (completedStepType == CheckoutStepType.orderType &&
          isCurrentStepCompleted) {
        if (checkoutData.orderType == OrderType.delivery &&
            step.type == CheckoutStepType.addressSelection) {
          return step.copyWith(isEnabled: true, isActive: true);
        }
        if (checkoutData.orderType == OrderType.dineIn &&
            step.type == CheckoutStepType.tableSelection) {
          return step.copyWith(isEnabled: true, isActive: true);
        }
      }

      // For other steps, enable next step if current step is completed
      if (stepIndex == currentStepIndex + 1 && step.isEnabled) {
        return step.copyWith(
          isEnabled: isCurrentStepCompleted,
          isActive: isCurrentStepCompleted,
        );
      }

      // Enable orderReview step after address/table selection is completed
      if (step.type == CheckoutStepType.orderReview) {
        final hasAddressOrTable =
            (checkoutData.orderType == OrderType.delivery &&
                checkoutData.hasDeliveryAddress) ||
            (checkoutData.orderType == OrderType.dineIn &&
                checkoutData.hasTableSelection);
        return step.copyWith(
          isEnabled: hasAddressOrTable,
          isActive:
              hasAddressOrTable &&
              (completedStepType == CheckoutStepType.addressSelection ||
                  completedStepType == CheckoutStepType.tableSelection),
        );
      }

      // Enable paymentMethod step after orderReview becomes available
      if (step.type == CheckoutStepType.paymentMethod) {
        final hasAddressOrTable =
            (checkoutData.orderType == OrderType.delivery &&
                checkoutData.hasDeliveryAddress) ||
            (checkoutData.orderType == OrderType.dineIn &&
                checkoutData.hasTableSelection);

        return step.copyWith(
          isEnabled: hasAddressOrTable,
          isActive:
              hasAddressOrTable &&
              completedStepType == CheckoutStepType.orderReview,
        );
      }

      // Enable confirmation step after paymentMethod
      if (step.type == CheckoutStepType.confirmation &&
          completedStepType == CheckoutStepType.paymentMethod &&
          isCurrentStepCompleted) {
        return step.copyWith(isEnabled: true, isActive: true);
      }

      return step;
    }).toList();
  }

  /// Validate if step data is valid
  bool _isStepDataValid(CheckoutStepType stepType, CheckoutDataEntity data) {
    switch (stepType) {
      case CheckoutStepType.orderType:
        return data.hasOrderType;

      case CheckoutStepType.addressSelection:
        return data.hasDeliveryAddress;

      case CheckoutStepType.tableSelection:
        return data.hasTableSelection;

      case CheckoutStepType.orderReview:
        return true; // Always valid (notes are optional)

      case CheckoutStepType.paymentMethod:
        return data.hasPaymentMethod;

      case CheckoutStepType.confirmation:
        return data.isValidForOrderPlacement;
    }
  }
}
