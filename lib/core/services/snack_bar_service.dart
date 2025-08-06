import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:lottie/lottie.dart';
import '../theme/theme_helper.dart';

class Toast {
  void show(
    BuildContext context,
    String description,

    ToastificationType type,
    ToastificationStyle style, {
    Widget? icon,
  }) {
    toastification.show(
      context: context,
      type: type,
      style: style,

      description: Text(description),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 2),
      showProgressBar: true,
      closeOnClick: true,
      dragToClose: true,
      applyBlurEffect: true,
      icon: icon,
    );
  }
}

class SnackBarService {
  static void showSuccessMessage(
    BuildContext context,
    String msg, {
    String? title,
    String? username,
  }) {
    String finalTitle;

    if (title != null) {
      finalTitle = title;
    } else if (username != null) {
      finalTitle = "مرحبا بك $username";
    } else {
      finalTitle = "نجاح";
    }

    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: Text(
        finalTitle,
        style: TextStyle(
          fontFamily: 'Sen',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ThemeHelper.getPrimaryTextColor(context),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      description: Text(
        msg,
        style: TextStyle(
          fontFamily: 'Sen',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ThemeHelper.getSecondaryTextColor(context),
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      icon: SizedBox(
        width: 60,
        height: 60,
        child: Lottie.asset(
          "assets/snakebarJson/face_success_icon.json",
          repeat: false,
          fit: BoxFit.contain,
        ),
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 8),
      showProgressBar: true,
      closeOnClick: true,
      dragToClose: true,
      applyBlurEffect: true,
      backgroundColor: ThemeHelper.getCardBackgroundColor(context),
      foregroundColor: ThemeHelper.getPrimaryTextColor(context),
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
    );
  }

  static void showErrorMessage(BuildContext context, String msg) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text(
        "خطأ",
        style: TextStyle(
          fontFamily: 'Sen',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ThemeHelper.getPrimaryTextColor(context),
        ),
      ),
      description: Text(
        msg,
        style: TextStyle(
          fontFamily: 'Sen',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ThemeHelper.getSecondaryTextColor(context),
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      icon: SizedBox(
        width: 60,
        height: 60,
        child: Lottie.asset(
          "assets/snakebarJson/face_wrong_icon.json",
          repeat: false,
          fit: BoxFit.contain,
        ),
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      showProgressBar: true,
      closeOnClick: true,
      dragToClose: true,
      applyBlurEffect: true,
      backgroundColor: ThemeHelper.getCardBackgroundColor(context),
      foregroundColor: ThemeHelper.getPrimaryTextColor(context),
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
    );
  }

  static void showInfoMessage(BuildContext context, String msg) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      title: Text(
        "معلومات",
        style: TextStyle(
          fontFamily: 'Sen',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ThemeHelper.getPrimaryTextColor(context),
        ),
      ),
      description: Text(
        msg,
        style: TextStyle(
          fontFamily: 'Sen',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ThemeHelper.getSecondaryTextColor(context),
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      showProgressBar: false,
      closeOnClick: true,
      dragToClose: true,
      applyBlurEffect: true,
      backgroundColor: ThemeHelper.getCardBackgroundColor(context),
      foregroundColor: ThemeHelper.getPrimaryTextColor(context),
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
    );
  }

  static void showWarningMessage(BuildContext context, String msg) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      title: Text(
        "تحذير",
        style: TextStyle(
          fontFamily: 'Sen',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ThemeHelper.getPrimaryTextColor(context),
        ),
      ),
      description: Text(
        msg,
        style: TextStyle(
          fontFamily: 'Sen',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ThemeHelper.getSecondaryTextColor(context),
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      showProgressBar: false,
      closeOnClick: true,
      dragToClose: true,
      applyBlurEffect: true,
      backgroundColor: ThemeHelper.getCardBackgroundColor(context),
      foregroundColor: ThemeHelper.getPrimaryTextColor(context),
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
    );
  }
}
