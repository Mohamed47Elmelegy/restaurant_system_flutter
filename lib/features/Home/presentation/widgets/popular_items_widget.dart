import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/food_item_card.dart';
import '../../domain/entities/food_item_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class PopularItemsWidget extends StatelessWidget {
  const PopularItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Popular Items', style: AppTextStyles.senBold20(context)),
              SizedBox(height: 16.h),
              SizedBox(
                height: 200.h,
                child: _buildPopularItemsList(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopularItemsList(BuildContext context, HomeState state) {
    if (state is HomeLoaded) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.popularItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: FoodItemCard(foodItem: state.popularItems[index]),
          );
        },
      );
    } else {
      // Placeholder items for loading/initial state
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: FoodItemCard(
              foodItem: FoodItemEntity(
                id: index + 1,
                name: 'Food Item ${index + 1}',
                description: 'Delicious food item',
                price: 25.0,
                rating: 4.5,
                image: 'assets/icons/basic/Chicken.png',
                category: 'Fast Food',
              ),
            ),
          );
        },
      );
    }
  }
}
