import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/main_category.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_events.dart';
import '../cubit/category_states.dart';

/// 🟦 AdminAddCategoryPage - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن عرض واجهة إضافة الفئات فقط
class AdminAddCategoryPage extends StatefulWidget {
  const AdminAddCategoryPage({super.key});

  @override
  State<AdminAddCategoryPage> createState() => _AdminAddCategoryPageState();
}

class _AdminAddCategoryPageState extends State<AdminAddCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameArController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionArController = TextEditingController();
  final _sortOrderController = TextEditingController();
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _sortOrderController.text = '0';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameArController.dispose();
    _descriptionController.dispose();
    _descriptionArController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة فئة جديدة'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<CategoryCubit, CategoryState>(
        listener: (context, state) {
          if (state is CategoryCreated) {
            _showSuccessDialog('تم إنشاء الفئة بنجاح');
            _clearForm();
          } else if (state is CategoryValidationError) {
            _showErrorDialog(state.message);
          } else if (state is CategoryAuthError) {
            _showErrorDialog('خطأ في المصادقة: ${state.message}');
          } else if (state is CategoryError) {
            _showErrorDialog('خطأ: ${state.message}');
          }
        },
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Category Name (English)
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم الفئة (إنجليزي)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'اسم الفئة مطلوب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Category Name (Arabic)
                    TextFormField(
                      controller: _nameArController,
                      decoration: const InputDecoration(
                        labelText: 'اسم الفئة (عربي)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'اسم الفئة بالعربية مطلوب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description (English)
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'وصف الفئة (إنجليزي)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Description (Arabic)
                    TextFormField(
                      controller: _descriptionArController,
                      decoration: const InputDecoration(
                        labelText: 'وصف الفئة (عربي)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Sort Order
                    TextFormField(
                      controller: _sortOrderController,
                      decoration: const InputDecoration(
                        labelText: 'ترتيب الفئة',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ترتيب الفئة مطلوب';
                        }
                        final sortOrder = int.tryParse(value);
                        if (sortOrder == null || sortOrder < 0) {
                          return 'ترتيب الفئة يجب أن يكون رقم موجب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Is Active Switch
                    SwitchListTile(
                      title: const Text('الفئة نشطة'),
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    ElevatedButton(
                      onPressed: state is CategoryLoading
                          ? null
                          : _onSaveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state is CategoryLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'حفظ الفئة',
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onSaveChanges() {
    if (_formKey.currentState!.validate()) {
      final category = MainCategory(
        id: '', // Will be set by the server
        name: _nameController.text.trim(),
        nameAr: _nameArController.text.trim(),
        description: _descriptionController.text.trim(),
        descriptionAr: _descriptionArController.text.trim(),
        sortOrder: int.tryParse(_sortOrderController.text) ?? 0,
        isActive: _isActive,
      );

      BlocProvider.of<CategoryCubit>(
        context,
        listen: false,
      ).add(CreateCategory(category));
    }
  }

  void _clearForm() {
    _nameController.clear();
    _nameArController.clear();
    _descriptionController.clear();
    _descriptionArController.clear();
    _sortOrderController.text = '0';
    setState(() {
      _isActive = true;
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
