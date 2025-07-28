import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../widgets/index.dart';

class AdminAddItemPage extends StatefulWidget {
  const AdminAddItemPage({super.key});

  @override
  State<AdminAddItemPage> createState() => _AdminAddItemPageState();
}

class _AdminAddItemPageState extends State<AdminAddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _detailsController = TextEditingController();

  List<String> _uploadedImages = <String>[];
  bool _isPickupSelected = false;
  bool _isDeliverySelected = false;
  Set<String> _selectedBasicIngredients = {};
  Set<String> _selectedFruitIngredients = {};
  String? _selectedMealCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        onBackPressed: () => Navigator.pop(context),
        onResetPressed: _onResetPressed,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: AddItemFormWidget(
            formKey: _formKey,
            nameController: _nameController,
            priceController: _priceController,
            detailsController: _detailsController,
            uploadedImages: _uploadedImages,
            isPickupSelected: _isPickupSelected,
            isDeliverySelected: _isDeliverySelected,
            selectedBasicIngredients: _selectedBasicIngredients,
            selectedFruitIngredients: _selectedFruitIngredients,
            selectedMealCategory: _selectedMealCategory,
            onAddMediaPressed: _onAddMediaPressed,
            onPickupChanged: (value) {
              setState(() {
                _isPickupSelected = value;
              });
            },
            onDeliveryChanged: (value) {
              setState(() {
                _isDeliverySelected = value;
              });
            },
            onBasicIngredientToggled: (ingredientId) {
              setState(() {
                if (_selectedBasicIngredients.contains(ingredientId)) {
                  _selectedBasicIngredients.remove(ingredientId);
                } else {
                  _selectedBasicIngredients.add(ingredientId);
                }
              });
            },
            onFruitIngredientToggled: (ingredientId) {
              setState(() {
                if (_selectedFruitIngredients.contains(ingredientId)) {
                  _selectedFruitIngredients.remove(ingredientId);
                } else {
                  _selectedFruitIngredients.add(ingredientId);
                }
              });
            },
            onBasicSeeAllPressed: () {
              // TODO: Navigate to see all basic ingredients
            },
            onFruitSeeAllPressed: () {
              // TODO: Navigate to see all fruit ingredients
            },
            onMealCategoryChanged: (category) {
              setState(() {
                _selectedMealCategory = category;
              });
            },
            onSavePressed: _onSaveChanges,
          ),
        ),
      ),
    );
  }

  void _onAddMediaPressed() {
    // TODO: Implement media picker
    setState(() {
      if (_uploadedImages.isEmpty) {
        _uploadedImages.add('assets/images/chickenburger.jpg');
      }
    });
  }

  void _onResetPressed() {
    setState(() {
      _nameController.clear();
      _priceController.clear();
      _detailsController.clear();
      _uploadedImages.clear();
      _isPickupSelected = false;
      _isDeliverySelected = false;
      _selectedBasicIngredients = {};
      _selectedFruitIngredients.clear();
      _selectedMealCategory = null;
    });
  }

  void _onSaveChanges() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save functionality
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item saved successfully'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }
}
