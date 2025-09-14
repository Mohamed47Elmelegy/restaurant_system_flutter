import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/snack_bar_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class AddToCartButton extends StatefulWidget {
  final int productId;
  final double price;
  final bool isAvailable;
  final VoidCallback? onSuccess;

  const AddToCartButton({
    super.key,
    required this.productId,
    required this.price,
    this.isAvailable = true,
    this.onSuccess,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartItemAdded || state is CartLoaded) {
          setState(() {
            _isLoading = false;
          });

          // Show success feedback using SnackBarService
          SnackBarService.showSuccessMessage(
            context,
            'تم إضافة المنتج إلى السلة بنجاح!',
            title: 'تم بنجاح',
          );

          widget.onSuccess?.call();
        } else if (state is CartError) {
          setState(() {
            _isLoading = false;
          });

          // Show error feedback using SnackBarService
          SnackBarService.showErrorMessage(context, state.message);
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: widget.isAvailable
                    ? AppColors.lightPrimary
                    : Colors.grey[600],
                borderRadius: BorderRadius.circular(12),
                boxShadow: widget.isAvailable
                    ? [
                        BoxShadow(
                          color: AppColors.lightPrimary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: widget.isAvailable && !_isLoading
                      ? _handleAddToCart
                      : null,
                  onTapDown: widget.isAvailable
                      ? (_) {
                          _animationController.forward();
                        }
                      : null,
                  onTapUp: widget.isAvailable
                      ? (_) {
                          _animationController.reverse();
                        }
                      : null,
                  onTapCancel: widget.isAvailable
                      ? () {
                          _animationController.reverse();
                        }
                      : null,
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.isAvailable
                                    ? 'Add to Cart - \$${widget.price.toStringAsFixed(0)}'
                                    : 'Out of Stock',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleAddToCart() {
    if (!widget.isAvailable || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    context.read<CartCubit>().add(
      AddToCart(productId: widget.productId, quantity: 1),
    );
  }
}

// /// Simplified version for quick actions
// class QuickAddToCartButton extends StatelessWidget {
//   final int productId;
//   final VoidCallback? onPressed;

//   const QuickAddToCartButton({
//     super.key,
//     required this.productId,
//     this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         color: AppColors.lightPrimary,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.lightPrimary.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(20),
//           onTap: () {
//             context.read<CartCubit>().add(
//               AddToCart(productId: productId, quantity: 1),
//             );
//             onPressed?.call();
//           },
//           child: const Icon(Icons.add, color: Colors.white, size: 20),
//         ),
//       ),
//     );
//   }
// }
