import 'package:flutter/material.dart';
import 'package:restaurant_system_flutter/features/admin/dashbord/presentation/widgets/revenue_line_chart.dart';

class RevenueSection extends StatelessWidget {
  const RevenueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
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
              Text(' 2,241', style: Theme.of(context).textTheme.headlineMedium),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See Details',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          RevenueLineChart(),
          // Add more revenue details here
        ],
      ),
    );
  }
}
