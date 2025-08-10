import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ResponsiveHelper {
  static Widget responsiveLayout({
    required Widget Function(BuildContext, BoxConstraints) builder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout
          return builder(context, constraints);
        } else if (constraints.maxWidth < 1200) {
          // Tablet layout
          return builder(context, constraints);
        } else {
          // Desktop layout
          return builder(context, constraints);
        }
      },
    );
  }

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

  // Web-specific helper methods
  static bool isWeb() {
    return kIsWeb;
  }

  // Helper to prevent RenderFlex overflow on web
  static Widget webSafeColumn({
    required List<Widget> children,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.min,
  }) {
    if (isWeb()) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children.map((child) {
          if (child is Text) {
            return Flexible(child: child);
          }
          return child;
        }).toList(),
      );
    }
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }

  // Helper to create web-safe text widgets
  static Widget webSafeText(
    String text, {
    TextStyle? style,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    if (isWeb()) {
      return Flexible(
        child: Text(
          text,
          style: style,
          overflow: overflow ?? TextOverflow.ellipsis,
          maxLines: maxLines ?? 1,
        ),
      );
    }
    return Text(text, style: style, overflow: overflow, maxLines: maxLines);
  }

  // Helper to create web-safe containers with flexible sizing
  static Widget webSafeContainer({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
  }) {
    if (isWeb()) {
      return Container(
        width: width != null ? width : null,
        height: height != null ? height : null,
        padding: padding,
        margin: margin,
        decoration: decoration,
        child: Flexible(child: child),
      );
    }
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: child,
    );
  }
}
