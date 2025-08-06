import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'menu_button.dart';
import 'address_section.dart';
import 'cart_button.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onAddressPressed;
  final VoidCallback onCartPressed;
  final String deliveryAddress;
  final int cartItemCount;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.onMenuPressed,
    required this.onAddressPressed,
    required this.onCartPressed,
    required this.deliveryAddress,
    this.cartItemCount = 0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Section - Menu/Drawer Icon
          MenuButton(onPressed: onMenuPressed),

          // Middle Section - Delivery Address
          Expanded(
            child: AddressSection(
              address: deliveryAddress,
              onPressed: onAddressPressed,
            ),
          ),

          // Right Section - Shopping Cart with Badge
          CartButton(onPressed: onCartPressed, itemCount: cartItemCount),
        ],
      ),
    );
  }
}
