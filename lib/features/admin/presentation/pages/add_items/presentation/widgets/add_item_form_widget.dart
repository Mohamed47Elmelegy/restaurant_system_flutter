import 'package:flutter/material.dart';
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
  final String? selectedSubCategory;
  final ValueChanged<String> onMainCategoryChanged;
  final ValueChanged<String> onSubCategoryChanged;

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
    required this.nameArController,
    required this.detailsArController,
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
    this.selectedSubCategory,
    required this.onMainCategoryChanged,
    required this.onSubCategoryChanged,
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
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Item Name Section (English)
          CustomTextField(
            label: 'ITEM NAME (ENGLISH)',
            hint: 'Classic Beef Burger',
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter item name in English';
              }
              return null;
            },
          ),

          // Item Name Section (Arabic)
          CustomTextField(
            label: 'ITEM NAME (ARABIC)',
            hint: 'برجر لحم كلاسيك',
            controller: nameArController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter item name in Arabic';
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

          // Main Category Section
          FormSectionWidget(
            child: MainCategoryWidget(
              selectedCategory: selectedMainCategory,
              onCategoryChanged: onMainCategoryChanged,
            ),
          ),

          // Sub Category Section (only show if main category is selected)
          if (selectedMainCategory != null)
            FormSectionWidget(
              child: SubCategoryWidget(
                mainCategoryId: selectedMainCategory!,
                selectedCategory: selectedSubCategory,
                onCategoryChanged: onSubCategoryChanged,
              ),
            ),

          // Price Section
          CustomTextField(
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
          CustomTextField(
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
          CustomTextField(
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

          // Details Section (English)
          CustomTextField(
            label: 'DETAILS (ENGLISH)',
            hint:
                'Juicy beef patty with fresh lettuce, tomato, and special sauce',
            controller: detailsController,
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter details in English';
              }
              return null;
            },
          ),

          // Details Section (Arabic)
          CustomTextField(
            label: 'DETAILS (ARABIC)',
            hint: 'برجر لحم عصير مع خس طازج وطماطم وصلصة خاصة',
            controller: detailsArController,
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter details in Arabic';
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
