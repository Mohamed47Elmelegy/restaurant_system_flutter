import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restaurant_system_flutter/core/theme/theme_helper.dart';

import '../../../../core/constants/app_icons.dart';

class CustomAddressCart extends StatelessWidget {
  final String title;
  final String address;
  final bool isDefault;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;

  const CustomAddressCart({
    super.key,
    required this.title,
    required this.address,
    this.isDefault = false,
    this.onEdit,
    this.onDelete,
    this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ThemeHelper.getPrimaryTextColor(context),
                      ),
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeHelper.getSecondaryTextColor(context),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        AppIcons.edit,
                        height: 16,
                        width: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        AppIcons.delete,
                        height: 16,
                        width: 16,
                      ),
                    ),
                  ),
                ],
              ),
              if (onSetDefault != null && !isDefault) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onSetDefault,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue, width: 1),
                    ),
                    child: const Text(
                      'Set as Default',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
