import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_helper.dart';
import 'add_options_bottom_sheet.dart';

class PlusButtonWidget extends StatelessWidget {
  const PlusButtonWidget({super.key, this.onPressed});

  final VoidCallback? onPressed; // Made nullable for backward compatibility

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddOptionsBottomSheet(context),
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: ThemeHelper.getPrimaryColorForTheme(context),
          shape: BoxShape.circle,
          boxShadow: ThemeHelper.getButtonShadow(context),
        ),
        child: Center(
          child: Icon(Icons.add, color: Colors.white, size: 24.sp, weight: 900),
        ),
      ),
    );
  }

  void _showAddOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddOptionsBottomSheet(),
    );
  }
}
