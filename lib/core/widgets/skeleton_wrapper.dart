import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonWrapper extends StatelessWidget {
  const SkeletonWrapper({
    super.key,
    required this.enabled,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Skeletonizer(
      enabled: enabled,
      effect: ShimmerEffect(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
        duration: const Duration(milliseconds: 1500),
      ),
      enableSwitchAnimation: true,
      ignoreContainers: true, // Prevents bad container styling
      containersColor: isDark ? Colors.grey[900] : Colors.grey[200],
      child: child,
    );
  }
}
