import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A4A), // Slightly lighter than background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Product image placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF4A4A5A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: cartItem.product?.imageUrl != null
                ? Image.network(cartItem.product!.imageUrl!, fit: BoxFit.cover)
                : const Icon(Icons.fastfood, color: Colors.white54, size: 40),
          ),

          const SizedBox(width: 16),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name and remove button
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        cartItem.product?.name ?? 'Unknown Product',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Price
                Text(
                  '\$${cartItem.unitPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Quantity controls
                Row(
                  children: [
                    // Decrease button
                    GestureDetector(
                      onTap: cartItem.quantity > 1
                          ? () => onQuantityChanged(cartItem.quantity - 1)
                          : null,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: cartItem.quantity > 1
                              ? Colors.grey[600]
                              : Colors.grey[800],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: cartItem.quantity > 1
                              ? Colors.white
                              : Colors.grey[500],
                          size: 16,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Quantity
                    Text(
                      '${cartItem.quantity}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Increase button
                    GestureDetector(
                      onTap: () => onQuantityChanged(cartItem.quantity + 1),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.lightPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
