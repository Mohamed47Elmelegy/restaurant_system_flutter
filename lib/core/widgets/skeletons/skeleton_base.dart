import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/theme/theme_helper.dart';

/// Base class for skeleton components with common reusable elements
class SkeletonBase {
  // Private constructor to prevent instantiation
  SkeletonBase._();

  /// Standard skeleton colors
  static Color get primaryColor => Colors.grey[300]!;
  static Color get secondaryColor => Colors.grey[400]!;
  static Color get lightColor => Colors.grey[200]!;
  static Color get darkColor => Colors.grey[500]!;

  /// Common border radius values
  static BorderRadius get smallRadius => BorderRadius.circular(4.r);
  static BorderRadius get mediumRadius => BorderRadius.circular(8.r);
  static BorderRadius get largeRadius => BorderRadius.circular(12.r);
  static BorderRadius get extraLargeRadius => BorderRadius.circular(16.r);

  /// Basic skeleton container
  static Widget container({
    required double width,
    required double height,
    Color? color,
    BorderRadius? borderRadius,
    EdgeInsets? margin,
    EdgeInsets? padding,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? primaryColor,
        borderRadius: borderRadius ?? smallRadius,
      ),
    );
  }

  /// Full width skeleton container
  static Widget fullWidthContainer({
    required double height,
    Color? color,
    BorderRadius? borderRadius,
    EdgeInsets? margin,
    EdgeInsets? padding,
  }) {
    return container(
      width: double.infinity,
      height: height,
      color: color,
      borderRadius: borderRadius,
      margin: margin,
      padding: padding,
    );
  }

  /// Circular skeleton (for avatars, icons, etc.)
  static Widget circle({
    required double size,
    Color? color,
    EdgeInsets? margin,
  }) {
    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? primaryColor,
        shape: BoxShape.circle,
      ),
    );
  }

  /// Text line skeleton
  static Widget textLine({
    required double width,
    double? height,
    Color? color,
    BorderRadius? borderRadius,
    EdgeInsets? margin,
  }) {
    return container(
      width: width,
      height: height ?? 14.h,
      color: color,
      borderRadius: borderRadius,
      margin: margin,
    );
  }

  /// Multiple text lines skeleton
  static Widget textLines({
    required List<double> widths,
    double? height,
    double? spacing,
    Color? color,
    BorderRadius? borderRadius,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widths.asMap().entries.map((entry) {
        final isLast = entry.key == widths.length - 1;
        return Column(
          children: [
            textLine(
              width: entry.value,
              height: height,
              color: color,
              borderRadius: borderRadius,
            ),
            if (!isLast) SizedBox(height: spacing ?? 4.h),
          ],
        );
      }).toList(),
    );
  }

  /// Card skeleton with theme support
  static Widget card({
    required BuildContext context,
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? color,
    BorderRadius? borderRadius,
  }) {
    return Container(
      padding: padding ?? EdgeInsets.all(16.w),
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? ThemeHelper.getCardBackgroundColor(context),
        borderRadius: borderRadius ?? largeRadius,
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: child,
    );
  }

  /// Button skeleton
  static Widget button({
    required double width,
    required double height,
    Color? color,
    BorderRadius? borderRadius,
    EdgeInsets? margin,
  }) {
    return container(
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius ?? extraLargeRadius,
      margin: margin,
    );
  }

  /// Image placeholder skeleton
  static Widget imagePlaceholder({
    required double width,
    required double height,
    Color? color,
    BorderRadius? borderRadius,
    Widget? child,
    EdgeInsets? margin,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? secondaryColor,
        borderRadius: borderRadius ?? mediumRadius,
      ),
      child:
          child ??
          Center(
            child: circle(
              size: (width * 0.3).clamp(20.w, 60.w),
              color: darkColor,
            ),
          ),
    );
  }

  /// Food item card skeleton - reusable component
  static Widget foodItemCard({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: largeRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image section
          Expanded(
            flex: 5,
            child: imagePlaceholder(
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
          ),
          // Content section
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  fullWidthContainer(height: 16.h),
                  SizedBox(height: 4.h),
                  // Subtitle
                  container(width: 80.w, height: 14.h),
                  const Spacer(),
                  // Price
                  container(width: 60.w, height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// List item skeleton - reusable component
  static Widget listItem({
    required BuildContext context,
    double? imageSize,
    List<double>? textWidths,
    bool showTrailing = false,
    EdgeInsets? padding,
  }) {
    return card(
      context: context,
      padding: padding,
      child: Row(
        children: [
          // Leading image/icon
          if (imageSize != null)
            imagePlaceholder(width: imageSize, height: imageSize),
          if (imageSize != null) SizedBox(width: 12.w),

          // Content
          Expanded(
            child: textLines(
              widths: textWidths ?? [double.infinity, 150.w, 100.w],
              spacing: 8.h,
            ),
          ),

          // Trailing elements
          if (showTrailing) ...[
            SizedBox(width: 12.w),
            Column(
              children: [
                button(width: 32.w, height: 32.h),
                SizedBox(height: 8.h),
                button(width: 32.w, height: 32.h),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// App bar skeleton
  static Widget appBar({
    bool showProfile = true,
    bool showNotification = true,
    List<double>? titleWidths,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          // Profile image
          if (showProfile) ...[circle(size: 48.w), SizedBox(width: 12.w)],

          // Title content
          Expanded(
            child: textLines(
              widths: titleWidths ?? [80.w, 120.w],
              spacing: 4.h,
            ),
          ),

          // Notification icon
          if (showNotification) container(width: 24.w, height: 24.h),
        ],
      ),
    );
  }

  /// Section header skeleton
  static Widget sectionHeader({
    double? width,
    double? height,
    EdgeInsets? padding,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: container(
        width: width ?? 120.w,
        height: height ?? 20.h,
        borderRadius: mediumRadius,
      ),
    );
  }

  /// Grid skeleton builder
  static Widget grid({
    required int itemCount,
    required Widget Function(int index) itemBuilder,
    int crossAxisCount = 2,
    double childAspectRatio = 0.8,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
    EdgeInsets? padding,
    bool shrinkWrap = true,
    ScrollPhysics? physics,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: GridView.builder(
        shrinkWrap: shrinkWrap,
        physics: physics ?? const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: crossAxisSpacing ?? 16.w,
          mainAxisSpacing: mainAxisSpacing ?? 16.h,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) => itemBuilder(index),
      ),
    );
  }

  /// Horizontal list skeleton
  static Widget horizontalList({
    required int itemCount,
    required Widget Function(int index) itemBuilder,
    double? height,
    EdgeInsets? padding,
  }) {
    return SizedBox(
      height: height ?? 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: itemCount,
        itemBuilder: (context, index) => itemBuilder(index),
      ),
    );
  }

  /// Vertical list skeleton
  static Widget verticalList({
    required int itemCount,
    required Widget Function(int index) itemBuilder,
    EdgeInsets? padding,
    ScrollPhysics? physics,
  }) {
    return ListView.builder(
      padding: padding ?? EdgeInsets.all(16.w),
      physics: physics,
      itemCount: itemCount,
      itemBuilder: (context, index) => itemBuilder(index),
    );
  }

  /// Wrapper for skeleton with shimmer effect
  static Widget withShimmer({
    required BuildContext context,
    required Widget child,
    bool enabled = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Skeletonizer(
      enabled: enabled,
      effect: ShimmerEffect(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
        duration: const Duration(milliseconds: 1500),
      ),
      enableSwitchAnimation: true,
      ignoreContainers: false,
      containersColor: isDark ? Colors.grey[800] : Colors.grey[300],
      child: child,
    );
  }
}
