import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_helper.dart';

class CartActions extends StatelessWidget {
  final int cartItemCount;
  final Function(int) onCartItemCountChanged;

  const CartActions({
    super.key,
    required this.cartItemCount,
    required this.onCartItemCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: cartItemCount > 0
              ? () => onCartItemCountChanged(cartItemCount - 1)
              : null,
          icon: const Icon(Icons.remove_circle_outline),
          color: cartItemCount > 0 ? Colors.red : Colors.grey,
        ),
        Text(
          '$cartItemCount',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => onCartItemCountChanged(cartItemCount + 1),
          icon: const Icon(Icons.add_circle_outline),
          color: ThemeHelper.getPrimaryColorForTheme(context),
        ),
      ],
    );
  }
}
