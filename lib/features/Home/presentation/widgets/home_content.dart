import 'package:flutter/material.dart';

import 'address_section_widget.dart';
import 'categories_list_widget.dart';
import 'popular_items_widget.dart';
import 'recommended_items_widget.dart';

class HomeContent extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const HomeContent({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: const CustomScrollView(
        slivers: [
          // Categories Section
          SliverToBoxAdapter(child: CategoriesListWidget()),

          // Address Section
          SliverToBoxAdapter(child: AddressSectionWidget()),

          // Popular Items Section
          SliverToBoxAdapter(child: PopularItemsWidget()),

          // Recommended Items Section
          SliverToBoxAdapter(child: RecommendedItemsWidget()),
        ],
      ),
    );
  }
}
