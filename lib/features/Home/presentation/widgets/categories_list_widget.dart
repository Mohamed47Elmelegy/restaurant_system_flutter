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
    final categories = state is HomeLoaded
        ? state.categories
        : _generatePlaceholderCategories();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = state is HomeLoaded
            ? state.selectedCategoryId == category.id
            : false;

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
  }

  List<CategoryEntity> _generatePlaceholderCategories() {
    return List.generate(5, (index) {
      return CategoryEntity(
        id: index + 1,
        name: 'Category ${index + 1}',
        icon: '🍕',
        color: 0xFF4CAF50,
      );
    });
  }
}
