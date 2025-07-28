import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/theme_helper.dart';

class DeliveryOptionsWidget extends StatelessWidget {
  final bool isPickupSelected;
  final bool isDeliverySelected;
  final ValueChanged<bool> onPickupChanged;
  final ValueChanged<bool> onDeliveryChanged;

  const DeliveryOptionsWidget({
    super.key,
    required this.isPickupSelected,
    required this.isDeliverySelected,
    required this.onPickupChanged,
    required this.onDeliveryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCheckbox(
          context,
          value: isPickupSelected,
          onChanged: onPickupChanged,
          label: 'Pick up',
        ),
        const SizedBox(width: 24),
        _buildCheckbox(
          context,
          value: isDeliverySelected,
          onChanged: onDeliveryChanged,
          label: 'Delivery',
        ),
      ],
    );
  }

  Widget _buildCheckbox(
    BuildContext context, {
    required bool value,
    required ValueChanged<bool> onChanged,
    required String label,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? AppColors.lightPrimary : Colors.transparent,
              border: Border.all(
                color: value
                    ? AppColors.lightPrimary
                    : ThemeHelper.getSecondaryTextColor(
                        context,
                      ).withValues(alpha: 0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: ThemeHelper.getPrimaryTextColor(context),
            ),
          ),
        ],
      ),
    );
  }
}
