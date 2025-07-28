import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        SizedBox(width: 24.w),
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
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: value
                  ? ThemeHelper.getPrimaryColorForTheme(context)
                  : Colors.transparent,
              border: Border.all(
                color: value
                    ? ThemeHelper.getPrimaryColorForTheme(context)
                    : ThemeHelper.getSecondaryTextColor(
                        context,
                      ).withValues(alpha: 0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? Icon(
                    Icons.check,
                    size: 14.sp,
                    color: ThemeHelper.getPrimaryTextColor(context),
                  )
                : null,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: ThemeHelper.getPrimaryTextColor(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
