import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../domain/entities/cart_entity.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../../../checkout/presentation/widgets/qr_scanner_page.dart';

class CartSummaryWidget extends StatelessWidget {
  final CartEntity cart;
  final String? deliveryAddress;

  const CartSummaryWidget({super.key, required this.cart, this.deliveryAddress});

  @override
  Widget build(BuildContext context) {
    const double taxRate = 0.15; // 15% tax
    const double deliveryFee = 5.0; // Fixed delivery fee

    final double subtotal = cart.subtotal;
    final double tax = subtotal * taxRate;
    final double total = subtotal + tax + deliveryFee;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A3A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Delivery address section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A4A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'DELIVERY ADDRESS',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'EDIT',
                      style: TextStyle(
                        color: AppColors.lightPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  deliveryAddress ?? 'No delivery address',
                  style: TextStyle(color: Colors.grey[300], fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Total section
          Row(
            children: [
              Text(
                'TOTAL:',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              Text(
                '\$${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
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
                child: const Text(
                  'Breakdown',
                  style: TextStyle(
                    color: AppColors.lightPrimary,
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
                backgroundColor: AppColors.lightPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
        backgroundColor: const Color(0xFF3A3A4A),
        title: const Text(
          'Order Breakdown',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBreakdownRow('Subtotal', subtotal),
            _buildBreakdownRow('Tax (15%)', tax),
            _buildBreakdownRow('Delivery Fee', deliveryFee),
            const Divider(color: Colors.grey),
            _buildBreakdownRow('Total', total, isTotal: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: AppColors.lightPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(
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
              color: isTotal ? Colors.white : Colors.grey[300],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isTotal ? Colors.white : Colors.grey[300],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePlaceOrder(BuildContext context) async {
    final orderType = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => _OrderTypeBottomSheet(),
    );

    if (orderType == 'delivery') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              CheckoutPage(cart: cart, orderType: OrderType.delivery),
        ),
      );
    } else if (orderType == 'dine_in') {
      final tableId = await _scanQrCode(context);
      if (tableId != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CheckoutPage(
              cart: cart,
              orderType: OrderType.dineIn,
              tableId: tableId,
            ),
          ),
        );
      }
    }
  }
}

// Widget بسيط لاختيار نوع الطلب
class _OrderTypeBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.delivery_dining),
            title: Text('Delivery'),
            onTap: () => Navigator.of(context).pop('delivery'),
          ),
          ListTile(
            leading: Icon(Icons.qr_code_scanner),
            title: Text('Dine In'),
            onTap: () => Navigator.of(context).pop('dine_in'),
          ),
        ],
      ),
    );
  }
}

// دالة وهمية لمسح QR (استبدلها لاحقاً بمكتبة QR المناسبة)
Future<int?> _scanQrCode(BuildContext context) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const QrScannerPage()),
  );
  return int.tryParse(result ?? '');
}
