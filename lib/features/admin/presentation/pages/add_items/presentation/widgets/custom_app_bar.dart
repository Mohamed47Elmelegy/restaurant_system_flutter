import 'package:flutter/material.dart';
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
      backgroundColor: ThemeHelper.getSurfaceColor(context),
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ThemeHelper.getInputBackgroundColor(context),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ThemeHelper.getPrimaryTextColor(
                context,
              ).withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
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
          style: TextButton.styleFrom(
            foregroundColor: ThemeHelper.getPrimaryColorForTheme(context),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            'RESET',
            style: TextStyle(
              color: ThemeHelper.getPrimaryColorForTheme(context),
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
