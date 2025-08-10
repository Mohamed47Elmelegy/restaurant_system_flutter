import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_system_flutter/core/entities/product.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:restaurant_system_flutter/core/theme/text_styles.dart';
import '../theme/app_colors.dart';
import '../theme/theme_helper.dart';

class FoodItemCard extends StatelessWidget {
  final ProductEntity foodItem;
  final VoidCallback? onAddPressed;

  const FoodItemCard({super.key, required this.foodItem, this.onAddPressed});

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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder - blue-gray color as shown in image
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF8DA0B3,
                    ), // Blue-gray color from image
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
                    child: foodItem.imageUrl?.isNotEmpty == true
                        ? Image.asset(
                            foodItem.imageUrl ?? '',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : null,
                  ),
                ),
              ),
              // Content section
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food item name
                      Text(
                        foodItem.name,
                        style: AppTextStyles.senBold14(context).copyWith(
                          fontSize: 15.sp,
                          color: ThemeHelper.getPrimaryTextColor(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      // Location/Subtitle (using category as location)
                      Text(
                        foodItem.mainCategoryId.toString(),
                        style: AppTextStyles.senRegular14(context).copyWith(
                          fontSize: 13.sp,
                          color: ThemeHelper.getSecondaryTextColor(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      // Price
                      Text(
                        '\$${foodItem.price.toStringAsFixed(0)}',
                        style: AppTextStyles.senBold14(context).copyWith(
                          fontSize: 16.sp,
                          color: ThemeHelper.getPrimaryTextColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Orange circular add button positioned at bottom right
          Positioned(
            bottom: 8.h,
            right: 8.w,
            child: Skeleton.ignore(
              child: GestureDetector(
                onTap: onAddPressed,
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: ThemeHelper.getPrimaryColorForTheme(
                      context,
                    ), // Orange color from image
                    shape: BoxShape.circle,
                    boxShadow: ThemeHelper.getCardShadow(context),
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 18.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
