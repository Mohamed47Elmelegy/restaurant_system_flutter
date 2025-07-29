import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';

class MenuFilterTabs extends StatefulWidget {
  final List<String> categories;
  final Function(int) onCategorySelected;
  final int selectedIndex;

  const MenuFilterTabs({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    this.selectedIndex = 0,
  });

  @override
  State<MenuFilterTabs> createState() => _MenuFilterTabsState();
}

class _MenuFilterTabsState extends State<MenuFilterTabs> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        itemBuilder: (context, index) {
          final isSelected = index == widget.selectedIndex;
          return Container(
            margin: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () => widget.onCategorySelected(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.categories[index],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.lightPrimary
                          : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  if (isSelected)
                    Container(
                      width: 30.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: AppColors.lightPrimary,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
