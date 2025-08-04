import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/main_category.dart';
import '../../domain/entities/sub_category.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_events.dart';
import '../cubit/category_states.dart';
import '../../../../../../../core/validation/index.dart';
import '../../../menu/presentation/bloc/menu_cubit.dart';
import '../../../menu/presentation/bloc/menu_events.dart';
import '../../../../../../../core/di/service_locator.dart';

/// 🟦 AdminAddCategoryPage - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن عرض واجهة إضافة الفئات والفئات الفرعية
class AdminAddCategoryPage extends StatefulWidget {
  const AdminAddCategoryPage({super.key});

  @override
  State<AdminAddCategoryPage> createState() => _AdminAddCategoryPageState();
}

class _AdminAddCategoryPageState extends State<AdminAddCategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Main Category Form Controllers
  final _mainCategoryFormKey = GlobalKey<FormState>();
  final _mainCategoryNameController = TextEditingController();
  final _mainCategoryNameArController = TextEditingController();
  final _mainCategoryDescriptionController = TextEditingController();
  final _mainCategoryDescriptionArController = TextEditingController();
  final _mainCategorySortOrderController = TextEditingController();
  bool _mainCategoryIsActive = true;

  // Sub Category Form Controllers
  final _subCategoryFormKey = GlobalKey<FormState>();
  final _subCategoryNameController = TextEditingController();
  final _subCategoryNameArController = TextEditingController();
  final _subCategoryDescriptionController = TextEditingController();
  final _subCategoryDescriptionArController = TextEditingController();
  final _subCategorySortOrderController = TextEditingController();
  bool _subCategoryIsActive = true;
  String? _selectedMainCategoryId;
  String? _selectedMainCategoryName;

  // Categories list for dropdown
  List<MainCategory> _mainCategories = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _mainCategorySortOrderController.text = '0';
    _subCategorySortOrderController.text = '0';

    // Load categories when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshCategories();
    });
  }

  void _refreshCategories() {
    try {
      final categoryCubit = getIt<CategoryCubit>();
      categoryCubit.add(const LoadCategories());
      print(
        '🔄 AdminAddCategoryPage: Triggered categories refresh on page load',
      );
    } catch (e) {
      print('❌ AdminAddCategoryPage: Error refreshing categories - $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mainCategoryNameController.dispose();
    _mainCategoryNameArController.dispose();
    _mainCategoryDescriptionController.dispose();
    _mainCategoryDescriptionArController.dispose();
    _mainCategorySortOrderController.dispose();
    _subCategoryNameController.dispose();
    _subCategoryNameArController.dispose();
    _subCategoryDescriptionController.dispose();
    _subCategoryDescriptionArController.dispose();
    _subCategorySortOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الفئات'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.category), text: 'الفئات الرئيسية'),
            Tab(
              icon: Icon(Icons.subdirectory_arrow_right),
              text: 'الفئات الفرعية',
            ),
          ],
        ),
      ),
      body: BlocListener<CategoryCubit, CategoryState>(
        listener: (context, state) {
          if (state is CategoryCreated) {
            _showSuccessDialog('تم إنشاء الفئة الرئيسية بنجاح');
            _clearMainCategoryForm();
            // Reload categories to update dropdown
            _refreshCategories();

            // استدعاء refresh للقائمة لتحميل البيانات الجديدة
            try {
              final menuCubit = getIt<MenuCubit>();
              menuCubit.add(RefreshMenuItems());
              print(
                '🔄 AdminAddCategoryPage: Triggered menu refresh after category creation',
              );
            } catch (e) {
              print(
                '❌ AdminAddCategoryPage: Error triggering menu refresh - $e',
              );
            }
          } else if (state is SubCategoryCreated) {
            _showSuccessDialog('تم إنشاء الفئة الفرعية بنجاح');
            _clearSubCategoryForm();

            // استدعاء refresh للفئات والقائمة لتحميل البيانات الجديدة
            _refreshCategories();

            // استدعاء refresh للقائمة لتحميل البيانات الجديدة
            try {
              final menuCubit = getIt<MenuCubit>();
              menuCubit.add(RefreshMenuItems());
              print(
                '🔄 AdminAddCategoryPage: Triggered menu refresh after sub-category creation',
              );
            } catch (e) {
              print(
                '❌ AdminAddCategoryPage: Error triggering menu refresh - $e',
              );
            }
          } else if (state is CategoriesLoaded) {
            setState(() {
              _mainCategories = state.categories;
            });
          } else if (state is CategoryError) {
            _showErrorDialog('خطأ: ${state.message}');
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: [_buildMainCategoryTab(), _buildSubCategoryTab()],
        ),
      ),
    );
  }

  Widget _buildMainCategoryTab() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _mainCategoryFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.category, color: Colors.orange, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'إضافة فئة رئيسية جديدة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Category Name (English)
                TextFormField(
                  controller: _mainCategoryNameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الفئة (إنجليزي)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label),
                  ),
                  validator: (value) =>
                      FormValidator.validateRequired(value, 'اسم الفئة'),
                ),
                const SizedBox(height: 16),

                // Category Name (Arabic)
                TextFormField(
                  controller: _mainCategoryNameArController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الفئة (عربي)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.language),
                  ),
                  validator: (value) => FormValidator.validateRequired(
                    value,
                    'اسم الفئة بالعربية',
                  ),
                ),
                const SizedBox(height: 16),

                // Description (English)
                TextFormField(
                  controller: _mainCategoryDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'وصف الفئة (إنجليزي)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Description (Arabic)
                TextFormField(
                  controller: _mainCategoryDescriptionArController,
                  decoration: const InputDecoration(
                    labelText: 'وصف الفئة (عربي)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.language),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Sort Order
                TextFormField(
                  controller: _mainCategorySortOrderController,
                  decoration: const InputDecoration(
                    labelText: 'ترتيب الفئة',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.sort),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => FormValidator.validatePositiveNumber(
                    value,
                    'ترتيب الفئة',
                  ),
                ),
                const SizedBox(height: 16),

                // Active Status
                CheckboxListTile(
                  title: const Text('فعالة'),
                  value: _mainCategoryIsActive,
                  onChanged: (value) {
                    setState(() {
                      _mainCategoryIsActive = value ?? true;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: state is CategoryLoading
                      ? null
                      : _onSaveMainCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: state is CategoryLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'حفظ الفئة الرئيسية',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubCategoryTab() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _subCategoryFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.subdirectory_arrow_right,
                        color: Colors.blue,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'إضافة فئة فرعية جديدة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Main Category Selection
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اختر الفئة الرئيسية',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedMainCategoryId,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        hint: const Text('اختر الفئة الرئيسية'),
                        items: _mainCategories.map((category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMainCategoryId = value;
                            _selectedMainCategoryName = _mainCategories
                                .firstWhere((cat) => cat.id == value)
                                .name;
                          });
                        },
                        validator: (value) => FormValidator.validateRequired(
                          value,
                          'الفئة الرئيسية',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Sub Category Name (English)
                TextFormField(
                  controller: _subCategoryNameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الفئة الفرعية (إنجليزي)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label),
                  ),
                  validator: (value) => FormValidator.validateRequired(
                    value,
                    'اسم الفئة الفرعية',
                  ),
                ),
                const SizedBox(height: 16),

                // Sub Category Name (Arabic)
                TextFormField(
                  controller: _subCategoryNameArController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الفئة الفرعية (عربي)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.language),
                  ),
                  validator: (value) => FormValidator.validateRequired(
                    value,
                    'اسم الفئة الفرعية بالعربية',
                  ),
                ),
                const SizedBox(height: 16),

                // Sub Category Description (English)
                TextFormField(
                  controller: _subCategoryDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'وصف الفئة الفرعية (إنجليزي)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Sub Category Description (Arabic)
                TextFormField(
                  controller: _subCategoryDescriptionArController,
                  decoration: const InputDecoration(
                    labelText: 'وصف الفئة الفرعية (عربي)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.language),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Sort Order
                TextFormField(
                  controller: _subCategorySortOrderController,
                  decoration: const InputDecoration(
                    labelText: 'ترتيب الفئة الفرعية',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.sort),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => FormValidator.validatePositiveNumber(
                    value,
                    'ترتيب الفئة الفرعية',
                  ),
                ),
                const SizedBox(height: 16),

                // Active Status
                CheckboxListTile(
                  title: const Text('فعالة'),
                  value: _subCategoryIsActive,
                  onChanged: (value) {
                    setState(() {
                      _subCategoryIsActive = value ?? true;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: state is CategoryLoading
                      ? null
                      : _onSaveSubCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: state is CategoryLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'حفظ الفئة الفرعية',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSaveMainCategory() {
    if (_mainCategoryFormKey.currentState!.validate()) {
      final category = MainCategory.fromIntId(
        name: _mainCategoryNameController.text.trim(),
        nameAr: _mainCategoryNameArController.text.trim(),
        description: _mainCategoryDescriptionController.text.trim(),
        descriptionAr: _mainCategoryDescriptionArController.text.trim(),
        sortOrder: int.tryParse(_mainCategorySortOrderController.text) ?? 0,
        isActive: _mainCategoryIsActive,
      );

      // Validate using CategoryValidator
      final errors = CategoryValidator.validateMainCategory(category);
      if (errors.isNotEmpty) {
        _showErrorDialog(CategoryValidator.getValidationErrorMessage(errors));
        return;
      }

      BlocProvider.of<CategoryCubit>(
        context,
        listen: false,
      ).add(CreateCategory(category));
    }
  }

  void _onSaveSubCategory() {
    if (_subCategoryFormKey.currentState!.validate()) {
      final categoryId = int.tryParse(_selectedMainCategoryId ?? '1') ?? 1;
      final subCategory = SubCategory.fromIntId(
        mainCategoryId: categoryId,
        name: _subCategoryNameController.text.trim(),
        nameAr: _subCategoryNameArController.text.trim(),
        description: _subCategoryDescriptionController.text.trim(),
        descriptionAr: _subCategoryDescriptionArController.text.trim(),
        sortOrder: int.tryParse(_subCategorySortOrderController.text) ?? 0,
        isActive: _subCategoryIsActive,
      );

      // Validate using CategoryValidator
      final errors = CategoryValidator.validateSubCategory(subCategory);
      if (errors.isNotEmpty) {
        _showErrorDialog(CategoryValidator.getValidationErrorMessage(errors));
        return;
      }

      BlocProvider.of<CategoryCubit>(
        context,
        listen: false,
      ).add(CreateSubCategory(categoryId, subCategory));
    }
  }

  void _clearMainCategoryForm() {
    _mainCategoryNameController.clear();
    _mainCategoryNameArController.clear();
    _mainCategoryDescriptionController.clear();
    _mainCategoryDescriptionArController.clear();
    _mainCategorySortOrderController.text = '0';
    setState(() {
      _mainCategoryIsActive = true;
    });
  }

  void _clearSubCategoryForm() {
    _subCategoryNameController.clear();
    _subCategoryNameArController.clear();
    _subCategoryDescriptionController.clear();
    _subCategoryDescriptionArController.clear();
    _subCategorySortOrderController.text = '0';
    setState(() {
      _subCategoryIsActive = true;
      _selectedMainCategoryId = null;
      _selectedMainCategoryName = null;
    });
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('نجح'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
