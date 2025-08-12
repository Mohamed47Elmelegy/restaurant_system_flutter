import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/cart_entity.dart';

class CheckoutPage extends StatefulWidget {
  final CartEntity cart;

  const CheckoutPage({super.key, required this.cart});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  String _selectedPaymentMethod = 'Cash';

  final List<String> _paymentMethods = [
    'Cash',
    'Credit Card',
    'Digital Wallet',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double taxRate = 0.15;
    const double deliveryFee = 5.0;

    final double subtotal = widget.cart.subtotal;
    final double tax = subtotal * taxRate;
    final double total = subtotal + tax + deliveryFee;

    return Scaffold(
      backgroundColor: const Color(0xFF2A2A3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A3A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary
                    _buildOrderSummary(subtotal, tax, deliveryFee, total),

                    const SizedBox(height: 24),

                    // Delivery Address
                    _buildDeliveryAddress(),

                    const SizedBox(height: 24),

                    // Payment Method
                    _buildPaymentMethod(),

                    const SizedBox(height: 24),

                    // Order Notes
                    _buildOrderNotes(),
                  ],
                ),
              ),
            ),

            // Place Order Button
            _buildPlaceOrderButton(total),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
    double subtotal,
    double tax,
    double deliveryFee,
    double total,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A4A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Items
          ...widget.cart.items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        '${item.quantity}x ',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Expanded(
                        child: Text(
                          item.product?.name ?? 'Unknown Product',
                          style: TextStyle(color: Colors.grey[300]),
                        ),
                      ),
                      Text(
                        '\$${(item.quantity * item.unitPrice).toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),

          const Divider(color: Colors.grey),

          // Totals
          _buildSummaryRow('Subtotal', subtotal),
          _buildSummaryRow('Tax (15%)', tax),
          _buildSummaryRow('Delivery Fee', deliveryFee),
          const Divider(color: Colors.grey),
          _buildSummaryRow('Total', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.white : Colors.grey[400],
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

  Widget _buildDeliveryAddress() {
    return Container(
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
                'Delivery Address',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to address selection
                },
                child: Text(
                  'Change',
                  style: TextStyle(color: AppColors.lightPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '2118 Thornridge Cir. Syracuse',
            style: TextStyle(color: Colors.grey[300], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A4A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          ..._paymentMethods
              .map(
                (method) => RadioListTile<String>(
                  value: method,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                  title: Text(
                    method,
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                  activeColor: AppColors.lightPrimary,
                  contentPadding: EdgeInsets.zero,
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildOrderNotes() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A4A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Notes (Optional)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            style: TextStyle(color: Colors.grey[300]),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Any special instructions...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[600]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[600]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.lightPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A3A),
        border: Border(top: BorderSide(color: Color(0xFF3A3A4A), width: 1)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _handlePlaceOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Place Order - \$${total.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  void _handlePlaceOrder() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement order placement logic
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF3A3A4A),
          title: const Text(
            'Order Placed!',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Your order has been placed successfully. You will receive a confirmation shortly.',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to cart
                Navigator.of(context).pop(); // Go back to home
              },
              child: Text(
                'OK',
                style: TextStyle(color: AppColors.lightPrimary),
              ),
            ),
          ],
        ),
      );
    }
  }
}
