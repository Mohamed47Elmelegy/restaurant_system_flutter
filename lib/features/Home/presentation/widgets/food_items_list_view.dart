import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/entities/main_category.dart';
import '../../../../core/entities/product.dart';
import '../../../../core/widgets/food_item_card.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/bloc/cart_event.dart';

class FoodItemsListView extends StatelessWidget {
  final List<ProductEntity> items;
  final List<CategoryEntity>? categories;
  final EdgeInsetsGeometry? padding;
  final double itemSpacing;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final Axis scrollDirection;

  const FoodItemsListView({
    super.key,
    required this.items,
    this.categories,
    this.padding,
    double? itemSpacing,
    required this.physics,
    this.shrinkWrap = true,
    this.scrollDirection = Axis.horizontal,
  }) : itemSpacing = itemSpacing ?? 16.0;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? EdgeInsets.zero;
    return Padding(
      padding: effectivePadding,
      child: ListView.builder(
        shrinkWrap: shrinkWrap,
        physics: physics,
        scrollDirection: scrollDirection,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final product = items[index];
          final isLastItem = index == items.length - 1;

          return Padding(
            padding: scrollDirection == Axis.vertical
                ? EdgeInsets.only(bottom: isLastItem ? 0 : itemSpacing.h)
                : EdgeInsets.only(right: isLastItem ? 0 : itemSpacing.w),
            child: FoodItemCard(
              foodItem: product,
              onAddPressed: () {
                // Add product to cart using CartCubit
                final productId = product.intId;
                if (productId != null) {
                  context.read<CartCubit>().add(
                    AddToCart(productId: productId, quantity: 1),
                  );
                }
              },
              categories: categories,
            ),
          );
        },
      ),
    );
  }
}
