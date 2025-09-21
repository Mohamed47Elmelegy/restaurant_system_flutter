import 'package:flutter/material.dart';
import '../../../../../../../core/theme/theme_helper.dart';

class AllergensWidget extends StatelessWidget {
  final List<String> selectedAllergens;
  final ValueChanged<List<String>> onAllergensChanged;

  const AllergensWidget({
    super.key,
    required this.selectedAllergens,
    required this.onAllergensChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ALLERGENS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getPrimaryTextColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildAllergenChip(context, 'gluten'),
            _buildAllergenChip(context, 'dairy'),
            _buildAllergenChip(context, 'eggs'),
            _buildAllergenChip(context, 'nuts'),
            _buildAllergenChip(context, 'soy'),
            _buildAllergenChip(context, 'fish'),
            _buildAllergenChip(context, 'pork'),
          ],
        ),
      ],
    );
  }

  Widget _buildAllergenChip(BuildContext context, String allergen) {
    final isSelected = selectedAllergens.contains(allergen);

    return FilterChip(
      label: Text(allergen),
      selected: isSelected,
      onSelected: (selected) {
        final newList = List<String>.from(selectedAllergens);
        if (selected) {
          newList.add(allergen);
        } else {
          newList.remove(allergen);
        }
        onAllergensChanged(newList);
      },
      selectedColor: Colors.red.withValues(alpha: 0.2),
      checkmarkColor: Colors.red,
    );
  }
}
