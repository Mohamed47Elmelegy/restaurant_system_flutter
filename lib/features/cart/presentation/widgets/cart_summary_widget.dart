import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restaurant_system_flutter/core/routes/app_routes.dart';
import 'package:restaurant_system_flutter/core/utils/debug_console_messages.dart';

import '../../../../core/theme/theme_helper.dart';
import '../../../orders/domain/entities/order_enums.dart';
import '../../domain/entities/cart_entity.dart';

class CartSummaryWidget extends StatelessWidget {
  final CartEntity cart;
  final String? deliveryAddress;
  final OrderType orderType;

  const CartSummaryWidget({
    super.key,
    required this.cart,
    this.deliveryAddress,
    required this.orderType,
  });

  @override
  Widget build(BuildContext context) {
    const double taxRate = 0.15; // 15% tax
    const double deliveryFee = 5.0; // Fixed delivery fee

    final double subtotal = cart.subtotal;
    final double tax = subtotal * taxRate;
    final double total = subtotal + tax + deliveryFee;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total section
          Row(
            children: [
              Text(
                'TOTAL:',
                style: TextStyle(
                  color: ThemeHelper.getSecondaryTextColor(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              Text(
                '\$${total.toStringAsFixed(0)}',
                style: TextStyle(
                  color: ThemeHelper.getPrimaryTextColor(context),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  _showBreakdownDialog(
                    context,
                    subtotal,
                    tax,
                    deliveryFee,
                    total,
                  );
                },
                child: Text(
                  'Breakdown',
                  style: TextStyle(
                    color: ThemeHelper.getPrimaryColorForTheme(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Place order button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _handlePlaceOrder(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeHelper.getPrimaryColorForTheme(context),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                'PLACE ORDER',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBreakdownDialog(
    BuildContext context,
    double subtotal,
    double tax,
    double deliveryFee,
    double total,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeHelper.getCardBackgroundColor(context),
        title: Text(
          'Order Breakdown',
          style: TextStyle(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBreakdownRow(context, 'Subtotal', subtotal),
            _buildBreakdownRow(context, 'Tax (15%)', tax),
            _buildBreakdownRow(context, 'Delivery Fee', deliveryFee),
            Divider(color: ThemeHelper.getDividerColor(context)),
            _buildBreakdownRow(context, 'Total', total, isTotal: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(
                color: ThemeHelper.getPrimaryColorForTheme(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(
    BuildContext context,
    String label,
    double amount, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal
                  ? ThemeHelper.getPrimaryTextColor(context)
                  : ThemeHelper.getSecondaryTextColor(context),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isTotal
                  ? ThemeHelper.getPrimaryTextColor(context)
                  : ThemeHelper.getSecondaryTextColor(context),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePlaceOrder(BuildContext context) async {
    // Navigate directly to modern checkout - it will handle order type selection
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.checkout, arguments: {'cart': cart});
  }
}

String? extractTableId(String qr) {
  qr = qr.trim(); // إزالة المسافات الزائدة
  log(DebugConsoleMessages.error('QR code scanned: $qr')); // Debugging
  final match = RegExp(r'TABLE_(\d+)').firstMatch(qr);
  if (match != null) {
    return match.group(1);
  }
  // إذا كان qr رقم فقط
  if (RegExp(r'^\d+ 0$').hasMatch(qr)) {
    return qr;
  }
  return null;
}
