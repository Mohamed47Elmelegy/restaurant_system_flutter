import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getResponsiveWidth(BuildContext context, double percentage) {
    return getScreenWidth(context) * percentage;
  }

  static double getResponsiveHeight(BuildContext context, double percentage) {
    return getScreenHeight(context) * percentage;
  }

  // ScreenUtil helpers with MediaQuery fallback
  static double getAdaptiveWidth(double width) {
    return width.w;
  }

  static double getAdaptiveHeight(double height) {
    return height.h;
  }

  static double getAdaptiveRadius(double radius) {
    return radius.r;
  }

  static double getAdaptiveFontSize(double fontSize) {
    return fontSize.sp;
  }

  static EdgeInsets getAdaptivePadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) {
      return EdgeInsets.all(all.w);
    }
    return EdgeInsets.only(
      left: left?.w ?? 0,
      top: top?.h ?? 0,
      right: right?.w ?? 0,
      bottom: bottom?.h ?? 0,
    );
  }

  static EdgeInsets getAdaptiveSymmetricPadding({
    double? horizontal,
    double? vertical,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal?.w ?? 0,
      vertical: vertical?.h ?? 0,
    );
  }

  static SizedBox getAdaptiveSizedBox({double? width, double? height}) {
    return SizedBox(width: width?.w, height: height?.h);
  }

  // MediaQuery specific helpers
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getBottomPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static double getSafeAreaHeight(BuildContext context) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // Combined responsive helpers
  static double getResponsiveValue(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop.w;
    } else if (isTablet(context) && tablet != null) {
      return tablet.w;
    } else if (isMobile(context) && mobile != null) {
      return mobile.w;
    }
    return mobile?.w ?? 0;
  }

  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else if (isMobile(context) && mobile != null) {
      return mobile;
    }
    return mobile ?? EdgeInsets.zero;
  }
}
