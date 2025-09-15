import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../orders/data/models/order_item_model.dart';
import '../../../orders/data/models/place_order_request_model.dart';
import '../../domain/entities/checkout_process_entity.dart';
import '../../domain/usecases/check_out_place_order_usecase.dart';
import '../../domain/usecases/initialize_checkout_usecase.dart';
import '../../domain/usecases/navigate_checkout_usecase.dart';
import '../../domain/usecases/update_checkout_step_usecase.dart';
import 'checkout_process_event.dart';
import 'checkout_process_state.dart';

/// 🟦 CheckoutProcessBloc - Following SOLID principles
/// Single Responsibility: Manage checkout process state
/// Dependency Inversion: Depends on use cases, not implementations
class CheckoutProcessBloc
    extends Bloc<CheckoutProcessEvent, CheckoutProcessState> {
  final InitializeCheckoutUseCase _initializeCheckoutUseCase;
  final UpdateCheckoutStepUseCase _updateCheckoutStepUseCase;
  final NavigateCheckoutUseCase _navigateCheckoutUseCase;
  final CheckOutPlaceOrderUseCase _placeOrderUseCase;

  CheckoutProcessEntity? _currentProcess;

  CheckoutProcessBloc({
    required InitializeCheckoutUseCase initializeCheckoutUseCase,
    required UpdateCheckoutStepUseCase updateCheckoutStepUseCase,
    required NavigateCheckoutUseCase navigateCheckoutUseCase,
    required CheckOutPlaceOrderUseCase placeOrderUseCase,
  }) : _initializeCheckoutUseCase = initializeCheckoutUseCase,
       _updateCheckoutStepUseCase = updateCheckoutStepUseCase,
       _navigateCheckoutUseCase = navigateCheckoutUseCase,
       _placeOrderUseCase = placeOrderUseCase,
       super(const CheckoutProcessInitial()) {
    on<InitializeCheckout>(_onInitializeCheckout);
    on<UpdateCheckoutStep>(_onUpdateCheckoutStep);
    on<UpdateCheckoutStepAndProceed>(_onUpdateCheckoutStepAndProceed);
    on<NavigateToNextStep>(_onNavigateToNextStep);
    on<NavigateToPreviousStep>(_onNavigateToPreviousStep);
    on<NavigateToStep>(_onNavigateToStep);
    on<CompleteCheckout>(_onCompleteCheckout);
    on<CancelCheckout>(_onCancelCheckout);
    on<ResetCheckout>(_onResetCheckout);
  }

  /// Initialize checkout process
  Future<void> _onInitializeCheckout(
    InitializeCheckout event,
    Emitter<CheckoutProcessState> emit,
  ) async {
    try {
      log('🔄 CheckoutProcessBloc: Initializing checkout process');

      emit(const CheckoutProcessLoading(message: 'إعداد عملية الشراء...'));

      _currentProcess = _initializeCheckoutUseCase(event.cart);

      log('✅ CheckoutProcessBloc: Checkout process initialized successfully');

      emit(CheckoutProcessActive(process: _currentProcess!));
    } catch (e) {
      log('❌ CheckoutProcessBloc: Failed to initialize checkout - $e');
      emit(CheckoutProcessError(message: 'فشل في إعداد عملية الشراء: $e'));
    }
  }

  /// Update checkout step
  Future<void> _onUpdateCheckoutStep(
    UpdateCheckoutStep event,
    Emitter<CheckoutProcessState> emit,
  ) async {
    if (_currentProcess == null) {
      emit(
        const CheckoutProcessError(message: 'لم يتم إعداد عملية الشراء بعد'),
      );
      return;
    }

    try {
      log('🔄 CheckoutProcessBloc: Updating step ${event.stepType}');

      _currentProcess = _updateCheckoutStepUseCase(
        currentProcess: _currentProcess!,
        stepType: event.stepType,
        stepData: event.stepData,
      );

      log('✅ CheckoutProcessBloc: Step updated successfully');

      emit(
        CheckoutStepUpdated(
          process: _currentProcess!,
          message: 'تم تحديث الخطوة بنجاح',
        ),
      );
    } catch (e) {
      log('❌ CheckoutProcessBloc: Failed to update step - $e');
      emit(
        CheckoutProcessError(
          message: 'فشل في تحديث الخطوة: $e',
          process: _currentProcess,
        ),
      );
    }
  }

  /// Update checkout step and automatically proceed to next step
  Future<void> _onUpdateCheckoutStepAndProceed(
    UpdateCheckoutStepAndProceed event,
    Emitter<CheckoutProcessState> emit,
  ) async {
    if (_currentProcess == null) {
      emit(
        const CheckoutProcessError(message: 'لم يتم إعداد عملية الشراء بعد'),
      );
      return;
    }

    try {
      log('🔄 CheckoutProcessBloc: Updating step ${event.stepType} and proceeding');

      // First, update the step
      _currentProcess = _updateCheckoutStepUseCase(
        currentProcess: _currentProcess!,
        stepType: event.stepType,
        stepData: event.stepData,
      );

      // Then, navigate to next step if possible
      _currentProcess = _navigateCheckoutUseCase.goToNextStep(_currentProcess!);

      log('✅ CheckoutProcessBloc: Step updated and navigation completed');

      emit(CheckoutNavigationCompleted(process: _currentProcess!));
    } catch (e) {
      log('❌ CheckoutProcessBloc: Failed to update step and proceed - $e');
      emit(
        CheckoutProcessError(
          message: 'فشل في تحديث الخطوة والانتقال: $e',
          process: _currentProcess,
        ),
      );
    }
  }

  /// Navigate to next step
  Future<void> _onNavigateToNextStep(
    NavigateToNextStep event,
    Emitter<CheckoutProcessState> emit,
  ) async {
    if (_currentProcess == null) {
      emit(
        const CheckoutProcessError(message: 'لم يتم إعداد عملية الشراء بعد'),
      );
      return;
    }

    try {
      log('🔄 CheckoutProcessBloc: Navigating to next step');

      _currentProcess = _navigateCheckoutUseCase.goToNextStep(_currentProcess!);

      log('✅ CheckoutProcessBloc: Navigation completed successfully');

      emit(CheckoutNavigationCompleted(process: _currentProcess!));
    } catch (e) {
      log('❌ CheckoutProcessBloc: Failed to navigate to next step - $e');
      emit(
        CheckoutProcessError(
          message: 'فشل في الانتقال للخطوة التالية: $e',
          process: _currentProcess,
        ),
      );
    }
  }

  /// Navigate to previous step
  Future<void> _onNavigateToPreviousStep(
    NavigateToPreviousStep event,
    Emitter<CheckoutProcessState> emit,
  ) async {
    if (_currentProcess == null) {
      emit(
        const CheckoutProcessError(message: 'لم يتم إعداد عملية الشراء بعد'),
      );
      return;
    }

    try {
      log('🔄 CheckoutProcessBloc: Navigating to previous step');

      _currentProcess = _navigateCheckoutUseCase.goToPreviousStep(
        _currentProcess!,
      );

      log('✅ CheckoutProcessBloc: Navigation completed successfully');

      emit(CheckoutNavigationCompleted(process: _currentProcess!));
    } catch (e) {
      log('❌ CheckoutProcessBloc: Failed to navigate to previous step - $e');
      emit(
        CheckoutProcessError(
          message: 'فشل في العودة للخطوة السابقة: $e',
          process: _currentProcess,
        ),
      );
    }
  }

  /// Navigate to specific step
  Future<void> _onNavigateToStep(
    NavigateToStep event,
    Emitter<CheckoutProcessState> emit,
  ) async {
    if (_currentProcess == null) {
      emit(
        const CheckoutProcessError(message: 'لم يتم إعداد عملية الشراء بعد'),
      );
      return;
    }

    try {
      log('🔄 CheckoutProcessBloc: Navigating to step ${event.stepIndex}');

      _currentProcess = _navigateCheckoutUseCase.goToStep(
        _currentProcess!,
        event.stepIndex,
      );

      log('✅ CheckoutProcessBloc: Navigation completed successfully');

      emit(CheckoutNavigationCompleted(process: _currentProcess!));
    } catch (e) {
      log('❌ CheckoutProcessBloc: Failed to navigate to step - $e');
      emit(
        CheckoutProcessError(
          message: 'فشل في الانتقال للخطوة المحددة: $e',
          process: _currentProcess,
        ),
      );
    }
  }

  /// Complete checkout and place order
  Future<void> _onCompleteCheckout(
    CompleteCheckout event,
    Emitter<CheckoutProcessState> emit,
  ) async {
    if (_currentProcess == null) {
      emit(
        const CheckoutProcessError(message: 'لم يتم إعداد عملية الشراء بعد'),
      );
      return;
    }

    if (!_currentProcess!.checkoutData.isValidForOrderPlacement) {
      emit(
        CheckoutProcessError(
          message: 'يرجى إكمال جميع الخطوات المطلوبة',
          process: _currentProcess,
        ),
      );
      return;
    }

    try {
      log('🔄 CheckoutProcessBloc: Completing checkout and placing order');

      emit(const CheckoutProcessLoading(message: 'جارٍ إنشاء الطلب...'));

      // Convert cart items to order items
      final items = _currentProcess!.cart.items
          .map(
            (item) => OrderItemModel.fromCartItem(
              menuItemId: int.parse(item.product.id),
              name: item.product.name,
              description: item.product.description,
              image: item.product.imageUrl,
              unitPrice: item.unitPrice,
              quantity: item.quantity,
              specialInstructions: null,
            ),
          )
          .toList();

      // Create order request
      final request = PlaceOrderRequestModel(
        type: _currentProcess!.checkoutData.orderType!,
        tableId: _currentProcess!.checkoutData.selectedTableId,
        addressId: _currentProcess!.checkoutData.selectedAddressId,
        deliveryAddress: _currentProcess!.checkoutData.deliveryAddress,
        specialInstructions: _currentProcess!.checkoutData.specialInstructions,
        notes: _currentProcess!.checkoutData.notes,
      );

      // Place order
      final order = await _placeOrderUseCase(request, items);

      // Update process as completed
      _currentProcess = _currentProcess!.copyWith(
        status: CheckoutProcessStatus.completed,
        completedAt: DateTime.now(),
      );

      log('✅ CheckoutProcessBloc: Order placed successfully - ID: ${order.id}');

      emit(CheckoutCompleted(order: order, process: _currentProcess!));
    } catch (e) {
      log('❌ CheckoutProcessBloc: Failed to complete checkout - $e');
      emit(
        CheckoutProcessError(
          message: 'فشل في إنشاء الطلب: $e',
          process: _currentProcess,
        ),
      );
    }
  }

  /// Cancel checkout
  Future<void> _onCancelCheckout(
    CancelCheckout event,
    Emitter<CheckoutProcessState> emit,
  ) async {
    log('🔄 CheckoutProcessBloc: Cancelling checkout');

    if (_currentProcess != null) {
      _currentProcess = _currentProcess!.copyWith(
        status: CheckoutProcessStatus.cancelled,
      );
    }

    emit(CheckoutProcessCancelled(process: _currentProcess));
  }

  /// Reset checkout
  Future<void> _onResetCheckout(
    ResetCheckout event,
    Emitter<CheckoutProcessState> emit,
  ) async {
    log('🔄 CheckoutProcessBloc: Resetting checkout');

    _currentProcess = null;
    emit(const CheckoutProcessInitial());
  }
}
