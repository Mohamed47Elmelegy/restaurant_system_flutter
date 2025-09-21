import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'skeleton_base.dart';

class CategoryItemsSkeleton extends StatelessWidget {
  const CategoryItemsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonBase.withShimmer(
      context: context,
      child: SkeletonBase.grid(
        itemCount: 6,
        padding: EdgeInsets.all(16.w),
        itemBuilder: (index) => _buildFoodItemCardSkeleton(),
      ),
    );
  }

  Widget _buildFoodItemCardSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: SkeletonBase.lightColor,
        borderRadius: SkeletonBase.largeRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image section skeleton
          Expanded(
            flex: 5,
            child: SkeletonBase.imagePlaceholder(
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
          ),
          // Content section skeleton
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food item name, category, price
                  SkeletonBase.textLines(
                    widths: [double.infinity, 80.w, 60.w],
                    spacing: 4.h,
                  ),
                  const Spacer(),
                  // Add button placeholder
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SkeletonBase.circle(size: 32.w),
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
