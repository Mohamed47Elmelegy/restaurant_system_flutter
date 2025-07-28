import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/theme_helper.dart';

class MediaUploadWidget extends StatelessWidget {
  final List<String> uploadedImages;
  final VoidCallback onAddPressed;

  const MediaUploadWidget({
    super.key,
    required this.uploadedImages,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UPLOAD PHOTO/VIDEO',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getPrimaryTextColor(context),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            // First upload area (shows uploaded image or placeholder)
            Expanded(
              child: _buildUploadArea(
                context,
                hasImage: uploadedImages.isNotEmpty,
                imagePath: uploadedImages.isNotEmpty
                    ? uploadedImages.first
                    : null,
              ),
            ),
            SizedBox(width: 12.w),
            // Second upload area (add button)
            Expanded(child: _buildAddButton(context)),
            SizedBox(width: 12.w),
            // Third upload area (add button)
            Expanded(child: _buildAddButton(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadArea(
    BuildContext context, {
    bool hasImage = false,
    String? imagePath,
  }) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: hasImage
            ? Colors.transparent
            : ThemeHelper.getInputBackgroundColor(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasImage
              ? Colors.transparent
              : ThemeHelper.getSecondaryTextColor(
                  context,
                ).withValues(alpha: 0.2),
        ),
      ),
      child: hasImage && imagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: ThemeHelper.getSecondaryTextColor(
                  context,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: ThemeHelper.getInputBackgroundColor(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ThemeHelper.getSecondaryTextColor(
            context,
          ).withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: onAddPressed,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: ThemeHelper.getSecondaryTextColor(
                  context,
                ).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_upload,
                size: 16.sp,
                color: ThemeHelper.getSecondaryTextColor(context),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Add',
              style: TextStyle(
                fontSize: 12.sp,
                color: ThemeHelper.getSecondaryTextColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
