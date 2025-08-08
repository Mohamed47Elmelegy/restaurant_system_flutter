import 'package:flutter/material.dart';
import 'food_items_section.dart';

class PopularItemsWidget extends StatelessWidget {
  const PopularItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FoodItemsSection(
      title: 'Popular Items',
      getItems: (state) => state.popularItems,
      isHorizontal: true,
    );
  }
}
