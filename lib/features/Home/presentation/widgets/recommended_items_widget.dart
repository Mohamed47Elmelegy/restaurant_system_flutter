import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/food_item_card.dart';
import '../../domain/entities/food_item_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class RecommendedItemsWidget extends StatelessWidget {
  const RecommendedItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recommended for You',
                style: AppTextStyles.senBold20(context),
              ),
              SizedBox(height: 16.h),
              _buildRecommendedItemsGrid(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecommendedItemsGrid(BuildContext context, HomeState state) {
    if (state is HomeLoaded) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: state.recommendedItems.length,
        itemBuilder: (context, index) {
          return FoodItemCard(foodItem: state.recommendedItems[index]);
        },
      );
    } else {
      // Placeholder items for loading/initial state
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return FoodItemCard(
            foodItem: FoodItemEntity(
              id: index + 1,
              name: 'Recommended Item ${index + 1}',
              description: 'Delicious recommended item',
              price: 30.0,
              rating: 4.8,
              image: 'assets/icons/basic/Chicken.png',
              category: 'Fast Food',
            ),
          );
        },
      );
    }
  }
}
