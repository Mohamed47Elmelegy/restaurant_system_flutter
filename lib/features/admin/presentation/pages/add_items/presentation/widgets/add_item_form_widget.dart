import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custom_text_field.dart' as core;
import 'index.dart';

class AddItemFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  // English fields
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController detailsController;

  // Arabic fields
  final TextEditingController nameArController;
  final TextEditingController detailsArController;
  // Additional fields
  final TextEditingController preparationTimeController;
  final TextEditingController sortOrderController;

  // Product settings
  final bool isAvailable;
  final bool isFeatured;
  final ValueChanged<bool> onAvailableChanged;
  final ValueChanged<bool> onFeaturedChanged;

  // Category selection
  final String? selectedMainCategory;
  final ValueChanged<String> onMainCategoryChanged;

  // Ingredients and allergens
  final List<String> selectedIngredients;
  final List<String> selectedAllergens;
  final ValueChanged<List<String>> onIngredientsChanged;
  final ValueChanged<List<String>> onAllergensChanged;

  // Existing fields
  final List<String> uploadedImages;
  final bool isPickupSelected;
  final bool isDeliverySelected;
  final Set<String> selectedBasicIngredients;
  final Set<String> selectedFruitIngredients;
  final String? selectedMealCategory;
  final VoidCallback onAddMediaPressed;
  final ValueChanged<bool> onPickupChanged;
  final ValueChanged<bool> onDeliveryChanged;
  final ValueChanged<String> onBasicIngredientToggled;
  final ValueChanged<String> onFruitIngredientToggled;
  final ValueChanged<String> onMealCategoryChanged;
  final VoidCallback? onBasicSeeAllPressed;
  final VoidCallback? onFruitSeeAllPressed;
  final VoidCallback onSavePressed;

  const AddItemFormWidget({
    super.key,
    required this.formKey,
    // English fields
    required this.nameController,
    required this.priceController,
    required this.detailsController,
    // Arabic fields
    required this.nameArController, // Arabic name controller
    required this.detailsArController, // Arabic details controller
    // Additional fields
    required this.preparationTimeController,
    required this.sortOrderController,
    // Product settings
    required this.isAvailable,
    required this.isFeatured,
    required this.onAvailableChanged,
    required this.onFeaturedChanged,
    // Category selection
    this.selectedMainCategory,
    required this.onMainCategoryChanged,
    // Ingredients and allergens
    required this.selectedIngredients,
    required this.selectedAllergens,
    required this.onIngredientsChanged,
    required this.onAllergensChanged,
    // Existing fields
    required this.uploadedImages,
    required this.isPickupSelected,
    required this.isDeliverySelected,
    required this.selectedBasicIngredients,
    required this.selectedFruitIngredients,
    this.selectedMealCategory,
    required this.onAddMediaPressed,
    required this.onPickupChanged,
    required this.onDeliveryChanged,
    required this.onBasicIngredientToggled,
    required this.onFruitIngredientToggled,
    required this.onMealCategoryChanged,
    this.onBasicSeeAllPressed,
    this.onFruitSeeAllPressed,
    required this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Name Section
          _buildLabeledTextField(
            label: 'NAME (ENGLISH)',
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter name';
              }
              return null;
            },
          ),
          // Name Arabic Section
          _buildLabeledTextField(
            label: 'NAME (ARABIC)',
            controller: nameArController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter name in Arabic';
              }
              return null;
            },
          ),

          // Details Section
          _buildLabeledTextField(
            label: 'DETAILS (ENGLISH)',

            controller: detailsController,
            maxLines: 3,
          ),
          // Details Arabic Section
          _buildLabeledTextField(
            label: 'DETAILS (ARABIC)',
            controller: detailsArController,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter details in Arabic';
              }
              return null;
            },
          ),

          // Main Category Section
          FormSectionWidget(
            child: MainCategoryWidget(
              selectedCategory: selectedMainCategory,
              onCategoryChanged: onMainCategoryChanged,
            ),
          ),

          // Price Section
          _buildLabeledTextField(
            label: 'PRICE (SAR)',
            hint: '25.00',
            controller: priceController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter price';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),

          // Preparation Time Section
          _buildLabeledTextField(
            label: 'PREPARATION TIME (MINUTES)',
            hint: '15',
            controller: preparationTimeController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
              }
              return null;
            },
          ),

          // Sort Order Section
          _buildLabeledTextField(
            label: 'SORT ORDER',
            hint: '1',
            controller: sortOrderController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
              }
              return null;
            },
          ),

          // Product Settings Section
          FormSectionWidget(
            child: ProductSettingsWidget(
              isAvailable: isAvailable,
              isFeatured: isFeatured,
              onAvailableChanged: onAvailableChanged,
              onFeaturedChanged: onFeaturedChanged,
            ),
          ),

          FormSectionWidget(
            topSpacing: 16,
            child: DeliveryOptionsWidget(
              isPickupSelected: isPickupSelected,
              isDeliverySelected: isDeliverySelected,
              onPickupChanged: onPickupChanged,
              onDeliveryChanged: onDeliveryChanged,
            ),
          ),

          // Ingredients Section
          FormSectionWidget(
            child: IngredientsWidget(
              selectedIngredients: selectedIngredients,
              onIngredientsChanged: onIngredientsChanged,
            ),
          ),

          // Allergens Section
          FormSectionWidget(
            child: AllergensWidget(
              selectedAllergens: selectedAllergens,
              onAllergensChanged: onAllergensChanged,
            ),
          ),

          // Media Section
          FormSectionWidget(
            child: MediaUploadWidget(
              uploadedImages: uploadedImages,
              onAddPressed: onAddMediaPressed,
            ),
          ),

          // Basic Ingredients Section
          FormSectionWidget(
            child: IngredientSelectionWidget(
              categoryTitle: 'Basic',
              ingredients: IngredientData.basicIngredients,
              selectedIngredients: selectedBasicIngredients,
              onIngredientToggled: onBasicIngredientToggled,
              onSeeAllPressed: onBasicSeeAllPressed,
            ),
          ),

          // Fruit Ingredients Section
          FormSectionWidget(
            child: IngredientSelectionWidget(
              categoryTitle: 'Fruit',
              ingredients: IngredientData.fruitIngredients,
              selectedIngredients: selectedFruitIngredients,
              onIngredientToggled: onFruitIngredientToggled,
              onSeeAllPressed: onFruitSeeAllPressed,
            ),
          ),

          // Meal Category Section
          FormSectionWidget(
            child: MealCategoryWidget(
              selectedCategory: selectedMealCategory,
              onCategoryChanged: onMealCategoryChanged,
            ),
          ),

          // Save Button
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSavePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'SAVE ITEM',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    String? hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        core.CustomTextField(
          controller: controller,
          hint: hint,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onValidate: validator,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
