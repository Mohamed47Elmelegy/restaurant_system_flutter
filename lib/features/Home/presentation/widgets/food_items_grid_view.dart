import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/entities/product.dart';
import '../../../../core/entities/main_category.dart';
import '../../../../core/widgets/food_item_card.dart';

class FoodItemsGridView extends StatelessWidget {
  final List<ProductEntity> items;
  final List<CategoryEntity>? categories;
  final EdgeInsetsGeometry? padding;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const FoodItemsGridView({
    super.key,
    required this.items,
    this.categories,
    this.padding,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.8,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
    this.physics,
    this.shrinkWrap = true,
  }) : crossAxisSpacing = crossAxisSpacing ?? 16.0,
       mainAxisSpacing = mainAxisSpacing ?? 16.0;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? EdgeInsets.zero;
    return Padding(
      padding: effectivePadding,
      child: GridView.builder(
        shrinkWrap: shrinkWrap,
        physics: physics ?? const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: crossAxisSpacing.w,
          mainAxisSpacing: mainAxisSpacing.h,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final product = items[index];
          return FoodItemCard(
            foodItem: product,
            onAddPressed: () {},
            categories: categories,
          );
        },
      ),
    );
  }
}
