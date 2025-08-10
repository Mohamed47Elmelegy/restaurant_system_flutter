import 'package:flutter/foundation.dart';

class WebConfig {
  // Web-specific configuration constants
  static const bool enableWebOptimizations = true;
  static const double webMinTextScaleFactor = 0.8;
  static const double webMaxTextScaleFactor = 1.2;

  // Check if running on web platform
  static bool get isWeb => kIsWeb;

  // Web-specific responsive breakpoints
  static const double webMobileBreakpoint = 600;
  static const double webTabletBreakpoint = 1200;
  static const double webDesktopBreakpoint = 1200;

  // Web-specific padding and margin adjustments
  static const double webSafePadding = 8.0;
  static const double webSafeMargin = 4.0;

  // Web-specific font size adjustments
  static const double webFontSizeMultiplier = 0.9;

  // Web-specific container sizing
  static const double webMinContainerHeight = 40.0;
  static const double webMaxContainerHeight = 200.0;

  // Web-specific overflow prevention
  static const bool webPreventOverflow = true;
  static const bool webUseFlexibleText = true;
  static const bool webUseMainAxisSizeMin = true;

  // Get web-optimized dimensions
  static double getWebOptimizedDimension(double dimension) {
    if (!isWeb) return dimension;

    // Apply web-specific adjustments to prevent overflow
    if (dimension < webMinContainerHeight) {
      return webMinContainerHeight;
    }

    if (dimension > webMaxContainerHeight) {
      return webMaxContainerHeight;
    }

    return dimension;
  }

  // Get web-optimized font size
  static double getWebOptimizedFontSize(double fontSize) {
    if (!isWeb) return fontSize;
    return fontSize * webFontSizeMultiplier;
  }

  // Get web-optimized padding
  static double getWebOptimizedPadding(double padding) {
    if (!isWeb) return padding;
    return padding + webSafePadding;
  }

  // Get web-optimized margin
  static double getWebOptimizedMargin(double margin) {
    if (!isWeb) return margin;
    return margin + webSafeMargin;
  }
}
