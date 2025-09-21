import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import '../theme/theme_helper.dart';

/// Platform-specific dialog constants for Android and iOS
class DialogConstants {
  DialogConstants._();

  // ================== DIALOG TYPES ==================

  /// Shows platform-specific alert dialog
  static Future<void> showPlatformAlert({
    required BuildContext context,
    required String title,
    required String content,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = true,
  }) async {
    if (Platform.isIOS) {
      return _showIOSAlert(
        context: context,
        title: title,
        content: content,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
        barrierDismissible: barrierDismissible,
      );
    } else {
      return _showAndroidAlert(
        context: context,
        title: title,
        content: content,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
        barrierDismissible: barrierDismissible,
      );
    }
  }

  /// Shows platform-specific confirmation dialog
  static Future<bool?> showPlatformConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    bool isDestructive = false,
  }) async {
    if (Platform.isIOS) {
      return _showIOSConfirmation(
        context: context,
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
      );
    } else {
      return _showAndroidConfirmation(
        context: context,
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
      );
    }
  }

  /// Shows platform-specific loading dialog
  static void showPlatformLoading({
    required BuildContext context,
    String? message,
  }) {
    if (Platform.isIOS) {
      _showIOSLoading(context: context, message: message);
    } else {
      _showAndroidLoading(context: context, message: message);
    }
  }

  /// Shows platform-specific success dialog
  static Future<void> showPlatformSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'حسناً',
    VoidCallback? onPressed,
  }) async {
    if (Platform.isIOS) {
      return _showIOSSuccess(
        context: context,
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
      );
    } else {
      return _showAndroidSuccess(
        context: context,
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
      );
    }
  }

  /// Shows platform-specific error dialog
  static Future<void> showPlatformError({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'حسناً',
    VoidCallback? onPressed,
  }) async {
    if (Platform.isIOS) {
      return _showIOSError(
        context: context,
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
      );
    } else {
      return _showAndroidError(
        context: context,
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
      );
    }
  }

  // ================== ANDROID SPECIFIC DIALOGS ==================

  static Future<void> _showAndroidAlert({
    required BuildContext context,
    required String title,
    required String content,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = true,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ThemeHelper.getSurfaceColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Text(
            title,
            style: AppTextStyles.senBold18(
              context,
            ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          ),
          content: Text(
            content,
            style: AppTextStyles.senRegular16(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
          ),
          actions: [
            if (secondaryButtonText != null)
              TextButton(
                onPressed:
                    onSecondaryPressed ?? () => Navigator.of(context).pop(),
                child: Text(
                  secondaryButtonText,
                  style: AppTextStyles.senMedium16(
                    context,
                  ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
                ),
              ),
            if (primaryButtonText != null)
              ElevatedButton(
                onPressed:
                    onPrimaryPressed ?? () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  primaryButtonText,
                  style: AppTextStyles.senMedium16(
                    context,
                  ).copyWith(color: Colors.white),
                ),
              ),
          ],
        );
      },
    );
  }

  static Future<bool?> _showAndroidConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    bool isDestructive = false,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ThemeHelper.getSurfaceColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Text(
            title,
            style: AppTextStyles.senBold18(
              context,
            ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          ),
          content: Text(
            content,
            style: AppTextStyles.senRegular16(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: AppTextStyles.senMedium16(
                  context,
                ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDestructive
                    ? AppColors.error
                    : AppColors.lightPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                confirmText,
                style: AppTextStyles.senMedium16(
                  context,
                ).copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  static void _showAndroidLoading({
    required BuildContext context,
    String? message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: ThemeHelper.getSurfaceColor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.lightPrimary,
                  ),
                ),
                if (message != null) ...[
                  SizedBox(height: 16.h),
                  Text(
                    message,
                    style: AppTextStyles.senRegular16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> _showAndroidSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'حسناً',
    VoidCallback? onPressed,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ThemeHelper.getSurfaceColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 64.sp),
              SizedBox(height: 16.h),
              Text(
                title,
                style: AppTextStyles.senBold18(
                  context,
                ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                style: AppTextStyles.senRegular16(
                  context,
                ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                buttonText,
                style: AppTextStyles.senMedium16(
                  context,
                ).copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _showAndroidError({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'حسناً',
    VoidCallback? onPressed,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ThemeHelper.getSurfaceColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, color: AppColors.error, size: 64.sp),
              SizedBox(height: 16.h),
              Text(
                title,
                style: AppTextStyles.senBold18(
                  context,
                ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                style: AppTextStyles.senRegular16(
                  context,
                ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                buttonText,
                style: AppTextStyles.senMedium16(
                  context,
                ).copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================== iOS SPECIFIC DIALOGS ==================

  static Future<void> _showIOSAlert({
    required BuildContext context,
    required String title,
    required String content,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = true,
  }) async {
    return showCupertinoDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title, style: AppTextStyles.senBold18(context)),
          content: Text(content, style: AppTextStyles.senRegular16(context)),
          actions: [
            if (secondaryButtonText != null)
              CupertinoDialogAction(
                onPressed:
                    onSecondaryPressed ?? () => Navigator.of(context).pop(),
                child: Text(
                  secondaryButtonText,
                  style: AppTextStyles.senMedium16(
                    context,
                  ).copyWith(color: CupertinoColors.systemBlue),
                ),
              ),
            if (primaryButtonText != null)
              CupertinoDialogAction(
                onPressed:
                    onPrimaryPressed ?? () => Navigator.of(context).pop(),
                child: Text(
                  primaryButtonText,
                  style: AppTextStyles.senBold16(
                    context,
                  ).copyWith(color: CupertinoColors.systemBlue),
                ),
              ),
          ],
        );
      },
    );
  }

  static Future<bool?> _showIOSConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    bool isDestructive = false,
  }) async {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title, style: AppTextStyles.senBold18(context)),
          content: Text(content, style: AppTextStyles.senRegular16(context)),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: AppTextStyles.senMedium16(
                  context,
                ).copyWith(color: CupertinoColors.systemBlue),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: isDestructive,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                confirmText,
                style: AppTextStyles.senBold16(context).copyWith(
                  color: isDestructive
                      ? CupertinoColors.destructiveRed
                      : CupertinoColors.systemBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void _showIOSLoading({
    required BuildContext context,
    String? message,
  }) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: CupertinoAlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CupertinoActivityIndicator(radius: 15),
                if (message != null) ...[
                  SizedBox(height: 16.h),
                  Text(
                    message,
                    style: AppTextStyles.senRegular16(context),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> _showIOSSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'حسناً',
    VoidCallback? onPressed,
  }) async {
    return showCupertinoDialog<void>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title, style: AppTextStyles.senBold18(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: CupertinoColors.systemGreen,
                size: 40.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                style: AppTextStyles.senRegular16(context),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
              child: Text(
                buttonText,
                style: AppTextStyles.senBold16(
                  context,
                ).copyWith(color: CupertinoColors.systemGreen),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _showIOSError({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'حسناً',
    VoidCallback? onPressed,
  }) async {
    return showCupertinoDialog<void>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title, style: AppTextStyles.senBold18(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Icon(
                CupertinoIcons.exclamationmark_triangle_fill,
                color: CupertinoColors.destructiveRed,
                size: 40.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                style: AppTextStyles.senRegular16(context),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
              child: Text(
                buttonText,
                style: AppTextStyles.senBold16(
                  context,
                ).copyWith(color: CupertinoColors.destructiveRed),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================== COMMON DIALOGS ==================

  /// Order success dialog
  static Future<void> showOrderSuccessDialog({
    required BuildContext context,
    required String orderId,
    VoidCallback? onConfirm,
  }) async {
    return showPlatformSuccess(
      context: context,
      title: 'تم إنشاء الطلب بنجاح!',
      message: 'رقم الطلب: #$orderId',
      buttonText: 'حسناً',
      onPressed: onConfirm,
    );
  }

  /// Delete confirmation dialog
  static Future<bool?> showDeleteConfirmation({
    required BuildContext context,
    required String itemName,
  }) async {
    return showPlatformConfirmation(
      context: context,
      title: 'تأكيد الحذف',
      content:
          'هل أنت متأكد من حذف "$itemName"؟\nلا يمكن التراجع عن هذا الإجراء.',
      confirmText: 'حذف',
      cancelText: 'إلغاء',
      isDestructive: true,
    );
  }

  /// Logout confirmation dialog
  static Future<bool?> showLogoutConfirmation({
    required BuildContext context,
  }) async {
    return showPlatformConfirmation(
      context: context,
      title: 'تسجيل الخروج',
      content: 'هل أنت متأكد من تسجيل الخروج؟',
      confirmText: 'تسجيل الخروج',
      cancelText: 'إلغاء',
      isDestructive: false,
    );
  }

  /// Network error dialog
  static Future<void> showNetworkError({
    required BuildContext context,
    VoidCallback? onRetry,
  }) async {
    return showPlatformError(
      context: context,
      title: 'خطأ في الاتصال',
      message: 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى.',
      buttonText: onRetry != null ? 'إعادة المحاولة' : 'حسناً',
      onPressed: onRetry,
    );
  }

  /// Permission request dialog
  static Future<bool?> showPermissionRequest({
    required BuildContext context,
    required String permissionName,
    required String reason,
  }) async {
    return showPlatformConfirmation(
      context: context,
      title: 'طلب صلاحية',
      content: 'نحتاج إلى صلاحية $permissionName\n$reason',
      confirmText: 'السماح',
      cancelText: 'رفض',
      isDestructive: false,
    );
  }
}
