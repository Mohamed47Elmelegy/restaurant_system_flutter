import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/order_editing_service.dart';
import '../../domain/entities/order_entity.dart';
import 'order_card_widget.dart';
import 'orders_empty_state.dart';

/// List view for displaying orders with pull-to-refresh
class OrdersListView extends StatelessWidget {
  final List<OrderEntity> orders;
  final String tabName;
  final VoidCallback onRefresh;
  final Function(BuildContext, OrderEntity) onOrderTap;
  final Function(BuildContext, OrderEntity) onOrderEdit;

  const OrdersListView({
    super.key,
    required this.orders,
    required this.tabName,
    required this.onRefresh,
    required this.onOrderTap,
    required this.onOrderEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return OrdersEmptyState(tabName: tabName);
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCardWidget(
            order: order,
            onTap: () => onOrderTap(context, order),
            onEdit: OrderEditingService.instance.canEditOrder(order)
                ? () => onOrderEdit(context, order)
                : null,
          );
        },
      ),
    );
  }
}
