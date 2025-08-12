import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/entities/main_category.dart';
import '../../../../../../../core/theme/theme_helper.dart';
import '../../../../../../../core/widgets/animated_custom_dropdown_list.dart';
import '../../../add_category/presentation/cubit/category_cubit.dart';
import '../../../add_category/presentation/cubit/category_events.dart';
import '../../../add_category/presentation/cubit/category_states.dart';

class MainCategoryWidget extends StatefulWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final List<CategoryEntity>? categories;
  const MainCategoryWidget({
    super.key,
    this.selectedCategory,
    required this.onCategoryChanged,
    this.categories,
  });

  @override
  State<MainCategoryWidget> createState() => _MainCategoryWidgetState();
}

class _MainCategoryWidgetState extends State<MainCategoryWidget> {
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  void _loadCategories() {
    if (!_hasLoadedOnce) {
      context.read<CategoryCubit>().add(const LoadCategories());
      _hasLoadedOnce = true;
    }
  }

  void _forceRefreshCategories() {
    context.read<CategoryCubit>().add(const LoadCategories());
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
                return CustomAnimatedDropdown<String>(
                  items: const [],
                  itemLabel: (item) => item,
                  selectedValue: null,
                  onChanged: (_) {},
                  hintText: 'Select main category',
                  isLoading: true,
                );
              }

              if (state is CategoryError) {
                return CustomAnimatedDropdown<String>(
                  items: const [],
                  itemLabel: (item) => item,
                  selectedValue: null,
                  onChanged: (_) {},
                  hintText: 'Select main category',
                  errorMessage: 'Error loading categories',
                  onRetry: _forceRefreshCategories,
                );
              }

            if (state is CategoriesLoaded) {
  final categories = state.categories;

  // قائمة أسماء الفئات
  final categoryNames = categories.map((c) => c.name).toList();

  return CustomAnimatedDropdown<String>(
    items: categoryNames,  // هنا بنستخدم الأسماء مش الـ ids
    itemLabel: (name) => name, // الاسم نفسه يتعرض
    selectedValue: widget.selectedCategory, // خليها اسم مش id
    onChanged: (selectedName) {
      if (selectedName != null) {
        widget.onCategoryChanged(selectedName); // هترجع الاسم مباشرة
      }
    },
    hintText: 'Select main category',
  );
}


              return CustomAnimatedDropdown<String>(
                items: const [],
                itemLabel: (item) => item,
                selectedValue: null,
                onChanged: (_) {},
                hintText: 'Loading categories...',
                isLoading: true,
              );
            },
          ),
        ),
      ],
    );
  }
}
