import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_system_flutter/core/entities/product.dart';
import 'package:restaurant_system_flutter/features/Home/presentation/widgets/food_items_list_view.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/common_state_builder.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import 'food_items_grid_view.dart';

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
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.senBold20(context)),
          SizedBox(height: 16.h),
          CommonStateBuilder<HomeBloc, HomeState>(
            isLoading: (state) => state is HomeLoading || state is HomeInitial,
            hasError: (state) => state is HomeError,
            isEmpty: (state) => state is HomeLoaded && getItems(state).isEmpty,
            getErrorMessage: (state) =>
                state is HomeError ? state.message : 'حدث خطأ غير متوقع',
            builder: (context, state) {
              if (state is HomeLoaded) {
                return _buildItemsContent(context, state);
              }
              return _buildPlaceholderContent();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemsContent(BuildContext context, HomeLoaded state) {
    final items = getItems(state);

    if (isHorizontal) {
      return SizedBox(
        height: 200.h,
        child: FoodItemsListView(
          physics: const BouncingScrollPhysics(),
          items: items,
          categories: state.categories,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
        ),
      );
    } else {
      return FoodItemsGridView(
        items: items,
        categories: state.categories,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
      );
    }
  }

  Widget _buildPlaceholderContent() {
    final placeholderItems = _generatePlaceholderItems();

    if (isHorizontal) {
      return SizedBox(
        height: 200.h,
        child: FoodItemsListView(
          physics: const BouncingScrollPhysics(),
          items: placeholderItems,
          categories: null,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
        ),
      );
    } else {
      return FoodItemsGridView(
        items: placeholderItems,
        categories: null,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
      );
    }
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
        mainCategoryId: '1',
      );
    });
  }
}
