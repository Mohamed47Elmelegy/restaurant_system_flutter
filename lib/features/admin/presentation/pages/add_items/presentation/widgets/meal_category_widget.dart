import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getPrimaryTextColor(context),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildCategoryButton(
              context,
              'Breakfast',
              selectedCategory == 'Breakfast',
            ),
            SizedBox(width: 12.w),
            _buildCategoryButton(context, 'Lunch', selectedCategory == 'Lunch'),
            SizedBox(width: 12.w),
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeHelper.getPrimaryColorForTheme(context)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? ThemeHelper.getPrimaryColorForTheme(context)
                : ThemeHelper.getSecondaryTextColor(
                    context,
                  ).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? ThemeHelper.getPrimaryTextColor(context)
                : ThemeHelper.getPrimaryTextColor(context),
          ),
        ),
      ),
    );
  }
}
