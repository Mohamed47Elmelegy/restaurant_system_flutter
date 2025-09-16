import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';

class Constants {
  // ================== MEDIA QUERY ==================
  static Size mediaQuery = MediaQuery.sizeOf(
    navigatorKey.currentState!.context,
  );

  // ================== PLATFORM DETECTION ==================
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;
  static bool get isWeb => !Platform.isAndroid && !Platform.isIOS;
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  // ================== ANIMATION DURATIONS ==================
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 3);

  // ================== SPACING ==================
  static final double extraSmallSpacing = 4.w;
  static final double smallSpacing = 8.w;
  static final double mediumSpacing = 16.w;
  static final double largeSpacing = 24.w;
  static final double extraLargeSpacing = 32.w;

  // ================== BORDER RADIUS ==================
  static final BorderRadius smallRadius = BorderRadius.circular(8.r);
  static final BorderRadius mediumRadius = BorderRadius.circular(12.r);
  static final BorderRadius largeRadius = BorderRadius.circular(16.r);
  static final BorderRadius extraLargeRadius = BorderRadius.circular(24.r);

  // ================== ELEVATION ==================
  static const double lowElevation = 2.0;
  static const double mediumElevation = 4.0;
  static const double highElevation = 8.0;
  static const double extraHighElevation = 16.0;

  // ================== ICON SIZES ==================
  static final double smallIcon = 16.sp;
  static final double mediumIcon = 24.sp;
  static final double largeIcon = 32.sp;
  static final double extraLargeIcon = 48.sp;

  // ================== BUTTON SIZES ==================
  static final double buttonHeight = 48.h;
  static final double smallButtonHeight = 36.h;
  static final double largeButtonHeight = 56.h;

  // ================== PADDING ==================
  static final EdgeInsets smallPadding = EdgeInsets.all(8.w);
  static final EdgeInsets mediumPadding = EdgeInsets.all(16.w);
  static final EdgeInsets largePadding = EdgeInsets.all(24.w);
  static final EdgeInsets extraLargePadding = EdgeInsets.all(32.w);

  // ================== SCREEN BREAKPOINTS ==================
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // ================== DIALOG CONSTANTS ==================
  static final double dialogMaxWidth = 400.w;
  static final double dialogBorderRadius = 16.r;

  // ================== APP SPECIFIC CONSTANTS ==================
  static const int maxCartItems = 99;
  static const int maxOrderHistory = 50;
  static const double deliveryFeeRate = 0.15; // 15%
  static const double taxRate = 0.15; // 15%

  // ================== NETWORK TIMEOUTS ==================
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ================== CACHE DURATIONS ==================
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration mediumCacheDuration = Duration(hours: 1);
  static const Duration longCacheDuration = Duration(days: 1);

  // ================== VALIDATION CONSTANTS ==================
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;

  // ================== IMAGE CONSTANTS ==================
  static const double maxImageSizeMB = 5.0;
  static const List<String> allowedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];
  static const double imageQuality = 0.8;

  // ================== RESPONSIVE HELPERS ==================
  static bool get isSmallScreen => mediaQuery.width < mobileBreakpoint;
  static bool get isMediumScreen =>
      mediaQuery.width >= mobileBreakpoint &&
      mediaQuery.width < tabletBreakpoint;
  static bool get isLargeScreen => mediaQuery.width >= tabletBreakpoint;

  // ================== COMMON STRINGS ==================
  static const String appName = 'نظام المطعم';
  static const String appNameEnglish = 'Restaurant System';
  static const String loadingText = 'جاري التحميل...';
  static const String errorText = 'حدث خطأ ما';
  static const String retryText = 'إعادة المحاولة';
  static const String confirmText = 'تأكيد';
  static const String cancelText = 'إلغاء';
  static const String okText = 'حسناً';
  static const String saveText = 'حفظ';
  static const String editText = 'تعديل';
  static const String deleteText = 'حذف';
  static const String addText = 'إضافة';

  // ================== NOTIFICATION TYPES ==================
  static const String successNotification = 'success';
  static const String errorNotification = 'error';
  static const String warningNotification = 'warning';
  static const String infoNotification = 'info';
}
