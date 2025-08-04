import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/menu_events.dart';
import '../bloc/menu_states.dart';
import '../widgets/menu_filter_tabs.dart';
import '../widgets/menu_item_card.dart';
import '../bloc/menu_cubit.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/usecases/load_menu_items_by_category_usecase.dart';
import '../../domain/usecases/delete_menu_item_usecase.dart';
import '../../../../../../../core/di/service_locator.dart';
import '../../../../../../../core/utils/app_bar_helper.dart';
import '../../../add_category/presentation/cubit/category_cubit.dart';
import '../../../add_category/presentation/cubit/category_events.dart';

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  State<AdminMenuPage> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  int _selectedCategoryIndex = 0;
  List<String> _categories = ['All']; // سيتم تحديثها من الباك إند
  bool _isLoadingCategories = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MenuCubit>()..add(RefreshMenuItems()),
      child: BlocListener<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is MenuError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is MenuItemDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حذف المنتج بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBarHelper.appBarWithDefaultBack(title: 'قائمة الطعام'),
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _isLoadingCategories
                          ? const Center(child: CircularProgressIndicator())
                          : MenuFilterTabs(
                              categories: _categories,
                              selectedIndex: _selectedCategoryIndex,
                              onCategorySelected: (index) {
                                setState(() {
                                  _selectedCategoryIndex = index;
                                });
                                final cubit = context.read<MenuCubit>();
                                if (index == 0) {
                                  cubit.add(LoadMenuItems());
                                } else {
                                  cubit.add(
                                    LoadMenuItemsByCategory(
                                      LoadMenuItemsByCategoryParams(
                                        category: _categories[index],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            _buildItemsCountText(state),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: _buildMenuItemsList(state)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // تأخير تحميل الفئات حتى يكون BlocProvider متاحاً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
      _refreshCategories();
    });
  }

  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoadingCategories = true;
      });

      // Get the cubit from the service locator instead of context
      final cubit = getIt<MenuCubit>();
      final categories = await cubit.getCategories();

      setState(() {
        _categories = ['All', ...categories.fold((l) => [], (r) => r)];
        _isLoadingCategories = false;
      });

      print(
        '✅ AdminMenuPage: Successfully loaded ${categories.length} categories from backend',
      );
      print('📋 AdminMenuPage: Categories: $_categories');
    } catch (e) {
      print('❌ AdminMenuPage: Failed to load categories - $e');

      // Fallback to default categories
      setState(() {
        _categories = [
          'All',
          'Fast Food',
          'Pizza',
          'Beverages',
          'Desserts',
          'Salads',
          'Drinks',
        ];
        _isLoadingCategories = false;
      });

      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تحميل الفئات من الباك إند: $e'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _refreshCategories() {
    try {
      final categoryCubit = getIt<CategoryCubit>();
      categoryCubit.add(const LoadCategories());
      print('🔄 AdminMenuPage: Triggered categories refresh');
    } catch (e) {
      print('❌ AdminMenuPage: Error refreshing categories - $e');
    }
  }

  String _buildItemsCountText(MenuState state) {
    if (state is MenuItemsLoaded) {
      return 'Total ${state.menuItems.length} items';
    } else if (state is MenuLoading) {
      return 'Loading...';
    } else if (state is MenuError) {
      return 'Error loading items';
    }
    return 'No items';
  }

  Widget _buildMenuItemsList(MenuState state) {
    if (state is MenuLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is MenuError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ في تحميل البيانات',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Use service locator instead of context
                getIt<MenuCubit>().add(LoadMenuItems());
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (state is MenuItemsLoaded || state is MenuItemDeleted) {
      final items = state is MenuItemsLoaded
          ? state.menuItems
          : (state as MenuItemDeleted).remainingItems;

      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'لا توجد منتجات',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'لم يتم العثور على منتجات في هذه الفئة',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return MenuItemCard(
              name: item.name,
              category: item.category,
              rating: item.rating,
              reviewCount: item.reviewCount,
              price: item.price,
              imagePath: item.imagePath,
              onEdit: () => _onEditItem(item),
              onDelete: () => _onDeleteItem(item),
              onTap: () => _onItemTap(item),
            );
          },
        ),
      );
    }

    return const Center(child: Text('لا توجد بيانات'));
  }

  void _onEditItem(MenuItem item) {
    // Handle edit item
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit ${item.name}')));
  }

  void _onDeleteItem(MenuItem item) {
    // Handle delete item
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete ${item.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Use service locator instead of context
              getIt<MenuCubit>().add(
                DeleteMenuItem(DeleteMenuItemParams(id: item.id)),
              );

              // Auto refresh after deletion
              _refreshMenuItems();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Auto refresh method
  void _refreshMenuItems() {
    try {
      final menuCubit = getIt<MenuCubit>();
      menuCubit.add(RefreshMenuItems());
      print('🔄 AdminMenuPage: Triggered menu items refresh');
    } catch (e) {
      print('❌ AdminMenuPage: Error refreshing menu items - $e');
    }
  }

  void _onItemTap(MenuItem item) {
    // Handle item tap
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Selected ${item.name}')));
  }
}
