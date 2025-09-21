import 'package:flutter/material.dart';
import '../../../../../../../core/theme/theme_helper.dart';

class ProductSettingsWidget extends StatelessWidget {
  final bool isAvailable;
  final bool isFeatured;
  final ValueChanged<bool> onAvailableChanged;
  final ValueChanged<bool> onFeaturedChanged;

  const ProductSettingsWidget({
    super.key,
    required this.isAvailable,
    required this.isFeatured,
    required this.onAvailableChanged,
    required this.onFeaturedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PRODUCT SETTINGS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getPrimaryTextColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSettingTile(
                context,
                title: 'Available',
                subtitle: 'Product is available for ordering',
                value: isAvailable,
                onChanged: onAvailableChanged,
                icon: Icons.check_circle_outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSettingTile(
                context,
                title: 'Featured',
                subtitle: 'Show as featured product',
                value: isFeatured,
                onChanged: onFeaturedChanged,
                icon: Icons.star_outline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: value
              ? ThemeHelper.getPrimaryColorForTheme(context)
              : ThemeHelper.getBorderColor(context, false),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: value
            ? ThemeHelper.getPrimaryColorForTheme(
                context,
              ).withValues(alpha: 0.1)
            : Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: value
                    ? ThemeHelper.getPrimaryColorForTheme(context)
                    : ThemeHelper.getSecondaryTextColor(context),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: value
                        ? ThemeHelper.getPrimaryColorForTheme(context)
                        : ThemeHelper.getPrimaryTextColor(context),
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: ThemeHelper.getPrimaryColorForTheme(context),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: ThemeHelper.getSecondaryTextColor(context),
            ),
          ),
        ],
      ),
    );
  }
}
