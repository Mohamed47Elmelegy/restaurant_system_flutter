import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/text_styles.dart';
import '../theme/theme_helper.dart';

class EmptyPageWidget extends StatelessWidget {
  /// The icon to display in the empty state
  final IconData icon;

  /// The main title text
  final String title;

  /// The subtitle/description text
  final String subtitle;

  /// Optional custom icon size (defaults to 80)
  final double? iconSize;

  /// Optional custom icon color (uses theme secondary text color if null)
  final Color? iconColor;

  /// Optional custom title color (uses theme primary text color if null)
  final Color? titleColor;

  /// Optional custom subtitle color (uses theme secondary text color if null)
  final Color? subtitleColor;

  /// Optional action button text
  final String? actionButtonText;

  /// Optional action button callback
  final VoidCallback? onActionButtonPressed;

  /// Optional action button color (uses theme primary color if null)
  final Color? actionButtonColor;

  /// Optional spacing between elements (defaults to 16)
  final double? spacing;

  /// Whether to center the content vertically (defaults to true)
  final bool centerVertically;

  /// Optional custom title text style
  final TextStyle? titleTextStyle;

  /// Optional custom subtitle text style
  final TextStyle? subtitleTextStyle;

  const EmptyPageWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconSize,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
    this.actionButtonText,
    this.onActionButtonPressed,
    this.actionButtonColor,
    this.spacing,
    this.centerVertically = true,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveSpacing = spacing ?? 16.0;
    final double effectiveIconSize = iconSize ?? 80.0;

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon
        Icon(
          icon,
          size: effectiveIconSize.w,
          color: iconColor ?? ThemeHelper.getSecondaryTextColor(context),
        ),

        SizedBox(height: effectiveSpacing.h),

        // Title
        Text(
          title,
          style:
              titleTextStyle ??
              AppTextStyles.senBold18(context).copyWith(
                color: titleColor ?? ThemeHelper.getPrimaryTextColor(context),
              ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: (effectiveSpacing / 2).h),

        // Subtitle
        Text(
          subtitle,
          style:
              subtitleTextStyle ??
              AppTextStyles.senRegular14(context).copyWith(
                color:
                    subtitleColor ?? ThemeHelper.getSecondaryTextColor(context),
              ),
          textAlign: TextAlign.center,
        ),

        // Optional Action Button
        if (actionButtonText != null && onActionButtonPressed != null) ...[
          SizedBox(height: (effectiveSpacing * 1.5).h),
          _buildActionButton(context),
        ],
      ],
    );

    if (centerVertically) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: content,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: content,
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return ElevatedButton(
      onPressed: onActionButtonPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: actionButtonColor ?? ThemeHelper.getPrimaryColor(),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 2,
      ),
      child: Text(
        actionButtonText!,
        style: AppTextStyles.senBold14(context).copyWith(color: Colors.white),
      ),
    );
  }
}

// Predefined common empty states for quick usage
class EmptyPagePresets {
  /// Empty state for no orders
  static EmptyPageWidget noOrders(
    BuildContext context, {
    VoidCallback? onAction,
  }) {
    return EmptyPageWidget(
      icon: Icons.receipt_long_outlined,
      title: 'لا توجد طلبات حتى الآن',
      subtitle: 'ابدأ بطلب طعامك المفضل',
      actionButtonText: onAction != null ? 'تصفح القائمة' : null,
      onActionButtonPressed: onAction,
    );
  }

  /// Empty state for no addresses
  static EmptyPageWidget noAddresses(
    BuildContext context, {
    VoidCallback? onAction,
  }) {
    return EmptyPageWidget(
      icon: Icons.location_off,
      title: 'No Saved Addresses',
      subtitle: 'Add your first address to make delivery easier',
      actionButtonText: onAction != null ? 'Add Address' : null,
      onActionButtonPressed: onAction,
    );
  }

  /// Empty state for no favorites
  static EmptyPageWidget noFavorites(
    BuildContext context, {
    VoidCallback? onAction,
  }) {
    return EmptyPageWidget(
      icon: Icons.favorite_border,
      title: 'No Favorites Yet',
      subtitle: 'Start adding your favorite items to easily find them later',
      actionButtonText: onAction != null ? 'Explore Menu' : null,
      onActionButtonPressed: onAction,
      actionButtonColor: ThemeHelper.getPrimaryColor(),


    );
  }

  /// Empty state for no cart items
  static EmptyPageWidget emptyCart(
    BuildContext context, {
    VoidCallback? onAction,
  }) {
    return EmptyPageWidget(
      icon: Icons.shopping_cart_outlined,
      title: 'Your Cart is Empty',
      subtitle: 'Add some delicious items to your cart',
      actionButtonText: onAction != null ? 'Start Shopping' : null,
      onActionButtonPressed: onAction,
    );
  }

  /// Empty state for no search results
  static EmptyPageWidget noSearchResults(
    BuildContext context, {
    String? searchTerm,
  }) {
    return EmptyPageWidget(
      icon: Icons.search_off,
      title: 'No Results Found',
      subtitle: searchTerm != null
          ? 'No results found for "$searchTerm".\nTry adjusting your search terms.'
          : 'Try adjusting your search terms or browse our categories.',
    );
  }

  /// Empty state for no notifications
  static EmptyPageWidget noNotifications(BuildContext context) {
    return const EmptyPageWidget(
      icon: Icons.notifications_none,
      title: 'No Notifications',
      subtitle: 'We\'ll notify you when there\'s something new',
    );
  }

  /// Empty state for no internet connection
  static EmptyPageWidget noConnection(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    return EmptyPageWidget(
      icon: Icons.wifi_off,
      title: 'No Internet Connection',
      subtitle: 'Please check your connection and try again',
      actionButtonText: onRetry != null ? 'Retry' : null,
      onActionButtonPressed: onRetry,
    );
  }

  /// Generic empty state
  static EmptyPageWidget generic(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyPageWidget(
      icon: icon,
      title: title,
      subtitle: subtitle,
      actionButtonText: actionText,
      onActionButtonPressed: onAction,
    );
  }
}
