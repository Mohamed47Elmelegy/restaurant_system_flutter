import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'skeleton_base.dart';

class HomePageSkeleton extends StatelessWidget {
  const HomePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonBase.withShimmer(
      context: context,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar Skeleton
            SkeletonBase.appBar(),

            SizedBox(height: 24.h),

            // Address Section Skeleton
            _buildAddressSectionSkeleton(context),

            SizedBox(height: 32.h),

            // Categories Section Skeleton
            _buildCategoriesSkeleton(),

            SizedBox(height: 32.h),

            // Popular Items Section Skeleton
            _buildPopularItemsSkeleton(),

            SizedBox(height: 32.h),

            // Recommended Items Section Skeleton
            _buildRecommendedItemsSkeleton(),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSectionSkeleton(BuildContext context) {
    return SkeletonBase.card(
      context: context,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          SkeletonBase.container(width: 24.w, height: 24.h),
          SizedBox(width: 12.w),
          Expanded(
            child: SkeletonBase.textLines(
              widths: [60.w, double.infinity],
              spacing: 4.h,
            ),
          ),
          SkeletonBase.container(width: 24.w, height: 24.h),
        ],
      ),
    );
  }

  Widget _buildCategoriesSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBase.sectionHeader(width: 100.w),
        SizedBox(height: 16.h),
        SkeletonBase.horizontalList(
          itemCount: 5,
          height: 100.h,
          itemBuilder: (index) => Container(
            width: 80.w,
            margin: EdgeInsets.only(right: 12.w),
            child: Column(
              children: [
                SkeletonBase.circle(size: 60.w),
                SizedBox(height: 8.h),
                SkeletonBase.container(width: 50.w, height: 14.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularItemsSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBase.sectionHeader(width: 120.w),
        SizedBox(height: 16.h),
        SkeletonBase.horizontalList(
          itemCount: 3,
          height: 200.h,
          itemBuilder: (index) => Container(
            width: 160.w,
            margin: EdgeInsets.only(right: 16.w),
            child: SkeletonBase.foodItemCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedItemsSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBase.sectionHeader(width: 150.w),
        SizedBox(height: 16.h),
        SkeletonBase.grid(
          itemCount: 4,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemBuilder: (index) => SkeletonBase.foodItemCard(),
        ),
      ],
    );
  }
}
