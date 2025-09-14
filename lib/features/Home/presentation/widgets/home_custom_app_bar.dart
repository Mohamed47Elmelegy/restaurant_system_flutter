import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_bar_helper.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import 'address_selection_dialog.dart';

class HomeCustomAppBar extends StatelessWidget {
  final String currentAddress;
  final Function(String) onAddressChanged;

  const HomeCustomAppBar({
    super.key,
    required this.currentAddress,
    required this.onAddressChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        // Calculate cart item count from cart state
        int cartItemCount = 0;
        if (cartState is CartLoaded) {
          cartItemCount = cartState.cart.uniqueItemsCount;
        }

        return AppBarHelper.createCustomAppBar(
          onMenuPressed: () => _handleMenuPressed(context),
          onAddressPressed: () => _handleAddressPressed(context),
          onCartPressed: () => _handleCartPressed(context),
          deliveryAddress: currentAddress,
          cartItemCount: cartItemCount,
        );
      },
    );
  }

  void _handleMenuPressed(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void _handleAddressPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddressSelectionDialog(
        currentAddress: currentAddress,
        onAddressSelected: onAddressChanged,
      ),
    );
  }

  void _handleCartPressed(BuildContext context) {
    // Navigate to cart page using named route
    Navigator.of(context).pushNamed(AppRoutes.cart);
  }
}
