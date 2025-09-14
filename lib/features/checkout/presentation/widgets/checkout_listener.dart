import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_system_flutter/core/services/snack_bar_service.dart';

import '../../../address/presentation/cubit/address_cubit.dart';
import '../../../address/presentation/cubit/address_state.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../orders/presentation/cubit/table_cubit.dart';
import '../cubit/check_out_cubit.dart';
import '../cubit/check_out_state.dart';
import 'thank_you_page.dart';

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
          String? deliveryAddress;
          String? tableInfo;
          String? orderType;
          // Determine order type from state or context
          // Try to get from CheckoutBody or pass as argument if possible
          // For now, try to get from ModalRoute arguments
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          if (args != null && args['orderType'] != null) {
            orderType = args['orderType'].toString();
          }
          if (orderType == 'delivery') {
            final addressState = context.read<AddressCubit>().state;
            if (addressState is AddressLoaded &&
                addressState.addresses.isNotEmpty) {
              deliveryAddress = addressState.addresses
                  .firstWhere(
                    (a) => a.isDefault,
                    orElse: () => addressState.addresses.first,
                  )
                  .fullAddress;
            }
          } else if (orderType == 'dineIn') {
            final tableState = context.read<TableCubit>().state;
            if (tableState is TableLoaded) {
              tableInfo =
                  'Table #${tableState.table.number} - ${tableState.table.name}';
            } else if (args != null && args['tableId'] != null) {
              tableInfo = 'Table #${args['tableId']}';
            }
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ThankYouPage(
                orderId: state.orderId,
                qrCode: state.qrCode,
                deliveryAddress: deliveryAddress,
                tableInfo: tableInfo,
                orderType: orderType,
              ),
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
