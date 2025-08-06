import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/category_card.dart';
import '../../domain/entities/category_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class CategoriesListWidget extends StatelessWidget {
  const CategoriesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Categories', style: AppTextStyles.senBold20(context)),
              SizedBox(height: 16.h),
              SizedBox(
                height: 120.h,
                child: _buildCategoriesList(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesList(BuildContext context, HomeState state) {
    if (state is HomeLoaded) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          final category = state.categories[index];
          final isSelected = state.selectedCategoryId == category.id;

          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: CategoryCard(
              category: category,
              isSelected: isSelected,
              onTap: () {
                context.read<HomeBloc>().add(SelectCategory(category.id));
              },
              setSelected: (bool selected) {
                context.read<HomeBloc>().add(SelectCategory(category.id));
              },
            ),
          );
        },
      );
    } else {
      // Placeholder categories for loading/initial state
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          final categoryId = index + 1;
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: CategoryCard(
              category: CategoryEntity(
                id: categoryId,
                name: 'Category ${categoryId}',
                icon: '🍕',
                color: 0xFF4CAF50,
              ),
              isSelected: false,
              onTap: () {
                context.read<HomeBloc>().add(SelectCategory(categoryId));
              },
              setSelected: (bool selected) {
                context.read<HomeBloc>().add(SelectCategory(categoryId));
              },
            ),
          );
        },
      );
    }
  }
}
