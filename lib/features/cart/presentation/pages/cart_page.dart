import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/snack_bar_service.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/widgets/common_empty_state.dart';
import '../../../../core/widgets/common_error_state.dart';
import '../../../../core/widgets/common_state_builder.dart';
import '../../../orders/domain/entities/order_enums.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_summary_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: BlocListener<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartItemAdded) {
              SnackBarService.showSuccessMessage(
                context,
                state.message,
                title: 'تم بنجاح',
              );
            } else if (state is CartItemUpdated) {
              SnackBarService.showSuccessMessage(
                context,
                state.message,
                title: 'تم التحديث',
              );
            } else if (state is CartItemRemoved) {
              SnackBarService.showSuccessMessage(
                context,
                state.message,
                title: 'تم الحذف',
              );
            } else if (state is CartCleared) {
              SnackBarService.showSuccessMessage(
                context,
                state.message,
                title: 'تم التفريغ',
              );
            } else if (state is CartError) {
              SnackBarService.showErrorMessage(context, state.message);
            } else if (state is CartValidationError) {
              SnackBarService.showWarningMessage(context, state.message);
            } else if (state is CartAuthError) {
              SnackBarService.showErrorMessage(context, state.message);
            } else if (state is CartNetworkError) {
              SnackBarService.showErrorMessage(context, state.message);
            }
          },
          child: Column(
            children: [
              const CartAppBar(),
              Expanded(
                child: CommonStateBuilder<CartCubit, CartState>(
                  buildWhen: (previous, current) {
                    // لا تعيد بناء القائمة كلها إذا كان التغيير فقط في كمية عنصر
                    return current is! CartItemQuantityUpdated;
                  },
                  isLoading: (state) => state is CartLoading,
                  hasError: (state) =>
                      state is CartError ||
                      state is CartValidationError ||
                      state is CartAuthError ||
                      state is CartNetworkError,
                  isEmpty: (state) => state is CartLoaded && state.cart.isEmpty,
                  getErrorMessage: (state) {
                    if (state is CartError) return state.message;
                    if (state is CartValidationError) return state.message;
                    if (state is CartAuthError) return state.message;
                    if (state is CartNetworkError) return state.message;
                    return 'حدث خطأ غير متوقع';
                  },
                  loadingMessage: 'جاري تحميل السلة...',
                  errorBuilder: (context, message) => CommonErrorState.general(
                    message: message,
                    onRetry: () => context.read<CartCubit>().add(LoadCart()),
                  ),
                  emptyBuilder: (context) => CommonEmptyState.cart(
                    onActionPressed: () {
                      // Navigate to menu
                      Navigator.pop(context);
                    },
                  ),
                  builder: (context, state) {
                    if (state is CartLoaded) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: state.cart.items.length,
                              itemBuilder: (context, index) {
                                final item = state.cart.items[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: CartItemWidget(
                                    cartItem: item,
                                    onRemove: () {
                                      context.read<CartCubit>().add(
                                        RemoveCartItem(cartItemId: item.id),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          CartSummaryWidget(
                            cart: state.cart,
                            orderType: OrderType.dineIn,
                          ),
                        ],
                      );
                    }
                    return const CommonEmptyState.cart();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
