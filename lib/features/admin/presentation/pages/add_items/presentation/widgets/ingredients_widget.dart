import 'package:flutter/material.dart';
import '../../../../../../../core/theme/theme_helper.dart';

class IngredientsWidget extends StatelessWidget {
  final List<String> selectedIngredients;
  final ValueChanged<List<String>> onIngredientsChanged;

  const IngredientsWidget({
    super.key,
    required this.selectedIngredients,
    required this.onIngredientsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INGREDIENTS',
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
            _buildIngredientChip(context, 'beef patty'),
            _buildIngredientChip(context, 'lettuce'),
            _buildIngredientChip(context, 'tomato'),
            _buildIngredientChip(context, 'onion'),
            _buildIngredientChip(context, 'cheese'),
            _buildIngredientChip(context, 'bun'),
            _buildIngredientChip(context, 'chicken breast'),
            _buildIngredientChip(context, 'mayo'),
          ],
        ),
      ],
    );
  }

  Widget _buildIngredientChip(BuildContext context, String ingredient) {
    final isSelected = selectedIngredients.contains(ingredient);

    return FilterChip(
      label: Text(ingredient),
      selected: isSelected,
      onSelected: (selected) {
        final newList = List<String>.from(selectedIngredients);
        if (selected) {
          newList.add(ingredient);
        } else {
          newList.remove(ingredient);
        }
        onIngredientsChanged(newList);
      },
      selectedColor: ThemeHelper.getPrimaryColorForTheme(
        context,
      ).withValues(alpha: 0.2),
      checkmarkColor: ThemeHelper.getPrimaryColorForTheme(context),
    );
  }
}
