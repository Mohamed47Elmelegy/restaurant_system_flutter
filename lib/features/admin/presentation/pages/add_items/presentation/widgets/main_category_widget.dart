import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theme/theme_helper.dart';
import '../../../add_category/presentation/cubit/category_states.dart';
import '../../../add_category/presentation/cubit/category_events.dart';
import '../../../add_category/presentation/cubit/category_cubit.dart';

class MainCategoryWidget extends StatefulWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const MainCategoryWidget({
    super.key,
    this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  State<MainCategoryWidget> createState() => _MainCategoryWidgetState();
}

class _MainCategoryWidgetState extends State<MainCategoryWidget> {
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    // Load categories when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  void _loadCategories() {
    // Only load if not already loaded
    if (!_hasLoadedOnce) {
      context.read<CategoryCubit>().add(LoadCategories());
      _hasLoadedOnce = true;
    }
  }

  void _forceRefreshCategories() {
    // Force refresh only when user explicitly requests it
    // This will be used only in error state
    context.read<CategoryCubit>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MAIN CATEGORY',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getPrimaryTextColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: ThemeHelper.getBorderColor(context, false),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: null,
                    isExpanded: true,
                    hint: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Loading categories...'),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ],
                    ),
                    items: [],
                    onChanged: null,
                  ),
                );
              }

              if (state is CategoryError) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: null,
                    isExpanded: true,
                    hint: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Error loading categories'),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.refresh, size: 16),
                          onPressed: _forceRefreshCategories,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                    items: [],
                    onChanged: null,
                  ),
                );
              }

              if (state is CategoriesLoaded) {
                final categories = state.categories;

                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.selectedCategory,
                    isExpanded: true,
                    hint: Text(
                      'Select main category',
                      style: TextStyle(
                        color: ThemeHelper.getSecondaryTextColor(context),
                      ),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id.toString(),
                        child: Text('${category.name} '),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        widget.onCategoryChanged(value);
                      }
                    },
                  ),
                );
              }

              // Default state - show loading
              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: null,
                  isExpanded: true,
                  hint: const Text('Loading categories...'),
                  items: [],
                  onChanged: null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
