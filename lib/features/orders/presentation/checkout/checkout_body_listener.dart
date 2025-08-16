import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../checkout/presentation/cubit/check_out_cubit.dart';
import '../../../checkout/presentation/cubit/check_out_state.dart';
import '../../../checkout/presentation/widgets/checkout_body.dart';
import 'package:restaurant_system_flutter/core/services/snack_bar_service.dart';

class CheckoutBodyListener extends StatelessWidget {
  final Widget child;
  const CheckoutBodyListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckOutCubit, CheckOutState>(
      listener: (context, state) async {
        if (state is CheckOutSuccess) {
          context.read<CartCubit>().getCartUseCase();
          SnackBarService.showSuccessSnackBar('Order placed successfully');
          await Future.delayed(const Duration(milliseconds: 300));
          if (!context.mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) =>
                  ThankYouPage(orderId: state.orderId),
            ),
          );
        } else if (state is CheckOutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: child,
    );
  }
}


