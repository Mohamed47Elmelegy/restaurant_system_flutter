import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // المحتوى الأساسي
        child,

        // مؤشر التحميل (يظهر فقط عند isLoading = true)
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: Platform.isIOS
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : SpinKitFadingCircle(color: Colors.white, size: 60.0),
            ),
          ),
      ],
    );
  }
}
