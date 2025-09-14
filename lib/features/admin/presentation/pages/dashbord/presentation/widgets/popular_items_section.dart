import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_system_flutter/core/theme/theme_helper.dart';
import 'product_item.dart';

class PopularItemsSection extends StatelessWidget {
  const PopularItemsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Items This Week',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeHelper.getPrimaryTextColor(context),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'see All',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ThemeHelper.getPrimaryColorForTheme(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 4.5,
            ),
            itemCount: 4, // Example item count
            itemBuilder: (context, index) {
              return const ProductItem();
            },
          ),
        ],
      ),
    );
  }
}
