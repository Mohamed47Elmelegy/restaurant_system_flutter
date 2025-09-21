import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/models/order_item_model.dart';
import '../../data/models/place_order_request_model.dart';
import '../../domain/usecases/place_order_usecase.dart';
import '../cubit/order_cubit.dart';

class OrderPage extends StatelessWidget {
  final List<OrderItemModel> cartItems;
  final PlaceOrderRequestModel request;

  const OrderPage({super.key, required this.cartItems, required this.request});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderCubit(getIt<PlaceOrderUseCase>()),
      child: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order placed successfully!')),
            );
            // يمكنك التنقل لصفحة الشكر هنا
          } else if (state is OrderFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(title: const Text('Place Order')),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<OrderCubit>().placeOrder(request, cartItems);
                },
                child: const Text('Place Order'),
              ),
            ),
          );
        },
      ),
    );
  }
}
