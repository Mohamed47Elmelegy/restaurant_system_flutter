import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle senRegular14(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 1.203125,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senBold14(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w700,
      fontSize: 14,
      height: 1.203125,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senBold22(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w700,
      fontSize: 22,
      height: 1.203125,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senBold52(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w700,
      fontSize: 52.32,
      height: 1.203125,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  // Add more styles as needed
}
