import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../orders/data/models/order_item_model.dart';
import '../../../orders/data/models/place_order_request_model.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/cubit/table_cubit.dart';
import '../cubit/check_out_cubit.dart';
import '../cubit/check_out_state.dart';
import 'checkout_listener.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../address/presentation/cubit/address_cubit.dart';
import '../../../address/presentation/cubit/address_state.dart';
import '../../../address/presentation/cubit/address_event.dart';

class CheckoutBody extends StatefulWidget {
  final CartEntity cart;
  final OrderType orderType;
  final int? tableId;
  const CheckoutBody({
    super.key,
    required this.cart,
    required this.orderType,
    this.tableId,
  });

  @override
  State<CheckoutBody> createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<CheckoutBody> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  String _selectedPaymentMethod = 'Cash';

  final List<String> _paymentMethods = [
    'Cash',
    'Credit Card',
    'Digital Wallet',
  ];

  int? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    // استخدم القيم القادمة من الكونستركتور
    if (widget.orderType == OrderType.delivery) {
      context.read<AddressCubit>().add(LoadAddresses());
    } else if (widget.orderType == OrderType.dineIn) {
      context.read<TableCubit>().getTableByQr(widget.tableId.toString());
    }
  }

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

    return CheckoutBodyListener(
      child: Scaffold(
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
                      _buildOrderSummary(subtotal, tax, deliveryFee, total),
                      const SizedBox(height: 24),
                      _buildDeliveryAddress(),
                      const SizedBox(height: 24),
                      _buildPaymentMethod(),
                      const SizedBox(height: 24),
                      _buildOrderNotes(),
                    ],
                  ),
                ),
              ),
              _buildPlaceOrderButton(total),
            ],
          ),
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
          const Text(
            'Order Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...widget.cart.items.map(
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
                      item.product.name,
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
          ),
          const Divider(color: Colors.grey),
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
    if (widget.orderType != OrderType.delivery) return SizedBox.shrink();

    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        if (state is AddressLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is AddressLoaded) {
          if (state.addresses.isEmpty) {
            return Text(
              'No addresses found. Please add a new address.',
              style: TextStyle(color: Colors.white),
            );
          }
          // أول مرة: اختر الافتراضي أو الأول
          _selectedAddressId ??=
              state.defaultAddress?.id ?? state.addresses.first.id;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A4A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...state.addresses.map(
                  (address) => RadioListTile<int>(
                    value: address.id,
                    groupValue: _selectedAddressId,
                    onChanged: (val) {
                      setState(() {
                        _selectedAddressId = val;
                      });
                    },
                    title: Text(
                      address.fullAddress,
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                    subtitle: address.isDefault
                        ? Text(
                            'Default',
                            style: TextStyle(color: AppColors.lightPrimary),
                          )
                        : null,
                    activeColor: AppColors.lightPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // فتح صفحة إضافة عنوان جديد
                  },
                  child: const Text(
                    'Add New Address',
                    style: TextStyle(color: AppColors.lightPrimary),
                  ),
                ),
              ],
            ),
          );
        }
        if (state is AddressError) {
          return Text(state.message, style: TextStyle(color: Colors.red));
        }
        return SizedBox.shrink();
      },
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
          const Text(
            'Payment Method',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ..._paymentMethods.map(
            (method) => RadioListTile<String>(
              value: method,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              title: Text(method, style: TextStyle(color: Colors.grey[300])),
              activeColor: AppColors.lightPrimary,
              contentPadding: EdgeInsets.zero,
            ),
          ),
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
          const Text(
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
                borderSide: const BorderSide(color: AppColors.lightPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(double total) {
    return BlocBuilder<CheckOutCubit, CheckOutState>(
      builder: (context, state) {
        final isLoading = state is CheckOutLoading;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFF2A2A3A),
            border: Border(top: BorderSide(color: Color(0xFF3A3A4A), width: 1)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handlePlaceOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      'Place Order - \$${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _handlePlaceOrder() {
    if (_formKey.currentState!.validate()) {
      final items = widget.cart.items
          .map(
            (item) => OrderItemModel.fromCartItem(
              menuItemId: int.parse(item.product.id),
              name: item.product.name,
              description: item.product.description,
              image: item.product.imageUrl,
              unitPrice: item.unitPrice,
              quantity: item.quantity,
              specialInstructions: null,
            ),
          )
          .toList();

      String? selectedAddressFull;
      if (widget.orderType == OrderType.delivery &&
          _selectedAddressId != null) {
        final state = context.read<AddressCubit>().state;
        if (state is AddressLoaded) {
          selectedAddressFull = state.addresses
              .firstWhere((a) => a.id == _selectedAddressId)
              .fullAddress;
        }
      }
      // تحقق من أن type ليس null
      if (widget.orderType == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('يرجى اختيار نوع الطلب')));
        return;
      }
      final request = PlaceOrderRequestModel(
        type: widget.orderType,
        tableId: widget.orderType == OrderType.dineIn ? widget.tableId : null,
        addressId: widget.orderType == OrderType.delivery
            ? _selectedAddressId
            : null, // أضف هذا
        deliveryAddress: widget.orderType == OrderType.delivery
            ? (selectedAddressFull ?? '')
            : null,
        specialInstructions: null,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
      print('DEBUG: PlaceOrderRequestModel type:  [32m [1m${request.type} [0m');
      print('DEBUG: PlaceOrderRequestModel json: ${request.toJson()}');

      context.read<CheckOutCubit>().placeOrder(request, items);
    }
  }
}

class ThankYouPage extends StatelessWidget {
  final int orderId;
  final String? qrCode;
  const ThankYouPage({Key? key, required this.orderId, this.qrCode})
    : super(key: key);

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
            if (qrCode != null) ...[
              const SizedBox(height: 24),
              Text(
                'Scan this QR code at the restaurant:',
                style: TextStyle(color: Colors.grey[300]),
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
