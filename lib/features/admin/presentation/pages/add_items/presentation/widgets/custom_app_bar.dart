import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/theme_helper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onResetPressed;

  const CustomAppBar({
    super.key,
    required this.onBackPressed,
    required this.onResetPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ThemeHelper.getInputBackgroundColor(context),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: onBackPressed,
          icon: Icon(
            Icons.arrow_back,
            color: ThemeHelper.getPrimaryTextColor(context),
            size: 20,
          ),
        ),
      ),
      title: Text(
        'Add New Items',
        style: TextStyle(
          color: ThemeHelper.getPrimaryTextColor(context),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: onResetPressed,
          child: Text(
            'RESET',
            style: TextStyle(
              color: AppColors.lightPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
