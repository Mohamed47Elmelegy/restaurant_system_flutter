import 'package:flutter/material.dart';

class AppBarHelper {
  /// إنشاء AppBar بدون زر رجوع
  static AppBar createAppBar({
    required String title,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? foregroundColor,
    bool centerTitle = true,
    double elevation = 0,
  }) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false, // إزالة زر الرجوع
      actions: actions,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      centerTitle: centerTitle,
      elevation: elevation,
    );
  }

  /// إنشاء AppBar مع زر رجوع مخصص
  static AppBar createAppBarWithBack({
    required String title,
    required VoidCallback onBackPressed,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? foregroundColor,
    bool centerTitle = true,
    double elevation = 0,
  }) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed,
      ),
      actions: actions,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      centerTitle: centerTitle,
      elevation: elevation,
    );
  }

  /// إنشاء AppBar مع زر رجوع افتراضي
  static AppBar createAppBarWithDefaultBack({
    required String title,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? foregroundColor,
    bool centerTitle = true,
    double elevation = 0,
  }) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: true, // إظهار زر الرجوع الافتراضي
      actions: actions,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      centerTitle: centerTitle,
      elevation: elevation,
    );
  }
}
