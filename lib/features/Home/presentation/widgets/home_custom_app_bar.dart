import 'package:flutter/material.dart';
import '../../../../core/utils/app_bar_helper.dart';
import 'address_selection_dialog.dart';
import 'cart_dialog.dart';

class HomeCustomAppBar extends StatelessWidget {
  final String currentAddress;
  final int cartItemCount;
  final Function(String) onAddressChanged;
  final Function(int) onCartItemCountChanged;

  const HomeCustomAppBar({
    super.key,
    required this.currentAddress,
    required this.cartItemCount,
    required this.onAddressChanged,
    required this.onCartItemCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBarHelper.createCustomAppBar(
      onMenuPressed: () => _handleMenuPressed(context),
      onAddressPressed: () => _handleAddressPressed(context),
      onCartPressed: () => _handleCartPressed(context),
      deliveryAddress: currentAddress,
      cartItemCount: cartItemCount,
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
    showDialog(
      context: context,
      builder: (context) => CartDialog(
        cartItemCount: cartItemCount,
        onCartItemCountChanged: onCartItemCountChanged,
      ),
    );
  }
}
