import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_system_flutter/core/validation/form_validator.dart';
import 'package:restaurant_system_flutter/core/widgets/custom_text_field.dart';

import '../../../../../../../core/di/service_locator.dart';
import '../../../../../../../core/entities/main_category.dart';
import '../../../menu/presentation/bloc/menu_cubit.dart';
import '../../../menu/presentation/bloc/menu_events.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_events.dart';
import '../cubit/category_states.dart';

/// 🟦 AdminAddCategoryPage - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن عرض واجهة إضافة الفئات
class AdminAddCategoryPage extends StatefulWidget {
  const AdminAddCategoryPage({super.key});

  @override
  State<AdminAddCategoryPage> createState() => _AdminAddCategoryPageState();
}

class _AdminAddCategoryPageState extends State<AdminAddCategoryPage> {
  // Main Category Form Controllers
  final _mainCategoryFormKey = GlobalKey<FormState>();
  final _mainCategoryNameController = TextEditingController();
  final _mainCategoryDescriptionController = TextEditingController();
  final _mainCategorySortOrderController = TextEditingController();
  bool _mainCategoryIsActive = true;

  // Categories list for dropdown
  List<CategoryEntity> _mainCategories = [];

  @override
  void initState() {
    super.initState();
    _mainCategorySortOrderController.text = '0';

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
    _mainCategoryNameController.dispose();
    _mainCategoryDescriptionController.dispose();
    _mainCategorySortOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الفئات'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<CategoryCubit, CategoryState>(
        listener: (context, state) {
          if (state is CategoryCreated) {
            _clearMainCategoryForm();
            _refreshCategories();
            _refreshMenu();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم إنشاء الفئة بنجاح: ${state.category.name}'),
                backgroundColor: Colors.green,
              ),
            );
            print(
              '🔄 AdminAddCategoryPage: Triggered menu refresh after category creation',
            );
          } else if (state is CategoryUpdated) {
            _clearMainCategoryForm();
            _refreshCategories();
            _refreshMenu();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم تحديث الفئة بنجاح: ${state.category.name}'),
                backgroundColor: Colors.blue,
              ),
            );
            print(
              '🔄 AdminAddCategoryPage: Triggered menu refresh after category update',
            );
          } else if (state is CategoryDeleted) {
            _refreshCategories();
            _refreshMenu();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حذف الفئة بنجاح'),
                backgroundColor: Colors.red,
              ),
            );
            print(
              '🔄 AdminAddCategoryPage: Triggered menu refresh after category deletion',
            );
          } else if (state is CategoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CategoryAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ في المصادقة: ${state.message}'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMainCategoryForm(),
              const SizedBox(height: 20),
              _buildCategoriesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCategoryForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _mainCategoryFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إضافة فئة جديدة',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),

              // Main Category Name (English)
              CustomTextField(
                controller: _mainCategoryNameController,
                hint: 'اسم الفئة (إنجليزي)',
                keyboardType: TextInputType.name,
                maxLines: 1,
                onValidate: (value) =>
                    FormValidator.validateMinLength(value, 2, 'اسم الفئة'),
              ),
              const SizedBox(height: 16),

              // Main Category Description (English)
              CustomTextField(
                controller: _mainCategoryDescriptionController,
                hint: 'وصف الفئة',
                keyboardType: TextInputType.name,
                maxLines: 1,
              ),
              const SizedBox(height: 16),

              // Sort Order
              CustomTextField(
                controller: _mainCategorySortOrderController,
                hint: '',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Is Active Switch
              SwitchListTile(
                title: const Text('الفئة نشطة'),
                value: _mainCategoryIsActive,
                onChanged: (value) {
                  setState(() {
                    _mainCategoryIsActive = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSaveMainCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('حفظ الفئة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSaveMainCategory() {
    if (_mainCategoryFormKey.currentState!.validate()) {
      final category = CategoryEntity.fromIntId(
        name: _mainCategoryNameController.text.trim(),
        description: _mainCategoryDescriptionController.text.trim(),

        sortOrder: int.tryParse(_mainCategorySortOrderController.text) ?? 0,
        isActive: _mainCategoryIsActive,
      );

      final categoryCubit = getIt<CategoryCubit>();
      categoryCubit.add(CreateCategory(category));
    }
  }

  void _clearMainCategoryForm() {
    _mainCategoryNameController.clear();
    _mainCategoryDescriptionController.clear();

    _mainCategorySortOrderController.text = '0';
    setState(() {
      _mainCategoryIsActive = true;
    });
  }

  Widget _buildCategoriesList() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoriesLoaded) {
          _mainCategories = state.categories;
          return Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الفئات الموجودة (${_mainCategories.length})',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _mainCategories.length,
                    itemBuilder: (context, index) {
                      final category = _mainCategories[index];
                      return ListTile(
                        title: Text(category.name),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              category.isActive
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: category.isActive
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteCategory(category.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (state is CategoryError) {
          return Center(child: Text('خطأ: ${state.message}'));
        } else {
          return const Center(child: Text('لا توجد فئات'));
        }
      },
    );
  }

  void _deleteCategory(String categoryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه الفئة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              final categoryCubit = getIt<CategoryCubit>();
              categoryCubit.add(DeleteCategory(categoryId));
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _refreshMenu() {
    try {
      final menuCubit = getIt<MenuCubit>();
      menuCubit.add(LoadMenuItems());
      print('🔄 AdminAddCategoryPage: Triggered menu refresh');
    } catch (e) {
      print('❌ AdminAddCategoryPage: Error refreshing menu - $e');
    }
  }
}
