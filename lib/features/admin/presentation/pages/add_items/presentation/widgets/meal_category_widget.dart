import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/theme_helper.dart';

class MealCategoryWidget extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const MealCategoryWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MEAL CATEGORY',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getPrimaryTextColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildCategoryButton(
              context,
              'Breakfast',
              selectedCategory == 'Breakfast',
            ),
            const SizedBox(width: 12),
            _buildCategoryButton(context, 'Lunch', selectedCategory == 'Lunch'),
            const SizedBox(width: 12),
            _buildCategoryButton(
              context,
              'Dinner',
              selectedCategory == 'Dinner',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton(
    BuildContext context,
    String category,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => onCategoryChanged(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.lightPrimary
                : ThemeHelper.getSecondaryTextColor(
                    context,
                  ).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : ThemeHelper.getPrimaryTextColor(context),
          ),
        ),
      ),
    );
  }
}
