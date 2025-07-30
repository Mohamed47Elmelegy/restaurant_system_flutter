import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import '../../domain/usecases/load_menu_items_usecase.dart';
import '../../domain/usecases/load_menu_items_by_category_usecase.dart';
import '../../domain/usecases/search_menu_items_usecase.dart';
import '../../domain/usecases/delete_menu_item_usecase.dart';
import '../../domain/usecases/toggle_menu_item_availability_usecase.dart';
import 'menu_events.dart';
import 'menu_states.dart';

// Cubit
class MenuCubit extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;
  final LoadMenuItemsUseCase loadMenuItemsUseCase;
  final LoadMenuItemsByCategoryUseCase loadMenuItemsByCategoryUseCase;
  final SearchMenuItemsUseCase searchMenuItemsUseCase;
  final DeleteMenuItemUseCase deleteMenuItemUseCase;
  final ToggleMenuItemAvailabilityUseCase toggleMenuItemAvailabilityUseCase;

  MenuCubit({required this.menuRepository})
    : loadMenuItemsUseCase = LoadMenuItemsUseCase(repository: menuRepository),
      loadMenuItemsByCategoryUseCase = LoadMenuItemsByCategoryUseCase(
        repository: menuRepository,
      ),
      searchMenuItemsUseCase = SearchMenuItemsUseCase(
        repository: menuRepository,
      ),
      deleteMenuItemUseCase = DeleteMenuItemUseCase(repository: menuRepository),
      toggleMenuItemAvailabilityUseCase = ToggleMenuItemAvailabilityUseCase(
        repository: menuRepository,
      ),
      super(MenuInitial()) {
    on<LoadMenuItems>(_onLoadMenuItems);
    on<LoadMenuItemsByCategory>(_onLoadMenuItemsByCategory);
    on<SearchMenuItems>(_onSearchMenuItems);
    on<DeleteMenuItem>(_onDeleteMenuItem);
    on<RefreshMenuItems>(_onRefreshMenuItems);
    on<FilterMenuItems>(_onFilterMenuItems);
    on<SortMenuItems>(_onSortMenuItems);
    on<LoadMenuCategories>(_onLoadMenuCategories);
    on<ToggleMenuItemAvailability>(_onToggleMenuItemAvailability);
  }

  /// Get categories from repository
  Future<List<String>> getCategories() async {
    return await menuRepository.getCategories();
  }

  Future<void> _onLoadMenuItems(
    LoadMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      log('🔄 MenuCubit: Loading menu items...');
      final menuItems = await loadMenuItemsUseCase();
      final categories = await menuRepository.getCategories();

      log(
        '✅ MenuCubit: Menu items loaded successfully - ${menuItems.length} items',
      );
      log('✅ MenuCubit: Categories loaded - ${categories.length} categories');

      emit(MenuItemsLoaded(menuItems, categories: categories));
    } catch (e) {
      log('❌ MenuCubit: Failed to load menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onLoadMenuItemsByCategory(
    LoadMenuItemsByCategory event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      log(
        '🔄 MenuCubit: Loading menu items for category: ${event.params.category}',
      );
      final menuItems = await loadMenuItemsByCategoryUseCase(event.params);
      final categories = await menuRepository.getCategories();

      log(
        '✅ MenuCubit: Menu items loaded for category - ${menuItems.length} items',
      );

      if (menuItems.isEmpty) {
        emit(
          MenuEmpty(
            message: 'لا توجد منتجات في هذه الفئة',
            selectedCategory: event.params.category,
          ),
        );
      } else {
        emit(
          MenuItemsLoaded(
            menuItems,
            selectedCategory: event.params.category,
            categories: categories,
          ),
        );
      }
    } catch (e) {
      log('❌ MenuCubit: Failed to load menu items by category - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onSearchMenuItems(
    SearchMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      log(
        '🔄 MenuCubit: Searching menu items with query: ${event.params.query}',
      );
      final menuItems = await searchMenuItemsUseCase(event.params);
      log('✅ MenuCubit: Search completed - ${menuItems.length} items found');

      if (menuItems.isEmpty) {
        emit(MenuSearchResults([], event.params.query));
      } else {
        emit(MenuSearchResults(menuItems, event.params.query));
      }
    } catch (e) {
      log('❌ MenuCubit: Failed to search menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onDeleteMenuItem(
    DeleteMenuItem event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Deleting menu item with id: ${event.params.id}');
      final success = await deleteMenuItemUseCase(event.params);

      if (success) {
        log('✅ MenuCubit: Menu item deleted successfully');
        // Reload menu items after deletion
        final menuItems = await loadMenuItemsUseCase();
        emit(MenuItemDeleted(event.params.id, menuItems));
      } else {
        emit(MenuError('فشل في حذف المنتج'));
      }
    } catch (e) {
      log('❌ MenuCubit: Failed to delete menu item - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onRefreshMenuItems(
    RefreshMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      log('🔄 MenuCubit: Refreshing menu items...');
      final menuItems = await loadMenuItemsUseCase();
      final categories = await menuRepository.getCategories();

      log('✅ MenuCubit: Menu items refreshed - ${menuItems.length} items');
      emit(MenuItemsLoaded(menuItems, categories: categories));
    } catch (e) {
      log('❌ MenuCubit: Failed to refresh menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onFilterMenuItems(
    FilterMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Filtering menu items by ${event.filterType}');
      final allItems = await loadMenuItemsUseCase();
      List<MenuItem> filteredItems = [];

      switch (event.filterType) {
        case 'category':
          filteredItems = allItems
              .where((item) => item.category == event.filterValue)
              .toList();
          break;
        case 'price':
          final maxPrice = double.tryParse(event.filterValue.toString()) ?? 0.0;
          filteredItems = allItems.where((item) {
            final itemPrice = double.tryParse(item.price) ?? 0.0;
            return itemPrice <= maxPrice;
          }).toList();
          break;
        case 'availability':
          final isAvailable = event.filterValue as bool;
          filteredItems = allItems
              .where((item) => item.isAvailable == isAvailable)
              .toList();
          break;
        default:
          filteredItems = allItems;
      }

      log('✅ MenuCubit: Filtered items - ${filteredItems.length} items');
      emit(MenuFiltered(filteredItems, event.filterType, event.filterValue));
    } catch (e) {
      log('❌ MenuCubit: Failed to filter menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onSortMenuItems(
    SortMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Sorting menu items by ${event.sortBy}');
      final allItems = await loadMenuItemsUseCase();
      List<MenuItem> sortedItems = [];

      switch (event.sortBy) {
        case 'name':
          sortedItems = List.from(allItems)
            ..sort(
              (a, b) => event.ascending
                  ? a.name.compareTo(b.name)
                  : b.name.compareTo(a.name),
            );
          break;
        case 'price':
          sortedItems = List.from(allItems)
            ..sort((a, b) {
              final priceA = double.tryParse(a.price) ?? 0.0;
              final priceB = double.tryParse(b.price) ?? 0.0;
              return event.ascending
                  ? priceA.compareTo(priceB)
                  : priceB.compareTo(priceA);
            });
          break;
        case 'rating':
          sortedItems = List.from(allItems)
            ..sort(
              (a, b) => event.ascending
                  ? a.rating.compareTo(b.rating)
                  : b.rating.compareTo(a.rating),
            );
          break;
        default:
          sortedItems = allItems;
      }

      log('✅ MenuCubit: Sorted items - ${sortedItems.length} items');
      emit(MenuSorted(sortedItems, event.sortBy, event.ascending));
    } catch (e) {
      log('❌ MenuCubit: Failed to sort menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onLoadMenuCategories(
    LoadMenuCategories event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Loading menu categories...');
      final categories = await menuRepository.getCategories();
      log('✅ MenuCubit: Categories loaded - ${categories.length} categories');
      emit(MenuCategoriesLoaded(categories));
    } catch (e) {
      log('❌ MenuCubit: Failed to load categories - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onToggleMenuItemAvailability(
    ToggleMenuItemAvailability event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Toggling availability for item: ${event.params.id}');
      final updatedItem = await toggleMenuItemAvailabilityUseCase(event.params);
      log('✅ MenuCubit: Availability toggled successfully');
      emit(
        MenuItemAvailabilityToggled(event.params.id, event.params.isAvailable),
      );
    } catch (e) {
      log('❌ MenuCubit: Failed to toggle availability - $e');
      _handleError(e, emit);
    }
  }

  void _handleError(dynamic error, Emitter<MenuState> emit) {
    final errorMessage = error.toString();

    if (errorMessage.contains('اسم الفئة') ||
        errorMessage.contains('نص البحث') ||
        errorMessage.contains('معرف المنتج')) {
      emit(MenuValidationError(errorMessage));
    } else if (errorMessage.contains('تسجيل الدخول') ||
        errorMessage.contains('غير مصرح')) {
      emit(MenuAuthError(errorMessage));
    } else {
      emit(MenuError(errorMessage));
    }
  }
}
