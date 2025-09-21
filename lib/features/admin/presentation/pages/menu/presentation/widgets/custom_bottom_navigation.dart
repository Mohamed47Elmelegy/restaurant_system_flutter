import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback? onAddPressed;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Grid Icon
          _buildNavItem(
            icon: Icons.grid_view,
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),

          // Menu Icon
          _buildNavItem(
            icon: Icons.menu,
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),

          // Add Button (Center)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.lightPrimary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.lightPrimary.withValues(alpha: 0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: onAddPressed,
              icon: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),

          // Notifications Icon
          _buildNavItem(
            icon: Icons.notifications,
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
          ),

          // Profile Icon
          _buildNavItem(
            icon: Icons.person,
            isSelected: currentIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.lightPrimary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.lightPrimary : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }
}
