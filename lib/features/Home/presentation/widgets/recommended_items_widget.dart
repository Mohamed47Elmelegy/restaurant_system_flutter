import 'package:flutter/material.dart';
import 'food_items_section.dart';

class RecommendedItemsWidget extends StatelessWidget {
  const RecommendedItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FoodItemsSection(
      title: 'Recommended for You',
      getItems: (state) => state.recommendedItems,
      isHorizontal: false, // Grid layout
    );
  }
}
