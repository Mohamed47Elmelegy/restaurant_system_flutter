import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/food_items_grid_view.dart';
import '../../../../core/entities/main_category.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/category_items_cubit.dart';
import '../cubit/category_items_state.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/bloc/cart_event.dart';

class CategoryItemsPage extends StatefulWidget {
  final int categoryId;
  final String? categoryName;

  const CategoryItemsPage({
    super.key,
    required this.categoryId,
    this.categoryName,
  });

  @override
  State<CategoryItemsPage> createState() => _CategoryItemsPageState();
}

class _CategoryItemsPageState extends State<CategoryItemsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<CategoryItemsCubit>()..loadCategory(widget.categoryId),
        ),
        BlocProvider(create: (_) => getIt<CartCubit>()..add(LoadCart())),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(widget.categoryName ?? 'Items')),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: BlocBuilder<CategoryItemsCubit, CategoryItemsState>(
              builder: (context, state) {
                if (state is CategoryItemsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoryItemsError) {
                  return Center(child: Text(state.message));
                } else if (state is CategoryItemsLoaded) {
                  if (state.products.isEmpty) {
                    return Center(
                      child: Text(
                        'لا توجد عناصر في هذا التصنيف',
                        style: AppTextStyles.senBold16(context),
                      ),
                    );
                  }
                  return FoodItemsGridView(
                    items: state.products,
                    categories: [
                      CategoryEntity.fromIntId(
                        id: widget.categoryId,
                        name:
                            widget.categoryName ?? 'تصنيف ${widget.categoryId}',
                        isActive: true,
                        sortOrder: 0,
                      ),
                    ],
                    padding: EdgeInsets.zero,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: false,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
