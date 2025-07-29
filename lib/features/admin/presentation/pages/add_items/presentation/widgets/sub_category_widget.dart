import 'package:flutter/material.dart';
import '../../../../../../../core/theme/theme_helper.dart';

class SubCategoryWidget extends StatelessWidget {
  final String mainCategoryId;
  final String? selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const SubCategoryWidget({
    super.key,
    required this.mainCategoryId,
    this.selectedCategory,
    required this.onCategoryChanged,
  });

  List<Map<String, String>> _getSubCategories(String mainCategoryId) {
    switch (mainCategoryId) {
      case '1': // Fast Food
        return [
          {'id': '1', 'name': 'Burgers (برجر)'},
          {'id': '2', 'name': 'Sandwiches (ساندويتش)'},
          {'id': '3', 'name': 'Crepes (كريب)'},
        ];
      case '2': // Pizza
        return [
          {'id': '4', 'name': 'Margherita (مارجريتا)'},
          {'id': '5', 'name': 'Pepperoni (بيبروني)'},
          {'id': '6', 'name': 'Vegetarian (نباتية)'},
        ];
      case '3': // Beverages
        return [
          {'id': '7', 'name': 'Hot Drinks (مشروبات ساخنة)'},
          {'id': '8', 'name': 'Cold Drinks (مشروبات باردة)'},
        ];
      case '4': // Desserts
        return [
          {'id': '9', 'name': 'Cakes (كيك)'},
          {'id': '10', 'name': 'Ice Cream (آيس كريم)'},
          {'id': '11', 'name': 'Arabic Sweets (حلويات شرقية)'},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final subCategories = _getSubCategories(mainCategoryId);

    if (subCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SUB CATEGORY',
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
                'Select sub category (optional)',
                style: TextStyle(
                  color: ThemeHelper.getSecondaryTextColor(context),
                ),
              ),
              isExpanded: true,
              items: [
                ...subCategories.map(
                  (category) => DropdownMenuItem(
                    value: category['id'],
                    child: Text(category['name']!),
                  ),
                ),
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
