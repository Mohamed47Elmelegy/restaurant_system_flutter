import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/constants/app_icons.dart';
import '../../../../../../../core/theme/theme_helper.dart';

class IngredientSelectionWidget extends StatelessWidget {
  final String categoryTitle;
  final List<IngredientItem> ingredients;
  final Set<String> selectedIngredients;
  final ValueChanged<String> onIngredientToggled;
  final VoidCallback? onSeeAllPressed;

  const IngredientSelectionWidget({
    super.key,
    required this.categoryTitle,
    required this.ingredients,
    required this.selectedIngredients,
    required this.onIngredientToggled,
    this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categoryTitle,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getPrimaryTextColor(context),
              ),
            ),
            if (onSeeAllPressed != null)
              GestureDetector(
                onTap: onSeeAllPressed,
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ThemeHelper.getSecondaryTextColor(context),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16.sp,
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              final isSelected = selectedIngredients.contains(ingredient.id);

              return Padding(
                padding: EdgeInsets.only(
                  right: index < ingredients.length - 1 ? 12.w : 0,
                ),
                child: _buildIngredientButton(context, ingredient, isSelected),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientButton(
    BuildContext context,
    IngredientItem ingredient,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => onIngredientToggled(ingredient.id),
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? ThemeHelper.getPrimaryColorForTheme(
                      context,
                    ).withValues(alpha: 0.1)
                  : ThemeHelper.getInputBackgroundColor(context),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? ThemeHelper.getPrimaryColorForTheme(context)
                    : ThemeHelper.getSecondaryTextColor(
                        context,
                      ).withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: Image.asset(
                ingredient.iconPath,
                width: 24.w,
                height: 24.h,
                color: isSelected
                    ? ThemeHelper.getPrimaryColorForTheme(context)
                    : ThemeHelper.getSecondaryTextColor(context),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            ingredient.name,
            style: TextStyle(
              fontSize: 12.sp,
              color: isSelected
                  ? ThemeHelper.getPrimaryColorForTheme(context)
                  : ThemeHelper.getPrimaryTextColor(context),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class IngredientItem {
  final String id;
  final String name;
  final String iconPath;

  const IngredientItem({
    required this.id,
    required this.name,
    required this.iconPath,
  });
}

// Predefined ingredient lists
class IngredientData {
  static const List<IngredientItem> basicIngredients = [
    IngredientItem(id: 'salt', name: 'Salt', iconPath: AppIcons.salt),
    IngredientItem(id: 'chicken', name: 'Chicken', iconPath: AppIcons.chicken),
    IngredientItem(id: 'onion', name: 'Onion', iconPath: AppIcons.onion),
    IngredientItem(id: 'garlic', name: 'Garlic', iconPath: AppIcons.garlic),
    IngredientItem(
      id: 'chili_pepper',
      name: 'Pappers',
      iconPath: AppIcons.chiliPepper,
    ),
    IngredientItem(id: 'ginger', name: 'Ginger', iconPath: AppIcons.ginger),
  ];

  static const List<IngredientItem> fruitIngredients = [
    IngredientItem(id: 'avocado', name: 'Avocado', iconPath: AppIcons.avocado),
    IngredientItem(id: 'apple', name: 'Apple', iconPath: AppIcons.apple),
    IngredientItem(
      id: 'blueberry',
      name: 'Blueberry',
      iconPath: AppIcons.blueberry,
    ),
    IngredientItem(
      id: 'broccoli',
      name: 'Broccoli',
      iconPath: AppIcons.broccoli,
    ),
    IngredientItem(id: 'orange', name: 'Orange', iconPath: AppIcons.orange),
    IngredientItem(id: 'walnut', name: 'Walnut', iconPath: AppIcons.walnut),
  ];
}
