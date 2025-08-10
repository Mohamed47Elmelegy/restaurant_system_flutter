import 'package:flutter/material.dart';
import 'package:restaurant_system_flutter/features/admin/presentation/pages/dashbord/presentation/widgets/revenue_line_chart.dart';
import '../../../../../../orders/domain/entities/order_entity.dart';

import '../../../../../../../core/theme/theme_helper.dart';

class RevenueSection extends StatelessWidget {
  final List<OrderEntity> orders;

  const RevenueSection({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final totalRevenue = _calculateTotalRevenue();

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Revenue',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              DropdownButton<String>(
                value: 'Daily',
                items: <String>['Daily', 'Weekly', 'Monthly']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
                onChanged: (String? newValue) {},
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ' \$${totalRevenue.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See Details',
                  style: TextStyle(
                    color: ThemeHelper.getPrimaryColorForTheme(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          RevenueLineChart(orders: orders),
          // Add more revenue details here
        ],
      ),
    );
  }

  /// حساب إجمالي الإيرادات من الطلبات المكتملة
  double _calculateTotalRevenue() {
    double total = 0.0;

    for (final order in orders) {
      if (order.status == 'completed' || order.status == 'done') {
        total += order.totalAmount;
      }
    }

    return total;
  }
}
