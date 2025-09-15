import 'package:flutter/material.dart';

class AppTextStyles {
  // Sen ExtraBold styles
  static TextStyle senExtraBold30(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w800,
      fontSize: 30,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senExtraBold24(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w800,
      fontSize: 24,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  // Sen Bold styles
  static TextStyle senBold20(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle sectionHeader(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senBold18(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w700,
      fontSize: 18,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senBold16(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w700,
      fontSize: 16,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senBold15(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w700,
      fontSize: 15,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senBold14(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w700,
      fontSize: 14,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  // Sen Regular styles
  static TextStyle senRegular28(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w400,
      fontSize: 28,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senRegular20(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w400,
      fontSize: 20,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senRegular17(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w400,
      fontSize: 17,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senRegular16(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senRegular14(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  // Legacy methods for backward compatibility
  static TextStyle senBold22(BuildContext context) {
    return senBold20(context).copyWith(fontSize: 22);
  }

  static TextStyle senBold52(BuildContext context) {
    return senExtraBold30(context).copyWith(fontSize: 52);
  }

  static TextStyle senBold10(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w700,
      fontSize: 10,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senRegular12(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w400,
      fontSize: 12,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senMedium12(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w500,
      fontSize: 12,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senMedium14(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senMedium16(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w500,
      fontSize: 16,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static TextStyle senRegular10(BuildContext context) {
    return TextStyle(
      fontFamily: 'Sen',
      fontWeight: FontWeight.w400,
      fontSize: 10,
      height: 1.2,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }
}
