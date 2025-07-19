import 'package:flutter/material.dart';
import 'app_colors.dart';

class ThemeHelper {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color getBackgroundColor(BuildContext context) {
    return isDarkMode(context)
        ? AppColors.darkBackground
        : AppColors.lightBackground;
  }

  static Color getSurfaceColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.darkSurface : Colors.white;
  }

  static Color getPrimaryTextColor(BuildContext context) {
    return isDarkMode(context)
        ? AppColors.darkTextPrimary
        : AppColors.lightTextMain;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return isDarkMode(context)
        ? AppColors.darkTextSecondary
        : AppColors.lightTextMain.withValues(alpha: 0.7);
  }

  static Color getBorderColor(BuildContext context, bool isActive) {
    if (isActive) return AppColors.lightPrimary;
    return Colors.transparent;
  }

  static Color getIconColor(BuildContext context, bool isActive) {
    if (isActive) return AppColors.lightPrimary;
    return isDarkMode(context)
        ? AppColors.darkTextSecondary
        : AppColors.lightTextMain.withValues(alpha: 0.5);
  }

  static Color getPrimaryColor() {
    return AppColors.lightPrimary;
  }

  // Shadow Helpers - Dynamic and Reusable
  static List<BoxShadow> getCardShadow(BuildContext context) {
    final isDark = isDarkMode(context);
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.grey.withValues(alpha: 0.15),
        spreadRadius: 2,
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.05),
        spreadRadius: 0,
        blurRadius: 2,
        offset: const Offset(0, 1),
      ),
    ];
  }

  static List<BoxShadow> getBannerShadow(BuildContext context) {
    final isDark = isDarkMode(context);
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.4)
            : AppColors.lightPrimary.withValues(alpha: 0.3),
        spreadRadius: 3,
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.2)
            : AppColors.lightPrimary.withValues(alpha: 0.1),
        spreadRadius: 0,
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static List<BoxShadow> getInputFieldShadow(BuildContext context) {
    return [
      BoxShadow(
        color: AppColors.lightPrimary.withValues(alpha: 0.15),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: AppColors.lightPrimary.withValues(alpha: 0.05),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static List<BoxShadow> getButtonShadow(BuildContext context) {
    return [
      BoxShadow(
        color: AppColors.lightPrimary.withValues(alpha: 0.4),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: AppColors.lightPrimary.withValues(alpha: 0.2),
        blurRadius: 6,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static List<BoxShadow> getSocialButtonShadow(BuildContext context) {
    return [
      BoxShadow(
        color: AppColors.lightPrimary.withValues(alpha: 0.1),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: AppColors.lightPrimary.withValues(alpha: 0.05),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static BoxDecoration getCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: getSurfaceColor(context),
      borderRadius: BorderRadius.circular(16),
      boxShadow: getCardShadow(context),
    );
  }

  static BoxDecoration getGradientDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.lightPrimary, AppColors.lightSecondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.lightPrimary.withValues(alpha: 0.3),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  static BoxDecoration getLogoDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.lightPrimary, AppColors.lightSecondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: AppColors.lightPrimary.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static TextStyle getTitleStyle(BuildContext context) {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: getPrimaryTextColor(context),
    );
  }

  static TextStyle getSubtitleStyle(BuildContext context) {
    return TextStyle(fontSize: 16, color: getSecondaryTextColor(context));
  }

  static TextStyle getButtonTextStyle(BuildContext context, bool isActive) {
    return TextStyle(
      color: isActive ? Colors.white : Colors.grey[600],
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }
}
