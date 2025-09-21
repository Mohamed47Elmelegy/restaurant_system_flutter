import 'package:flutter/material.dart';

/// Constants for order tabs configuration
class OrderTabConstants {
  static const int tabCount = 3;

  /// Tab labels in Arabic
  static const List<String> tabLabels = ['نشطة', 'مكتملة', 'ملغية'];

  /// Tab widgets for TabBar
  static const List<Tab> tabs = [
    Tab(text: 'نشطة'),
    Tab(text: 'مكتملة'),
    Tab(text: 'ملغية'),
  ];

  /// Get tab index by name
  static int getTabIndex(String tabName) {
    return tabLabels.indexOf(tabName);
  }

  /// Get tab name by index
  static String getTabName(int index) {
    if (index >= 0 && index < tabLabels.length) {
      return tabLabels[index];
    }
    return tabLabels.first;
  }

  /// Check if tab name is valid
  static bool isValidTabName(String tabName) {
    return tabLabels.contains(tabName);
  }
}
