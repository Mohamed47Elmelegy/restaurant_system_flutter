import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/order_utils.dart';
import '../../domain/entities/order_enums.dart';

/// A reusable widget for displaying order status as a styled chip
class StatusChip extends StatelessWidget {
  final OrderStatus status;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const StatusChip({
    super.key,
    required this.status,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfiguration(status);

    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: statusConfig.backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        statusConfig.text,
        style: AppTextStyles.senMedium12(
          context,
        ).copyWith(color: statusConfig.textColor, fontSize: fontSize?.sp),
      ),
    );
  }

  /// Get status configuration including colors and text
  _StatusConfiguration _getStatusConfiguration(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return _StatusConfiguration(
          backgroundColor: Colors.orange.withOpacity(0.1),
          textColor: Colors.orange,
          text: OrderUtils.getStatusDisplayName(status),
        );
      case OrderStatus.confirmed:
        return _StatusConfiguration(
          backgroundColor: Colors.blue.withOpacity(0.1),
          textColor: Colors.blue,
          text: OrderUtils.getStatusDisplayName(status),
        );
      case OrderStatus.paid:
        return _StatusConfiguration(
          backgroundColor: Colors.blue.withOpacity(0.1),
          textColor: Colors.blue,
          text: OrderUtils.getStatusDisplayName(status),
        );
      case OrderStatus.preparing:
        return _StatusConfiguration(
          backgroundColor: AppColors.lightPrimary.withOpacity(0.1),
          textColor: AppColors.lightPrimary,
          text: OrderUtils.getStatusDisplayName(status),
        );
      case OrderStatus.readyToServe:
        return _StatusConfiguration(
          backgroundColor: Colors.green.withOpacity(0.1),
          textColor: Colors.green,
          text: OrderUtils.getStatusDisplayName(status),
        );
      case OrderStatus.served:
        return _StatusConfiguration(
          backgroundColor: Colors.green.withOpacity(0.1),
          textColor: Colors.green,
          text: OrderUtils.getStatusDisplayName(status),
        );
      case OrderStatus.readyForPickup:
        return _StatusConfiguration(
          backgroundColor: Colors.amber.withOpacity(0.1),
          textColor: Colors.amber.shade700,
          text: OrderUtils.getStatusDisplayName(status),
        );
      case OrderStatus.pickedUp:
        return _StatusConfiguration(
          backgroundColor: Colors.green.withOpacity(0.1),
          textColor: Colors.green,
          text: OrderUtils.getStatusDisplayName(status),
        );
      case OrderStatus.onTheWay:
        return _StatusConfiguration(
          backgroundColor: Colors.purple.withOpacity(0.1),
          textColor: Colors.purple,
          text: OrderUtils.getStatusDisplayName(status),
        );
      case OrderStatus.delivered:
        return _StatusConfiguration(
          backgroundColor: Colors.green.withOpacity(0.1),
          textColor: Colors.green,
          text: OrderUtils.getStatusDisplayName(status),
        );
      case OrderStatus.completed:
        return _StatusConfiguration(
          backgroundColor: Colors.green.withOpacity(0.1),
          textColor: Colors.green,
          text: OrderUtils.getStatusDisplayName(status),
        );
      case OrderStatus.cancelled:
        return _StatusConfiguration(
          backgroundColor: Colors.red.withOpacity(0.1),
          textColor: Colors.red,
          text: OrderUtils.getStatusDisplayName(status),
        );
      case OrderStatus.refunded:
        return _StatusConfiguration(
          backgroundColor: Colors.grey.withOpacity(0.1),
          textColor: Colors.grey.shade700,
          text: OrderUtils.getStatusDisplayName(status),
        );
    }
  }
}

/// Internal class to hold status configuration
class _StatusConfiguration {
  final Color backgroundColor;
  final Color textColor;
  final String text;

  const _StatusConfiguration({
    required this.backgroundColor,
    required this.textColor,
    required this.text,
  });
}
