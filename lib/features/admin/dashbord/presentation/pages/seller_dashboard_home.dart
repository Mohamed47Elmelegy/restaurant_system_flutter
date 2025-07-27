import 'package:flutter/material.dart';
import '../../../../../core/theme/app_bar_helper.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../widgets/orders_section.dart';
import '../widgets/popular_items_section.dart';
import '../widgets/revenue_section.dart';
import '../widgets/reviews_section.dart';

class SellerDashboardHome extends StatelessWidget {
  const SellerDashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarHelper.createAppBar(title: 'Seller Dashboard'),
      body: ResponsiveHelper.responsiveLayout(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ReviewsSection(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OrdersSection(title: 'ActiveOrders ', orderCount: 20),
                      OrdersSection(title: 'New Orders ', orderCount: 10),
                    ],
                  ),

                  RevenueSection(),
                  PopularItemsSection(),
                  // Add other sections here
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
