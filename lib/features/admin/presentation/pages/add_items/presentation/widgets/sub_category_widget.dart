import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theme/theme_helper.dart';
import '../../../../../../../core/di/service_locator.dart';
import '../../../add_category/data/repositories/category_repository.dart';
import '../../../add_category/domain/entities/sub_category.dart';

class SubCategoryWidget extends StatefulWidget {
  final String mainCategoryId;
  final String? selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const SubCategoryWidget({
    super.key,
    required this.mainCategoryId,
    this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  State<SubCategoryWidget> createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> {
  List<SubCategory> _subCategories = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSubCategories();
  }

  @override
  void didUpdateWidget(SubCategoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mainCategoryId != widget.mainCategoryId) {
      _loadSubCategories();
    }
  }

  Future<void> _loadSubCategories() async {
    if (widget.mainCategoryId.isEmpty || widget.mainCategoryId == '0') {
      setState(() {
        _subCategories = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final categoryId = int.tryParse(widget.mainCategoryId);
      if (categoryId == null) {
        setState(() {
          _subCategories = [];
          _isLoading = false;
          _error = 'Invalid category ID';
        });
        return;
      }

      final repository = getIt<CategoryRepository>();
      final result = await repository.getSubCategories(categoryId);

      result.fold(
        (failure) {
          setState(() {
            _subCategories = [];
            _isLoading = false;
            _error = failure.message;
          });
        },
        (subCategories) {
          setState(() {
            _subCategories = subCategories;
            _isLoading = false;
            _error = null;
          });
        },
      );
    } catch (e) {
      setState(() {
        _subCategories = [];
        _isLoading = false;
        _error = 'Failed to load sub-categories: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUB CATEGORY',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ThemeHelper.getPrimaryTextColor(context),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: ThemeHelper.getBorderColor(context, false),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Loading sub-categories...'),
              ],
            ),
          ),
        ],
      );
    }

    if (_error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUB CATEGORY',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ThemeHelper.getPrimaryTextColor(context),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _error!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: _loadSubCategories,
                  child: Text('Retry', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_subCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SUB CATEGORY',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getPrimaryTextColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: ThemeHelper.getBorderColor(context, false),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.selectedCategory,
              hint: Text(
                'Select sub category (optional)',
                style: TextStyle(
                  color: ThemeHelper.getSecondaryTextColor(context),
                ),
              ),
              isExpanded: true,
              items: [
                ..._subCategories.map(
                  (subCategory) => DropdownMenuItem(
                    value: subCategory.id,
                    child: Text(subCategory.name),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  widget.onCategoryChanged(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
