import 'package:flutter/material.dart';

import '../../../../core/widgets/skeletons/skeletons.dart';
import '../../domain/entities/order_entity.dart';

/// Loading state widget with skeleton placeholders
class OrdersLoadingState extends StatelessWidget {
  final TabController tabController;
  final VoidCallback onRefresh;
  final Function(BuildContext, OrderEntity) onOrderTap;
  final Function(BuildContext, OrderEntity) onOrderEdit;

  const OrdersLoadingState({
    super.key,
    required this.tabController,
    required this.onRefresh,
    required this.onOrderTap,
    required this.onOrderEdit,
  });

  @override
  Widget build(BuildContext context) {
    return OrdersSkeleton(tabController: tabController);
  }
}
