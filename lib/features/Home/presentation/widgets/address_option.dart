import 'package:flutter/material.dart';
import '../../../../core/theme/theme_helper.dart';

class AddressOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? leadingIcon;

  const AddressOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        leadingIcon ?? Icons.location_on,
        color: isSelected ? ThemeHelper.getPrimaryColorForTheme(context) : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? ThemeHelper.getPrimaryColorForTheme(context)
              : null,
        ),
      ),
      subtitle: Text(subtitle),
      onTap: onTap,
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: ThemeHelper.getPrimaryColorForTheme(context),
            )
          : null,
    );
  }
}
