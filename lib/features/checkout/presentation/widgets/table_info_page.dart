import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/domain/entities/table_entity.dart';
import '../../../orders/presentation/cubit/table_cubit.dart';

class TableInfoPage extends StatelessWidget {
  final String qrCode;
  final CartEntity cart;
  final TableEntity? table;
  const TableInfoPage({
    super.key,
    required this.qrCode,
    required this.cart,
    this.table,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<TableCubit>()..getTableByQr(qrCode),
      child: Scaffold(
        appBar: AppBar(title: const Text('Table Info')),
        body: BlocConsumer<TableCubit, TableState>(
          listener: (context, state) {
            if (state is TableOccupied) {
              final tableId = (context.read<TableCubit>().state is TableLoaded)
                  ? (context.read<TableCubit>().state as TableLoaded).table.id
                  : null;
              if (tableId != null) {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.checkout,
                  arguments: {
                    'cart': cart,
                    'orderType': OrderType.dineIn,
                    'tableId': tableId,
                    'table': table,
                  },
                );
              }
            }
          },
          builder: (context, state) {
            if (state is TableLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TableError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is TableLoaded) {
              final table = state.table;
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Table Number: ${table.number}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Name: ${table.name}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Location: ${table.location ?? "-"}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: ${table.isAvailable ? "Available" : "Occupied"}',
                      style: TextStyle(
                        fontSize: 16,
                        color: table.isAvailable ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: table.isAvailable
                          ? () =>
                                context.read<TableCubit>().occupyTable(table.id)
                          : null,
                      child: const Text('Confirm & Occupy Table'),
                    ),
                  ],
                ),
              );
            } else if (state is TableOccupying) {
              return const Center(child: CircularProgressIndicator());
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
