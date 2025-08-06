import 'package:flutter/material.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';

class AppBarHelper {
  /// إنشاء AppBar بدون زر رجوع
  static AppBar appBar({
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
  static AppBar appBarWithBack({
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
  static AppBar appBarWithDefaultBack({
    required String title,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? foregroundColor,
    bool centerTitle = true,
    double elevation = 0,
  }) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false, // إظهار زر الرجوع الافتراضي
      actions: actions,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      centerTitle: centerTitle,
      elevation: elevation,
    );
  }

  /// إنشاء AppBar مع لون للعنوان فقط
  static AppBar appBarWithTitleOnly({
    required String title,
    required Color titleColor,
    List<Widget>? actions,
    bool centerTitle = true,
    double elevation = 0,
  }) {
    return AppBar(
      title: Text(title, style: TextStyle(color: titleColor)),
      actions: actions,
      centerTitle: centerTitle,
      elevation: elevation,
    );
  }

  /// إنشاء Custom App Bar Widget مع ثلاثة أقسام: Menu, Address, Shopping Cart
  static Widget createCustomAppBar({
    required VoidCallback onMenuPressed,
    required VoidCallback onAddressPressed,
    required VoidCallback onCartPressed,
    required String deliveryAddress,
    int cartItemCount = 0,
    Color? backgroundColor,
  }) {
    return CustomAppBar(
      onMenuPressed: onMenuPressed,
      onAddressPressed: onAddressPressed,
      onCartPressed: onCartPressed,
      deliveryAddress: deliveryAddress,
      cartItemCount: cartItemCount,
      backgroundColor: backgroundColor,
    );
  }
}
