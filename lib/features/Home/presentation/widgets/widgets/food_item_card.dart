import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/theme_helper.dart';
import '../../../domain/entities/food_item_entity.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItemEntity foodItem;

  const FoodItemCard({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 160.w,
      height: 200.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: Image.asset(
                  AppImages.pizza,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    foodItem.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: ThemeHelper.getPrimaryTextColor(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  // Description
                  Expanded(
                    child: Text(
                      foodItem.description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ThemeHelper.getSecondaryTextColor(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Price and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${foodItem.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: ThemeHelper.getPrimaryTextColor(context),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, size: 12.sp, color: Colors.amber),
                          SizedBox(width: 2.w),
                          Text(
                            foodItem.rating.toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ThemeHelper.getSecondaryTextColor(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
