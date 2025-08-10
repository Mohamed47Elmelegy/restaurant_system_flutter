import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../entities/product.dart';
import '../entities/main_category.dart';
import '../theme/theme_helper.dart';
import '../theme/text_styles.dart';

class FoodItemCard extends StatelessWidget {
  final ProductEntity foodItem;
  final VoidCallback onAddPressed;
  final List<CategoryEntity>? categories; // Add categories parameter

  const FoodItemCard({
    super.key,
    required this.foodItem,
    required this.onAddPressed,
    this.categories, // Add categories parameter
  });

  /// Get category name from mainCategoryId
  String getCategoryName() {
    if (categories == null || categories!.isEmpty) {
      return 'تصنيف ${foodItem.mainCategoryId}';
    }

    try {
      final category = categories!.firstWhere(
        (cat) => cat.id == foodItem.mainCategoryId.toString(),
        orElse: () => CategoryEntity(
          id: '',
          name: 'تصنيف ${foodItem.mainCategoryId}',
          isActive: true,
          sortOrder: 0,
        ),
      );

      return category.name;
    } catch (e) {
      return 'تصنيف ${foodItem.mainCategoryId}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              // Image section
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
                        ? _buildImageWidget()
                        : _buildPlaceholderImage(),
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
                      // Location/Subtitle (using category name instead of ID)
                      Text(
                        getCategoryName(),
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

  /// Build image widget based on URL type
  Widget _buildImageWidget() {
    final imageUrl = foodItem.imageUrl!;

    // Check if it's a network URL or local asset
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      // Network image
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    } else {
      // Local asset image
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    }
  }

  /// Build placeholder image when no image is available
  Widget _buildPlaceholderImage() {
    return Container(
      color: const Color(0xFF8DA0B3),
      child: Icon(
        Icons.fastfood,
        size: 40.sp,
        color: Colors.white.withOpacity(0.7),
      ),
    );
  }
}
