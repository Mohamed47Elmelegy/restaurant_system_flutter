import 'package:flutter/material.dart';

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
}
