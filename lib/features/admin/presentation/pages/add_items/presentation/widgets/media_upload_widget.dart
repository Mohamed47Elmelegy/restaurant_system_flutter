import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';
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
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getPrimaryTextColor(context),
          ),
        ),
        const SizedBox(height: 12),
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
            const SizedBox(width: 12),
            // Second upload area (add button)
            Expanded(child: _buildAddButton(context)),
            const SizedBox(width: 12),
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
      height: 80,
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
                color: const Color(
                  0xFF6B7280,
                ), // Medium gray-blue as shown in image
                borderRadius: BorderRadius.circular(8),
              ),
            ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      height: 80,
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
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: ThemeHelper.getSecondaryTextColor(
                  context,
                ).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_upload,
                size: 16,
                color: ThemeHelper.getSecondaryTextColor(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add',
              style: TextStyle(
                fontSize: 12,
                color: ThemeHelper.getSecondaryTextColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
