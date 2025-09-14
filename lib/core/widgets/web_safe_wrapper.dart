import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A wrapper widget that automatically handles web-specific rendering issues
/// and prevents RenderFlex overflow errors
class WebSafeWrapper extends StatelessWidget {
  final Widget child;
  final bool enableOverflowProtection;
  final bool useFlexibleText;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const WebSafeWrapper({
    super.key,
    required this.child,
    this.enableOverflowProtection = true,
    this.useFlexibleText = true,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || !enableOverflowProtection) {
      return child;
    }

    // If child is a Column, wrap its text children with Flexible
    if (child is Column) {
      return _wrapColumnWithWebSafeChildren(child as Column);
    }

    // If child is a Row, wrap its text children with Flexible
    if (child is Row) {
      return _wrapRowWithWebSafeChildren(child as Row);
    }

    // For other widgets, return as is
    return child;
  }

  Widget _wrapColumnWithWebSafeChildren(Column column) {
    return Column(
      mainAxisSize: column.mainAxisSize,
      mainAxisAlignment: column.mainAxisAlignment,
      crossAxisAlignment: column.crossAxisAlignment,
      children: column.children.map((child) {
        return _wrapChildWithWebSafeProtection(child);
      }).toList(),
    );
  }

  Widget _wrapRowWithWebSafeChildren(Row row) {
    return Row(
      mainAxisSize: row.mainAxisSize,
      mainAxisAlignment: row.mainAxisAlignment,
      crossAxisAlignment: row.crossAxisAlignment,
      children: row.children.map((child) {
        return _wrapChildWithWebSafeProtection(child);
      }).toList(),
    );
  }

  Widget _wrapChildWithWebSafeProtection(Widget child) {
    if (child is Text && useFlexibleText) {
      return Flexible(child: child);
    }

    if (child is SizedBox && child.height != null && child.height! < 40) {
      // Ensure minimum height for web to prevent overflow
      return SizedBox(width: child.width, height: 40, child: child.child);
    }

    if (child is Padding) {
      // Ensure padding doesn't cause overflow on web
      final padding = child.padding;
      if (padding is EdgeInsets) {
        return Padding(
          padding: EdgeInsets.only(
            left: padding.left,
            top: padding.top,
            right: padding.right,
            bottom: padding.bottom + 4.0, // Add extra bottom padding for web
          ),
          child: child.child,
        );
      }
      // If padding is not EdgeInsets, return as is
      return child;
    }

    return child;
  }
}

/// Extension to easily make any widget web-safe
extension WebSafeExtension on Widget {
  Widget get webSafe => WebSafeWrapper(child: this);

  Widget webSafeWith({
    bool enableOverflowProtection = true,
    bool useFlexibleText = true,
    MainAxisSize mainAxisSize = MainAxisSize.min,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  }) {
    return WebSafeWrapper(
      enableOverflowProtection: enableOverflowProtection,
      useFlexibleText: useFlexibleText,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      child: this,
    );
  }
}
