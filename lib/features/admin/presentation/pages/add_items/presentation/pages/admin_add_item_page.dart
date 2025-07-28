import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/theme_helper.dart';
import '../../../../../../../core/utils/responsive_helper.dart';
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
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: CustomAppBar(
        onBackPressed: () => Navigator.pop(context),
        onResetPressed: _onResetPressed,
      ),
      body: SafeArea(
        child: ResponsiveHelper.responsiveLayout(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.isMobile(context) ? 24.w : 32.w,
              ),
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
            );
          },
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
          content: Text(
            'Item saved successfully',
            style: TextStyle(
              color: ThemeHelper.getPrimaryTextColor(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: ThemeHelper.getPrimaryColorForTheme(context),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      Navigator.pop(context);
    }
  }
}
