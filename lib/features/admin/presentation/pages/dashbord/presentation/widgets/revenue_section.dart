import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/theme/text_styles.dart';
import '../../../../../../../core/theme/theme_helper.dart';
import '../../../../../../../core/widgets/animated_custom_dropdown_list.dart'; // استيراد الكلاس اللي عملته
import '../../../../../../orders/domain/entities/order_entity.dart';
import 'revenue_line_chart.dart';

class RevenueSection extends StatefulWidget {
  final List<OrderEntity> orders;

  const RevenueSection({super.key, required this.orders});

  @override
  State<RevenueSection> createState() => _RevenueSectionState();
}

class _RevenueSectionState extends State<RevenueSection> {
  String selectedPeriod = 'Daily'; // الحالة الحالية للـ dropdown

  @override
  Widget build(BuildContext context) {
    final totalRevenue = _calculateTotalRevenue();

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Revenue',
                  style: AppTextStyles.senRegular14(context),
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
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ' \$${totalRevenue.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(
                  width: 150.w,
                  child: CustomAnimatedDropdown<String>(
                    items: const ['Daily', 'Weekly', 'Monthly'],
                    itemLabel: (item) => item,
                    selectedValue: selectedPeriod,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedPeriod = val;
                        });
                      }
                    },
                    hintText: 'Select period',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
          ],
        ),
        RevenueLineChart(orders: widget.orders),
      ],
    );
  }

  double _calculateTotalRevenue() {
    double total = 0.0;
    for (final order in widget.orders) {
      if (order.status == 'completed' || order.status == 'done') {
        total += order.totalAmount;
      }
    }
    return total;
  }
}
