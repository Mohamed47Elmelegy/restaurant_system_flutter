import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class CustomAnimatedDropdown<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) itemLabel;
  final T? selectedValue;
  final Function(T?) onChanged;
  final String hintText;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const CustomAnimatedDropdown({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.selectedValue,
    required this.onChanged,
    required this.hintText,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Row(
        children: [
          Text(errorMessage!, style: const TextStyle(color: Colors.red)),
          IconButton(
            icon: const Icon(Icons.refresh, size: 18),
            onPressed: onRetry,
          ),
        ],
      );
    }

    return CustomDropdown<T>(
      hintText: hintText,
      items: items,
      initialItem: selectedValue,
      onChanged: onChanged,
      listItemBuilder: (context, item, isSelected, onItemSelect) {
        return ListTile(title: Text(itemLabel(item)), onTap: onItemSelect);
      },
    );
  }
}
