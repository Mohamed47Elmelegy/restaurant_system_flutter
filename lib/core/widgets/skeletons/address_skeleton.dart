import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'skeleton_base.dart';

class AddressSkeleton extends StatelessWidget {
  const AddressSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonBase.withShimmer(
      context: context,
      child: Column(
        children: [
          Expanded(
            child: SkeletonBase.verticalList(
              itemCount: 3,
              itemBuilder: (index) => Container(
                margin: EdgeInsets.only(bottom: 16.h),
                child: _buildAddressCardSkeleton(context),
              ),
            ),
          ),
          // Add button skeleton
          _buildAddButtonSkeleton(),
        ],
      ),
    );
  }

  Widget _buildAddressCardSkeleton(BuildContext context) {
    return SkeletonBase.listItem(
      context: context,
      textWidths: [
        double.infinity, // Address title + badge row
        double.infinity, // First address line
        200.w, // Second address line
      ],
      showTrailing: true,
    );
  }

  Widget _buildAddButtonSkeleton() {
    return SkeletonBase.button(
      width: double.infinity,
      height: 56.h,
      margin: EdgeInsets.all(24.w),
    );
  }
}

class AddressFormSkeleton extends StatelessWidget {
  const AddressFormSkeleton({super.key});

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
              // Form fields skeleton
              _buildFormFieldSkeleton(context, width: 120.w), // Label
              SizedBox(height: 8.h),
              _buildFormFieldSkeleton(context), // Full width input

              SizedBox(height: 20.h),

              _buildFormFieldSkeleton(context, width: 100.w), // Label
              SizedBox(height: 8.h),
              _buildFormFieldSkeleton(context), // Full width input

              SizedBox(height: 20.h),

              _buildFormFieldSkeleton(context, width: 80.w), // Label
              SizedBox(height: 8.h),
              _buildFormFieldSkeleton(context), // Full width input

              SizedBox(height: 20.h),

              _buildFormFieldSkeleton(context, width: 100.w), // Label
              SizedBox(height: 8.h),
              _buildFormFieldSkeleton(context), // Full width input

              SizedBox(height: 20.h),

              _buildFormFieldSkeleton(context, width: 140.w), // Label
              SizedBox(height: 8.h),
              _buildFormFieldSkeleton(context, height: 80.h), // Text area

              SizedBox(height: 32.h),

              // Default address checkbox skeleton
              Row(
                children: [
                  SkeletonBase.container(width: 20.w, height: 20.h),
                  SizedBox(width: 12.w),
                  SkeletonBase.container(width: 120.w, height: 16.h),
                ],
              ),

              SizedBox(height: 40.h),

              // Save button skeleton
              SkeletonBase.button(width: double.infinity, height: 56.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFieldSkeleton(
    BuildContext context, {
    double? width,
    double? height,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 48.h,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}
