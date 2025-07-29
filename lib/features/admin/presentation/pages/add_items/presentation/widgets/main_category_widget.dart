import 'package:flutter/material.dart';
import '../../../../../../../core/theme/theme_helper.dart';

class MainCategoryWidget extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const MainCategoryWidget({
    super.key,
    this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MAIN CATEGORY',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getPrimaryTextColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: ThemeHelper.getBorderColor(context, false),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategory,
              hint: Text(
                'Select main category',
                style: TextStyle(
                  color: ThemeHelper.getSecondaryTextColor(context),
                ),
              ),
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: '1',
                  child: Text('Fast Food (وجبات سريعة)'),
                ),
                DropdownMenuItem(value: '2', child: Text('Pizza (بيتزا)')),
                DropdownMenuItem(
                  value: '3',
                  child: Text('Beverages (مشروبات)'),
                ),
                DropdownMenuItem(value: '4', child: Text('Desserts (حلويات)')),
                DropdownMenuItem(value: '5', child: Text('Breakfast (فطار)')),
                DropdownMenuItem(value: '6', child: Text('Salads (سلطات)')),
              ],
              onChanged: (value) {
                if (value != null) {
                  onCategoryChanged(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
