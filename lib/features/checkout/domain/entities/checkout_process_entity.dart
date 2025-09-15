import 'package:equatable/equatable.dart';

import '../../../cart/domain/entities/cart_entity.dart';
import '../../../orders/domain/entities/order_entity.dart';
import 'checkout_step_entity.dart';

/// 🟩 CheckoutProcess Entity - Domain Layer
/// Represents the entire checkout process state
class CheckoutProcessEntity extends Equatable {
  final String id;
  final CartEntity cart;
  final List<CheckoutStepEntity> steps;
  final int currentStepIndex;
  final CheckoutProcessStatus status;
  final CheckoutDataEntity checkoutData;
  final DateTime createdAt;
  final DateTime? completedAt;

  const CheckoutProcessEntity({
    required this.id,
    required this.cart,
    required this.steps,
    required this.currentStepIndex,
    required this.status,
    required this.checkoutData,
    required this.createdAt,
    this.completedAt,
  });

  /// Get current active step
  CheckoutStepEntity get currentStep => steps[currentStepIndex];

  /// Check if checkout process is completed
  bool get isCompleted => status == CheckoutProcessStatus.completed;

  /// Check if checkout process can proceed to next step
  bool get canProceedToNext {
    return currentStepIndex < steps.length - 1 && currentStep.isCompleted;
  }

  /// Check if checkout process can go back to previous step
  bool get canGoBack => currentStepIndex > 0;

  /// Get progress percentage
  double get progressPercentage {
    final completedSteps = steps.where((step) => step.isCompleted).length;
    return completedSteps / steps.length;
  }

  /// Create a copy with updated properties
  CheckoutProcessEntity copyWith({
    String? id,
    CartEntity? cart,
    List<CheckoutStepEntity>? steps,
    int? currentStepIndex,
    CheckoutProcessStatus? status,
    CheckoutDataEntity? checkoutData,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return CheckoutProcessEntity(
      id: id ?? this.id,
      cart: cart ?? this.cart,
      steps: steps ?? this.steps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      status: status ?? this.status,
      checkoutData: checkoutData ?? this.checkoutData,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    cart,
    steps,
    currentStepIndex,
    status,
    checkoutData,
    createdAt,
    completedAt,
  ];
}

/// Checkout Process Status
enum CheckoutProcessStatus {
  initialized,
  inProgress,
  completed,
  cancelled,
  failed,
}

/// 🟩 CheckoutData Entity - Domain Layer
/// Contains all user selections and inputs throughout checkout
class CheckoutDataEntity extends Equatable {
  final OrderType? orderType;
  final int? selectedAddressId;
  final String? deliveryAddress;
  final int? selectedTableId;
  final String? tableQrCode;
  final String? specialInstructions;
  final String? notes;
  final String? selectedPaymentMethod;
  final Map<String, dynamic>? additionalData;

  const CheckoutDataEntity({
    this.orderType,
    this.selectedAddressId,
    this.deliveryAddress,
    this.selectedTableId,
    this.tableQrCode,
    this.specialInstructions,
    this.notes,
    this.selectedPaymentMethod,
    this.additionalData,
  });

  /// Check if order type is selected
  bool get hasOrderType => orderType != null;

  /// Check if delivery address is selected (for delivery orders)
  bool get hasDeliveryAddress =>
      selectedAddressId != null && deliveryAddress != null;

  /// Check if table is selected (for dine-in orders)
  bool get hasTableSelection => selectedTableId != null;

  /// Check if payment method is selected
  bool get hasPaymentMethod => selectedPaymentMethod != null;

  /// Validate if all required data is present for order placement
  bool get isValidForOrderPlacement {
    if (!hasOrderType || !hasPaymentMethod) return false;

    switch (orderType!) {
      case OrderType.delivery:
        return hasDeliveryAddress;
      case OrderType.dineIn:
        return hasTableSelection;
    }
  }

  /// Create a copy with updated properties
  CheckoutDataEntity copyWith({
    OrderType? orderType,
    int? selectedAddressId,
    String? deliveryAddress,
    int? selectedTableId,
    String? tableQrCode,
    String? specialInstructions,
    String? notes,
    String? selectedPaymentMethod,
    Map<String, dynamic>? additionalData,
  }) {
    return CheckoutDataEntity(
      orderType: orderType ?? this.orderType,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      selectedTableId: selectedTableId ?? this.selectedTableId,
      tableQrCode: tableQrCode ?? this.tableQrCode,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      notes: notes ?? this.notes,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  @override
  List<Object?> get props => [
    orderType,
    selectedAddressId,
    deliveryAddress,
    selectedTableId,
    tableQrCode,
    specialInstructions,
    notes,
    selectedPaymentMethod,
    additionalData,
  ];
}
