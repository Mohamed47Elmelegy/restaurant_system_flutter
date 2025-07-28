import 'package:flutter/material.dart';
import 'index.dart';

class AddItemFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController detailsController;
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
    required this.nameController,
    required this.priceController,
    required this.detailsController,
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
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Item Name Section
          CustomTextField(
            label: 'ITEM NAME',
            hint: 'Mazalichiken Halim',
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter item name';
              }
              return null;
            },
          ),

          FormSectionWidget(
            child: MediaUploadWidget(
              uploadedImages: uploadedImages,
              onAddPressed: onAddMediaPressed,
            ),
          ),

          // Meal Category Section
          FormSectionWidget(
            child: MealCategoryWidget(
              selectedCategory: selectedMealCategory,
              onCategoryChanged: onMealCategoryChanged,
            ),
          ),

          // Price Section
          CustomTextField(
            label: 'PRICE',
            hint: '\$50',
            controller: priceController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter price';
              }
              return null;
            },
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

          // Details Section
          CustomTextField(
            label: 'DETAILS',
            hint:
                'Lorem ipsum dolor sit amet, consectetur adips cing elit. Bibendum in vel, mattis et amet dui mauris turpis.',
            controller: detailsController,
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter details';
              }
              return null;
            },
          ),

          FormSectionWidget(
            topSpacing: 32,
            child: SaveButtonWidget(onPressed: onSavePressed),
          ),
        ],
      ),
    );
  }
}
