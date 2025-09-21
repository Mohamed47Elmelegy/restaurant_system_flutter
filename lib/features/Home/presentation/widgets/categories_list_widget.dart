import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/entities/main_category.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/category_card.dart';
import '../../../../core/widgets/common_state_builder.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class CategoriesListWidget extends StatelessWidget {
  const CategoriesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categories', style: AppTextStyles.senBold20(context)),
          SizedBox(height: 16.h),
          SizedBox(
            height: 120.h,
            child: CommonStateBuilder<HomeBloc, HomeState>(
              isLoading: (state) =>
                  state is HomeLoading || state is HomeInitial,
              hasError: (state) => state is HomeError,
              isEmpty: (state) =>
                  state is HomeLoaded && state.categories.isEmpty,
              getErrorMessage: (state) =>
                  state is HomeError ? state.message : 'حدث خطأ غير متوقع',
              builder: (context, state) {
                if (state is HomeLoaded) {
                  return _buildCategoriesList(context, state);
                }
                return _buildPlaceholderCategories();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context, HomeLoaded state) {
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
              final int id = int.parse(category.id);
              context.read<HomeBloc>().add(SelectCategory(id));
              Navigator.pushNamed(
                context,
                AppRoutes.categoryItems,
                arguments: {'categoryId': id, 'categoryName': category.name},
              );
            },
            setSelected: (selected) {
              context.read<HomeBloc>().add(
                SelectCategory(int.parse(category.id)),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderCategories() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        final category = _generatePlaceholderCategories()[index];
        return Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: CategoryCard(
            category: category,
            isSelected: false,
            onTap: () {},
            setSelected: (selected) {},
          ),
        );
      },
    );
  }

  List<CategoryEntity> _generatePlaceholderCategories() {
    return List.generate(5, (index) {
      return CategoryEntity.fromIntId(
        id: index + 1,
        name: 'Category ${index + 1}',
        icon: 'assets/icons/category_icon.png',
        color: '#FF5733',
        description: 'Description for category ${index + 1}',
        isActive: true,
        sortOrder: index + 1,
      );
    });
  }
}
