import 'package:flutter/material.dart';

import '../../../../core/constants/empty_page.dart';
import '../../../../core/theme/app_colors.dart';

/// Error state widget for orders
class OrdersErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const OrdersErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyPageWidget(
      icon: Icons.error_outline,
      title: 'حدث خطأ!',
      subtitle: message,
      iconColor: AppColors.error,
      titleColor: AppColors.error,
      actionButtonText: 'إعادة المحاولة',
      actionButtonColor: AppColors.error,
      onActionButtonPressed: onRetry,
    );
  }
}
