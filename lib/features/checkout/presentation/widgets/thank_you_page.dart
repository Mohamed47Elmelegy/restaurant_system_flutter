import 'package:flutter/material.dart';

class ThankYouPage extends StatelessWidget {
  final int orderId;
  final String? qrCode;
  final String? deliveryAddress;
  final String? tableInfo;
  final String? orderType; // Pass as string: 'delivery' or 'dineIn'

  const ThankYouPage({
    Key? key,
    required this.orderId,
    this.qrCode,
    this.deliveryAddress,
    this.tableInfo,
    this.orderType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2A3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A3A),
        elevation: 0,
        title: const Text('Thank You', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 24),
            Text(
              'Order #$orderId placed successfully!',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 24),
            if (orderType == 'delivery' && deliveryAddress != null) ...[
              const Text(
                'Delivery Address:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                deliveryAddress!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 24),
            ],
            if (orderType == 'dineIn' && tableInfo != null) ...[
              const Text(
                'Table Information:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tableInfo!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 24),
            ],
            if (qrCode != null) ...[
              const Text(
                'Scan this QR code at the restaurant:',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Image.memory(
                Uri.parse(qrCode!).data!.contentAsBytes(),
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
