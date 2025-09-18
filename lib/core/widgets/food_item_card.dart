import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../entities/main_category.dart';
import '../entities/product.dart';
import '../routes/app_routes.dart';
import '../theme/text_styles.dart';
import '../theme/theme_helper.dart';
import '../utils/category_helper.dart';
import 'cached_image_widget.dart';

class FoodItemCard extends StatelessWidget {
  final ProductEntity foodItem;
  final VoidCallback onAddPressed;
  final List<CategoryEntity>? categories;

  const FoodItemCard({
    super.key,
    required this.foodItem,
    required this.onAddPressed,
    this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.productDetails,
            arguments: {'product': foodItem},
          );
        },
        child: Container(
          width: 160.w,
          height: 200.h,
          decoration: BoxDecoration(
            color: ThemeHelper.getCardBackgroundColor(context),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: ThemeHelper.getCardShadow(context),
          ),
          child: Stack(
            children: [
              // Main content
              Column(
                children: [
                  // Image section
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8DA0B3),
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
                        child: CachedImageCard(
                          imageUrl: foodItem.imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.r),
                            topRight: Radius.circular(12.r),
                          ),
                          backgroundColor: const Color(0xFF8DA0B3),
                        ),
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Food item name
                          Flexible(
                            child: Text(
                              foodItem.name,
                              style: AppTextStyles.senBold14(context).copyWith(
                                fontSize: 15.sp,
                                color: ThemeHelper.getPrimaryTextColor(context),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          // Category name
                          Flexible(
                            child: Text(
                              CategoryHelper.getNameById(
                                id: int.tryParse(foodItem.mainCategoryId) ?? 0,
                                categories: categories ?? [],
                              ),
                              style: AppTextStyles.senRegular14(context)
                                  .copyWith(
                                    fontSize: 13.sp,
                                    color: ThemeHelper.getSecondaryTextColor(
                                      context,
                                    ),
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // Price
                          Flexible(
                            child: Text(
                              foodItem.getFormattedPrice(),
                              style: AppTextStyles.senBold14(context).copyWith(
                                fontSize: 16.sp,
                                color: ThemeHelper.getPrimaryTextColor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Add button positioned at bottom right
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
                        color: ThemeHelper.getPrimaryColorForTheme(context),
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
        ),
      ),
    );
  }
}
