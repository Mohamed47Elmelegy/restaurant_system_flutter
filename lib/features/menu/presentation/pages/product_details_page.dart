import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/entities/product.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/cached_image_widget.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String selectedSize = '14"';
  int quantity = 1;
  bool isFavorite = false;

  final List<String> sizes = ['10"', '14"', '16"'];

  // Mock ingredients for demonstration
  final List<Map<String, dynamic>> ingredients = [
    {'icon': Icons.restaurant_menu, 'name': 'Chef'},
    {'icon': Icons.restaurant, 'name': 'Chicken'},
    {'icon': Icons.eco, 'name': 'Onion'},
    {'icon': Icons.local_pizza, 'name': 'Tomato'},
    {'icon': Icons.local_fire_department, 'name': 'Chili'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Product image section with back and favorite buttons
                    _buildImageSection(),

                    // Product details card
                    _buildProductDetailsCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 250.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Stack(
        children: [
          // Product image placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: CachedImageDetail(
              imageUrl: widget.product.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              backgroundColor: Colors.grey[200],
            ),
          ),

          // Back button
          Positioned(
            top: 16.h,
            left: 16.w,
            child: _buildCircularButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.pop(context),
            ),
          ),

          // Favorite button
          Positioned(
            top: 16.h,
            right: 16.w,
            child: _buildCircularButton(
              icon: isFavorite ? Icons.favorite : Icons.favorite_border,
              iconColor: isFavorite ? Colors.red : Colors.black,
              onTap: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor ?? Colors.black, size: 20.sp),
      ),
    );
  }

  Widget _buildProductDetailsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          Text(
            widget.product.name,
            style: AppTextStyles.senBold20(
              context,
            ).copyWith(color: AppColors.lightTextMain),
          ),

          SizedBox(height: 8.h),

          // Restaurant location
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red, size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                'Rose Garden',
                style: AppTextStyles.senRegular14(
                  context,
                ).copyWith(color: Colors.grey[700]),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Rating, delivery, and time info
          _buildInfoRow(),

          SizedBox(height: 16.h),

          // Description
          Text(
            widget.product.description ??
                'Maecenas sed diam eget risus varius blandit sit amet non magna. Integer posuere erat a ante venenatis dapibus posuere velit aliquet.',
            style: AppTextStyles.senRegular14(
              context,
            ).copyWith(color: Colors.grey[600], height: 1.5),
          ),

          SizedBox(height: 24.h),

          // Size selection
          _buildSizeSelection(),

          SizedBox(height: 24.h),

          // Ingredients
          _buildIngredientsSection(),

          SizedBox(height: 32.h),

          // Price and quantity
          _buildPriceAndQuantity(),

          SizedBox(height: 24.h),

          // Add to cart button
          _buildAddToCartButton(),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        // Rating
        Row(
          children: [
            Icon(Icons.star_outline, color: Colors.grey[600], size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              widget.product.rating?.toStringAsFixed(1) ?? '4.7',
              style: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: Colors.grey[700]),
            ),
          ],
        ),

        SizedBox(width: 24.w),

        // Delivery
        Row(
          children: [
            Icon(
              Icons.local_shipping_outlined,
              color: Colors.grey[600],
              size: 16.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              'Free',
              style: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: Colors.grey[700]),
            ),
          ],
        ),

        SizedBox(width: 24.w),

        // Time
        Row(
          children: [
            Icon(
              Icons.access_time_outlined,
              color: Colors.grey[600],
              size: 16.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              '${widget.product.preparationTime ?? 20} min',
              style: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SIZE:',
          style: AppTextStyles.senBold14(
            context,
          ).copyWith(color: Colors.grey[700]),
        ),

        SizedBox(height: 12.h),

        Row(
          children: sizes.map((size) {
            final isSelected = size == selectedSize;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSize = size;
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.lightPrimary
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.lightPrimary
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    size,
                    style: AppTextStyles.senBold14(context).copyWith(
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INGRIDENTS',
          style: AppTextStyles.senBold14(
            context,
          ).copyWith(color: Colors.grey[700]),
        ),

        SizedBox(height: 12.h),

        Row(
          children: ingredients.map((ingredient) {
            return Container(
              margin: EdgeInsets.only(right: 12.w),
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Icon(
                ingredient['icon'],
                color: Colors.grey[600],
                size: 20.sp,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceAndQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Price
        Text(
          '\$${widget.product.price.toStringAsFixed(0)}',
          style: AppTextStyles.senBold20(
            context,
          ).copyWith(color: AppColors.lightTextMain),
        ),

        // Quantity selector
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (quantity > 1) {
                    setState(() {
                      quantity--;
                    });
                  }
                },
                child: Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.remove,
                    size: 16.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              Text(
                '$quantity',
                style: AppTextStyles.senBold16(
                  context,
                ).copyWith(color: Colors.grey[700]),
              ),

              SizedBox(width: 16.w),

              GestureDetector(
                onTap: () {
                  setState(() {
                    quantity++;
                  });
                },
                child: Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, size: 16.sp, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement add to cart functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Added ${quantity}x ${widget.product.name} to cart',
              ),
              backgroundColor: AppColors.lightPrimary,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: Text(
          'ADD TO CART',
          style: AppTextStyles.senBold16(
            context,
          ).copyWith(color: Colors.white, letterSpacing: 0.5),
        ),
      ),
    );
  }
}
