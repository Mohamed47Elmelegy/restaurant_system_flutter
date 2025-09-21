import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/theme_helper.dart';
import 'skeleton_base.dart';

class OrdersSkeleton extends StatelessWidget {
  final TabController? tabController;

  const OrdersSkeleton({super.key, this.tabController});

  @override
  Widget build(BuildContext context) {
    return SkeletonBase.withShimmer(
      context: context,
      child: Column(
        children: [
          // Tab bar skeleton
          if (tabController != null) _buildTabBarSkeleton(context),

          // Orders list skeleton
          Expanded(child: _buildOrdersListSkeleton(context)),
        ],
      ),
    );
  }

  Widget _buildTabBarSkeleton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: SkeletonBase.button(
              width: double.infinity,
              height: 32.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOrdersListSkeleton(BuildContext context) {
    return SkeletonBase.verticalList(
      itemCount: 5,
      itemBuilder: (index) => Container(
        margin: EdgeInsets.only(bottom: 16.h),
        child: _buildOrderCardSkeleton(context),
      ),
    );
  }

  Widget _buildOrderCardSkeleton(BuildContext context) {
    return SkeletonBase.card(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with order number and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBase.container(width: 80.w, height: 18.h),
              SkeletonBase.button(width: 60.w, height: 24.h),
            ],
          ),

          SizedBox(height: 12.h),

          // Order date
          SkeletonBase.container(width: 120.w, height: 14.h),

          SizedBox(height: 12.h),

          // Order items section
          _buildOrderItemsSkeleton(),

          SizedBox(height: 12.h),

          // Order total and actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBase.container(width: 80.w, height: 18.h),
              Row(
                children: [
                  SkeletonBase.button(width: 60.w, height: 32.h),
                  SizedBox(width: 8.w),
                  SkeletonBase.button(width: 60.w, height: 32.h),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsSkeleton() {
    return Column(
      children: List.generate(2, (index) {
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          child: Row(
            children: [
              // Item image skeleton
              SkeletonBase.imagePlaceholder(width: 40.w, height: 40.h),

              SizedBox(width: 12.w),

              // Item details skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBase.fullWidthContainer(height: 14.h),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkeletonBase.container(width: 40.w, height: 12.h),
                        SkeletonBase.container(width: 50.w, height: 12.h),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class OrderDetailsSkeleton extends StatelessWidget {
  const OrderDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonBase.withShimmer(
      context: context,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order header skeleton
              _buildOrderHeaderSkeleton(context),

              SizedBox(height: 24.h),

              // Order items skeleton
              _buildOrderItemsDetailSkeleton(context),

              SizedBox(height: 24.h),

              // Order summary skeleton
              _buildOrderSummarySkeleton(context),

              SizedBox(height: 24.h),

              // Delivery info skeleton
              _buildDeliveryInfoSkeleton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeaderSkeleton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              Container(
                width: 80.w,
                height: 28.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: 150.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsDetailSkeleton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.w,
            height: 18.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 16.h),
          ...List.generate(3, (index) {
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 40.w,
                              height: 14.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            Container(
                              width: 60.w,
                              height: 14.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySkeleton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.w,
            height: 18.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 16.h),
          ...List.generate(4, (index) {
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 80.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  Container(
                    width: 60.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfoSkeleton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120.w,
            height: 18.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ],
      ),
    );
  }
}
