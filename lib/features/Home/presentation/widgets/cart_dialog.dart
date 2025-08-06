import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'cart_actions.dart';

class CartDialog extends StatelessWidget {
  final int cartItemCount;
  final Function(int) onCartItemCountChanged;

  const CartDialog({
    super.key,
    required this.cartItemCount,
    required this.onCartItemCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Shopping Cart'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('You have $cartItemCount items in your cart'),
          if (cartItemCount > 0) ...[
            SizedBox(height: 16.h),
            CartActions(
              cartItemCount: cartItemCount,
              onCartItemCountChanged: onCartItemCountChanged,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Continue Shopping'),
        ),
        if (cartItemCount > 0)
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Checkout'),
          ),
      ],
    );
  }
}
