import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/theme_helper.dart';
import '../../../domain/entities/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 100.h,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: ThemeHelper.getCardShadow(context),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Color(category.color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Text(category.icon, style: TextStyle(fontSize: 20.sp)),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : ThemeHelper.getPrimaryTextColor(context),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
