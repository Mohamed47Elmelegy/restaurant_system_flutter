import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/utils/cubit_initializer.dart';
import '../../../address/presentation/cubit/address_cubit.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/cubit/table_cubit.dart';
import '../../domain/entities/checkout_step_entity.dart';
import '../../domain/usecases/check_out_place_order_usecase.dart';
import '../../domain/usecases/initialize_checkout_usecase.dart';
import '../../domain/usecases/navigate_checkout_usecase.dart';
import '../../domain/usecases/update_checkout_step_usecase.dart';
import '../bloc/checkout_process_bloc.dart';
import '../bloc/checkout_process_event.dart';
import '../bloc/checkout_process_state.dart';
import '../widgets/checkout_progress_indicator.dart';
import '../widgets/checkout_step_wrapper.dart';
import '../widgets/steps/address_selection_step.dart';
import '../widgets/steps/order_confirmation_step.dart';
import '../widgets/steps/order_review_step.dart';
import '../widgets/steps/order_type_step.dart';
import '../widgets/steps/payment_method_step.dart';
import '../widgets/steps/table_selection_step.dart';

/// 🟦 ModernCheckoutPage - Modern step-based checkout
class ModernCheckoutPage extends StatelessWidget {
  final CartEntity cart;

  const ModernCheckoutPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CheckoutProcessBloc(
            initializeCheckoutUseCase: getIt<InitializeCheckoutUseCase>(),
            updateCheckoutStepUseCase: getIt<UpdateCheckoutStepUseCase>(),
            navigateCheckoutUseCase: getIt<NavigateCheckoutUseCase>(),
            placeOrderUseCase: getIt<CheckOutPlaceOrderUseCase>(),
          )..add(InitializeCheckout(cart: cart)),
        ),
        BlocProvider<AddressCubit>.value(
          value: CubitInitializer.getAddressCubitWithData(),
        ),
        BlocProvider<TableCubit>(create: (context) => getIt<TableCubit>()),
        BlocProvider<CartCubit>.value(
          value: CubitInitializer.getCartCubitWithData(),
        ),
      ],
      child: const _ModernCheckoutView(),
    );
  }
}

class _ModernCheckoutView extends StatelessWidget {
  const _ModernCheckoutView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: _buildAppBar(context),
      body: BlocConsumer<CheckoutProcessBloc, CheckoutProcessState>(
        listener: (context, state) {
          if (state is CheckoutCompleted) {
            _showOrderSuccessDialog(
              context,
              state.order,
              context.read<CartCubit>(),
            );
          } else if (state is CheckoutProcessError) {
            _showErrorSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is CheckoutProcessLoading) {
            return _buildLoadingState(context, state.message);
          }

          if (state is CheckoutProcessActive ||
              state is CheckoutStepUpdated ||
              state is CheckoutNavigationCompleted) {
            final process = state is CheckoutProcessActive
                ? state.process
                : state is CheckoutStepUpdated
                ? state.process
                : (state as CheckoutNavigationCompleted).process;

            return Column(
              children: [
                CheckoutProgressIndicator(process: process),
                Expanded(child: _buildCurrentStep(context, process)),
              ],
            );
          }

          if (state is CheckoutProcessError) {
            return _buildErrorState(context, state.message);
          }

          return _buildInitialState(context);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeHelper.getSurfaceColor(context),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'إتمام الطلب',
        style: AppTextStyles.senBold18(
          context,
        ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
      ),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back_ios,
          color: ThemeHelper.getPrimaryTextColor(context),
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.lightPrimary),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppTextStyles.senMedium16(
                context,
              ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              'حدث خطأ',
              style: AppTextStyles.senBold18(
                context,
              ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPrimary,
              ),
              child: Text(
                'العودة',
                style: AppTextStyles.senMedium16(
                  context,
                ).copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80.sp,
            color: ThemeHelper.getSecondaryTextColor(context),
          ),
          SizedBox(height: 16.h),
          Text(
            'جارٍ إعداد عملية الشراء...',
            style: AppTextStyles.senMedium16(
              context,
            ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context, dynamic process) {
    final currentStep = process.currentStep;
    final isLoading =
        context.read<CheckoutProcessBloc>().state is CheckoutProcessLoading;

    return CheckoutStepWrapper(
      step: currentStep,
      isLoading: isLoading,
      onNext: () => _handleNextStep(context, currentStep),
      onPrevious: process.canGoBack
          ? () => context.read<CheckoutProcessBloc>().add(
              const NavigateToPreviousStep(),
            )
          : null,
      nextButtonText: _getNextButtonText(currentStep.type),
      child: _buildStepContent(context, currentStep),
    );
  }

  Widget _buildStepContent(BuildContext context, dynamic step) {
    switch (step.type) {
      case CheckoutStepType.orderType:
        return OrderTypeStep(
          selectedOrderType: step.data?['orderType'],
          onOrderTypeSelected: (orderType) {
            context.read<CheckoutProcessBloc>().add(
              UpdateCheckoutStep(
                stepType: CheckoutStepType.orderType,
                stepData: {'orderType': orderType},
              ),
            );
          },
          onDineInSelected: () {
            // For dine-in orders, navigate directly to QR scanner
            _navigateToQRScanner(context);
          },
        );

      case CheckoutStepType.addressSelection:
        return AddressSelectionStep(
          selectedAddressId: step.data?['addressId'],
          onAddressSelected: (addressData) {
            context.read<CheckoutProcessBloc>().add(
              UpdateCheckoutStep(
                stepType: CheckoutStepType.addressSelection,
                stepData: addressData,
              ),
            );
          },
        );

      case CheckoutStepType.tableSelection:
        // Get the cart from the checkout process
        final process = _getProcessFromState(context);
        return TableSelectionStep(
          cart: process?.cart ?? _getCurrentCart(context),
          selectedTableId: step.data?['tableId'],
          tableQrCode: step.data?['qrCode'],
          onTableSelected: (tableData) {
            context.read<CheckoutProcessBloc>().add(
              UpdateCheckoutStep(
                stepType: CheckoutStepType.tableSelection,
                stepData: tableData,
              ),
            );
          },
        );

      case CheckoutStepType.orderReview:
        // Get the cart from the checkout process
        final process = _getProcessFromState(context);
        if (process?.cart == null) {
          return Center(
            child: Text(
              'خطأ في تحميل بيانات السلة',
              style: AppTextStyles.senMedium16(
                context,
              ).copyWith(color: Colors.red),
            ),
          );
        }
        // Auto-update orderReview step to mark it as accessible
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (step.data?['_autoUpdated'] != true) {
            context.read<CheckoutProcessBloc>().add(
              UpdateCheckoutStep(
                stepType: CheckoutStepType.orderReview,
                stepData: {
                  'notes': step.data?['notes'] ?? '',
                  '_autoUpdated': true,
                },
              ),
            );
          }
        });

        return OrderReviewStep(
          cart: process!.cart,
          notes: step.data?['notes'],
          onNotesChanged: (notes) {
            context.read<CheckoutProcessBloc>().add(
              UpdateCheckoutStep(
                stepType: CheckoutStepType.orderReview,
                stepData: {'notes': notes, '_autoUpdated': true},
              ),
            );
          },
        );

      case CheckoutStepType.paymentMethod:
        return PaymentMethodStep(
          selectedPaymentMethod: step.data?['paymentMethod'],
          onPaymentMethodSelected: (paymentMethod) {
            context.read<CheckoutProcessBloc>().add(
              UpdateCheckoutStepAndProceed(
                stepType: CheckoutStepType.paymentMethod,
                stepData: {'paymentMethod': paymentMethod},
              ),
            );
          },
        );

      case CheckoutStepType.confirmation:
        // Get the cart from the checkout process
        final process = _getProcessFromState(context);
        if (process == null) {
          return Center(
            child: Text(
              'خطأ في تحميل بيانات الطلب',
              style: AppTextStyles.senMedium16(
                context,
              ).copyWith(color: Colors.red),
            ),
          );
        }
        return OrderConfirmationStep(process: process);

      // Add other step types here
      default:
        return Center(
          child: Text(
            'هذه الخطوة قيد التطوير...',
            style: AppTextStyles.senMedium16(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
          ),
        );
    }
  }

  void _handleNextStep(BuildContext context, dynamic currentStep) {
    if (currentStep.type == CheckoutStepType.confirmation) {
      // Complete checkout
      context.read<CheckoutProcessBloc>().add(const CompleteCheckout());
    } else {
      // Navigate to next step
      context.read<CheckoutProcessBloc>().add(const NavigateToNextStep());
    }
  }

  String _getNextButtonText(CheckoutStepType stepType) {
    switch (stepType) {
      case CheckoutStepType.confirmation:
        return 'تأكيد الطلب';
      case CheckoutStepType.orderReview:
        return 'متابعة للدفع';
      default:
        return 'التالي';
    }
  }

  void _showOrderSuccessDialog(
    BuildContext context,
    OrderEntity order,
    CartCubit cartCubit,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64.sp),
            SizedBox(height: 16.h),
            Text(
              'تم إنشاء الطلب بنجاح!',
              style: AppTextStyles.senBold18(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'رقم الطلب: #${order.id}',
              style: AppTextStyles.senMedium16(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Clear cart after successful order
              cartCubit.add(ClearCart());

              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close checkout page

              // Navigate to home and clear stack
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
            ),
            child: Text(
              'حسناً',
              style: AppTextStyles.senMedium16(
                context,
              ).copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  /// Helper method to get current process from state
  dynamic _getProcessFromState(BuildContext context) {
    final state = context.read<CheckoutProcessBloc>().state;
    if (state is CheckoutProcessActive) {
      return state.process;
    } else if (state is CheckoutStepUpdated) {
      return state.process;
    } else if (state is CheckoutNavigationCompleted) {
      return state.process;
    }
    return null;
  }

  /// Helper method to get current cart
  CartEntity _getCurrentCart(BuildContext context) {
    final process = _getProcessFromState(context);
    if (process?.cart != null) {
      return process!.cart;
    }
    // Fallback: try to get cart from the parent widget
    final parentWidget = context
        .findAncestorWidgetOfExactType<ModernCheckoutPage>();
    if (parentWidget != null) {
      return parentWidget.cart;
    }
    // This should not happen, but provide a safe fallback
    throw Exception('Cart not found in checkout process');
  }

  /// Navigate to QR scanner for dine-in orders
  void _navigateToQRScanner(BuildContext context) {
    final process = _getProcessFromState(context);
    Navigator.of(context)
        .pushNamed(
          AppRoutes.qrScanner,
          arguments: {'cart': process?.cart ?? _getCurrentCart(context)},
        )
        .then((result) {
          if (result != null && result is Map<String, dynamic>) {
            final qrCode = result['qrCode'] as String?;
            final tableId = result['tableId'] as int?;
            if (qrCode != null) {
              // Update checkout step with QR code and table info
              context.read<CheckoutProcessBloc>().add(
                UpdateCheckoutStep(
                  stepType: CheckoutStepType.tableSelection,
                  stepData: {'qrCode': qrCode, 'tableId': tableId},
                ),
              );
              // Navigate to next step (order review) after QR scanning
              context.read<CheckoutProcessBloc>().add(
                const NavigateToNextStep(),
              );
            }
          }
        });
  }
}
