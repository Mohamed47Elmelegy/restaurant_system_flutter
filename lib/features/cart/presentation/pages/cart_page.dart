import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/snack_bar_service.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/empty_cart_widget.dart';
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
      backgroundColor: const Color(
        0xFF2A2A3A,
      ), // Dark background like in the image
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
                child: BlocBuilder<CartCubit, CartState>(
                  buildWhen: (previous, current) {
                    // لا تعيد بناء القائمة كلها إذا كان التغيير فقط في كمية عنصر
                    return current is! CartItemQuantityUpdated;
                  },
                  builder: (context, state) {
                    if (state is CartLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.lightPrimary,
                        ),
                      );
                    }

                    if (state is CartError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: AppColors.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'حدث خطأ في تحميل السلة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<CartCubit>().add(LoadCart());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.lightPrimary,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is CartLoaded) {
                      if (state.cart.isEmpty) {
                        return const EmptyCartWidget();
                      }

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

                    return const EmptyCartWidget();
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
