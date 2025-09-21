import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_helper.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';

class CartAppBar extends StatelessWidget {
  const CartAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeHelper.getAppBarColor(context),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios,
                color: ThemeHelper.getPrimaryTextColor(context),
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Cart title
          Text(
            'Cart',
            style: TextStyle(
              color: ThemeHelper.getPrimaryTextColor(context),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          // Total items badge
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.cart.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeHelper.getPrimaryColorForTheme(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total Products  ${state.cart.items.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
