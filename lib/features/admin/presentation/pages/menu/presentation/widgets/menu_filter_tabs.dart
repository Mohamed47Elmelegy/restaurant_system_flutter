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
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == widget.selectedIndex;
          return GestureDetector(
            onTap: () => widget.onCategorySelected(index),
            child: Container(
              margin: EdgeInsets.only(
                right: index == widget.categories.length - 1 ? 0 : 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.categories[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.lightPrimary
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isSelected)
                    Container(
                      width: 20,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.lightPrimary,
                        borderRadius: BorderRadius.circular(2),
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
