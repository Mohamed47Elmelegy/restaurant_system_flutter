import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_system_flutter/core/entities/product.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/food_item_card.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class FoodItemsSection extends StatelessWidget {
  final String title;
  final List<ProductEntity> Function(HomeLoaded state) getItems;
  final bool isHorizontal;

  const FoodItemsSection({
    super.key,
    required this.title,
    required this.getItems,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.senBold20(context)),
              SizedBox(height: 16.h),
              if (isHorizontal)
                SizedBox(height: 200.h, child: _buildItemsList(context, state))
              else
                _buildItemsGrid(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemsList(BuildContext context, HomeState state) {
    final items = state is HomeLoaded
        ? getItems(state)
        : _generatePlaceholderItems();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: FoodItemCard(
            foodItem: items[index],
            onAddPressed: () {
             
            },
            categories: state is HomeLoaded ? state.categories : null,
          ),
        );
      },
    );
  }

  Widget _buildItemsGrid(BuildContext context, HomeState state) {
    final items = state is HomeLoaded
        ? getItems(state)
        : _generatePlaceholderItems();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return FoodItemCard(
          foodItem: items[index],
          onAddPressed: () {
           
          },
          categories: state is HomeLoaded ? state.categories : null,
        );
      },
    );
  }

  // Fake Data Placeholder for Skeleton Wrapper  This Data will come from the API
  List<ProductEntity> _generatePlaceholderItems() {
    return List.generate(6, (index) {
      return ProductEntity(
        id: '${index + 1}',
        name: 'Item ${index + 1}',
        description: 'Delicious item',
        price: 25.0 + (index * 5),
        rating: 4.5 + (index * 0.1),
        imageUrl: 'assets/icons/basic/Chicken.png',
        mainCategoryId: 1,
      );
    });
  }
}
