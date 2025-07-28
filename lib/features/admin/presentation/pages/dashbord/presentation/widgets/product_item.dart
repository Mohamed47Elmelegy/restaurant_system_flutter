import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_system_flutter/core/constants/app_images.dart';

import '../../../../../../../core/theme/theme_helper.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
              image: DecorationImage(
                image: AssetImage(AppImages.pizza), // Example image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Food Name',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16.sp),
                    Text('4.5'),
                  ],
                ),
                Text(
                  'Description of the food item goes here.',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                Text(
                  'Breakfast, Lunch, Dinner',
                  style: TextStyle(fontSize: 12.sp, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
