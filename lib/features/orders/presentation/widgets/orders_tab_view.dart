import 'package:flutter/material.dart';

import '../../../../core/constants/order_tab_constants.dart';
import '../../../../core/utils/order_utils.dart';
import '../../domain/entities/order_entity.dart';
import 'orders_list_view.dart';

/// Tab view widget for displaying categorized orders
class OrdersTabView extends StatelessWidget {
  final TabController tabController;
  final List<OrderEntity> orders;
  final VoidCallback onRefresh;
  final Function(BuildContext, OrderEntity) onOrderTap;
  final Function(BuildContext, OrderEntity) onOrderEdit;

  const OrdersTabView({
    super.key,
    required this.tabController,
    required this.orders,
    required this.onRefresh,
    required this.onOrderTap,
    required this.onOrderEdit,
  });

  @override
  Widget build(BuildContext context) {
    final groupedOrders = OrderUtils.groupOrdersByStatusCategory<OrderEntity>(
      orders,
      (order) => order.status,
      (order) => order.type,
    );

    return TabBarView(
      controller: tabController,
      children: [
        OrdersListView(
          orders: groupedOrders['active'] ?? [],
          tabName: OrderTabConstants.tabLabels[0],
          onRefresh: onRefresh,
          onOrderTap: onOrderTap,
          onOrderEdit: onOrderEdit,
        ),
        OrdersListView(
          orders: groupedOrders['completed'] ?? [],
          tabName: OrderTabConstants.tabLabels[1],
          onRefresh: onRefresh,
          onOrderTap: onOrderTap,
          onOrderEdit: onOrderEdit,
        ),
        OrdersListView(
          orders: groupedOrders['cancelled'] ?? [],
          tabName: OrderTabConstants.tabLabels[2],
          onRefresh: onRefresh,
          onOrderTap: onOrderTap,
          onOrderEdit: onOrderEdit,
        ),
      ],
    );
  }
}
