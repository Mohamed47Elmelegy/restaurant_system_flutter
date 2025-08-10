import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theme/theme_helper.dart';
import '../../../../../../../core/utils/responsive_helper.dart';
import '../cubit/product_events.dart';
import '../cubit/product_states.dart';
import '../widgets/index.dart';
import '../cubit/product_cubit.dart';
import '../../../../../../../core/entities/product.dart';
import '../../../../../../../core/di/service_locator.dart';
import '../../../add_category/presentation/cubit/category_cubit.dart';
import '../../../add_category/presentation/cubit/category_events.dart';

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
  final _nameArController = TextEditingController();
  final _detailsArController = TextEditingController();
  final _preparationTimeController = TextEditingController();
  final _sortOrderController = TextEditingController();

  // ✅ Product settings
  bool _isAvailable = true;
  bool _isFeatured = false;

  // ✅ Category selection
  String? _selectedMainCategory;

  // ✅ Lists for ingredients and allergens
  List<String> _selectedIngredients = [];
  List<String> _selectedAllergens = [];

  // ✅ Existing fields
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
    _nameArController.dispose();
    _detailsArController.dispose();
    _preparationTimeController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductCubit>(create: (context) => getIt<ProductCubit>()),
        BlocProvider<CategoryCubit>(
          create: (context) =>
              getIt<CategoryCubit>()..add(const LoadCategories()),
        ),
      ],
      child: BlocListener<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم إنشاء المنتج بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProductValidationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ في البيانات: ${state.message}'),
                backgroundColor: Colors.orange,
              ),
            );
          } else if (state is ProductAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ في المصادقة: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
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
                        horizontal: ResponsiveHelper.isMobile(context)
                            ? 24.w
                            : 32.w,
                      ),
                      child: SingleChildScrollView(
                        child: AddItemFormWidget(
                          formKey: _formKey,
                          // English fields
                          nameController: _nameController,
                          priceController: _priceController,
                          detailsController: _detailsController,

                          // Additional fields
                          preparationTimeController: _preparationTimeController,
                          sortOrderController: _sortOrderController,
                          // Product settings
                          isAvailable: _isAvailable,
                          isFeatured: _isFeatured,
                          onAvailableChanged: (value) {
                            setState(() {
                              _isAvailable = value;
                            });
                          },
                          onFeaturedChanged: (value) {
                            setState(() {
                              _isFeatured = value;
                            });
                          },
                          // Category selection
                          selectedMainCategory: _selectedMainCategory,
                          onMainCategoryChanged: (category) {
                            setState(() {
                              _selectedMainCategory = category;
                            });
                          },
                          // Ingredients and allergens
                          selectedIngredients: _selectedIngredients,
                          selectedAllergens: _selectedAllergens,
                          onIngredientsChanged: (ingredients) {
                            setState(() {
                              _selectedIngredients = ingredients;
                            });
                          },
                          onAllergensChanged: (allergens) {
                            setState(() {
                              _selectedAllergens = allergens;
                            });
                          },
                          // Existing fields
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
                              if (_selectedBasicIngredients.contains(
                                ingredientId,
                              )) {
                                _selectedBasicIngredients.remove(ingredientId);
                              } else {
                                _selectedBasicIngredients.add(ingredientId);
                              }
                            });
                          },
                          onFruitIngredientToggled: (ingredientId) {
                            setState(() {
                              if (_selectedFruitIngredients.contains(
                                ingredientId,
                              )) {
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
                          onSavePressed: () => _onSaveChanges(context),
                        ),
                      ),
                    );
                  },
                ),
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
      // Clear English fields
      _nameController.clear();
      _priceController.clear();
      _detailsController.clear();

      // Clear Arabic fields
      _nameArController.clear();
      _detailsArController.clear();

      // Clear additional fields
      _preparationTimeController.clear();
      _sortOrderController.clear();

      // Reset settings
      _isAvailable = true;
      _isFeatured = false;

      // Reset categories
      _selectedMainCategory = null;

      // Reset ingredients and allergens
      _selectedIngredients.clear();
      _selectedAllergens.clear();

      // Clear existing fields
      _uploadedImages.clear();
      _isPickupSelected = false;
      _isDeliverySelected = false;
      _selectedBasicIngredients = {};
      _selectedFruitIngredients.clear();
      _selectedMealCategory = null;
    });
  }

  // ✅ UI method مبسط - إنشاء Product مباشرة
  void _onSaveChanges(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // ✅ إنشاء Product مباشرة
      final product = ProductEntity(
        id: '', // Will be set by the server
        name: _nameController.text.trim(),

        description: _detailsController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0.0,
        mainCategoryId: int.tryParse(_selectedMainCategory ?? '1') ?? 1,
        imageUrl: _uploadedImages.isNotEmpty ? _uploadedImages.first : null,
        isAvailable: _isAvailable,
        isFeatured: _isFeatured,
        preparationTime: _preparationTimeController.text.isNotEmpty
            ? int.tryParse(_preparationTimeController.text)
            : null,
        sortOrder: _sortOrderController.text.isNotEmpty
            ? int.tryParse(_sortOrderController.text)
            : null,
        ingredients: _selectedIngredients.isNotEmpty
            ? _selectedIngredients
            : null,
        allergens: _selectedAllergens.isNotEmpty ? _selectedAllergens : null,
      );

      // ✅ إرسال Product مباشرة
      BlocProvider.of<ProductCubit>(
        context,
        listen: false,
      ).add(CreateProduct(product));
    }
  }
}
