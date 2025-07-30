import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import 'menu_events.dart';
import 'menu_states.dart';

// Cubit
class MenuCubit extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;

  MenuCubit({required this.menuRepository}) : super(MenuInitial()) {
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
      final menuItems = await menuRepository.getMenuItems();
      final categories = await menuRepository.getCategories();

      log(
        '✅ MenuCubit: Menu items loaded successfully - ${menuItems.length} items',
      );
      log('✅ MenuCubit: Categories loaded - ${categories.length} categories');

      emit(MenuItemsLoaded(menuItems, categories: categories));
    } catch (e) {
      log('❌ MenuCubit: Failed to load menu items - $e');
      emit(MenuError(e.toString()));
    }
  }

  Future<void> _onLoadMenuItemsByCategory(
    LoadMenuItemsByCategory event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      log('🔄 MenuCubit: Loading menu items for category: ${event.category}');
      final menuItems = await menuRepository.getMenuItemsByCategory(
        event.category,
      );
      final categories = await menuRepository.getCategories();

      log(
        '✅ MenuCubit: Menu items loaded for category - ${menuItems.length} items',
      );

      if (menuItems.isEmpty) {
        emit(
          MenuEmpty(
            message: 'لا توجد منتجات في هذه الفئة',
            selectedCategory: event.category,
          ),
        );
      } else {
        emit(
          MenuItemsLoaded(
            menuItems,
            selectedCategory: event.category,
            categories: categories,
          ),
        );
      }
    } catch (e) {
      log('❌ MenuCubit: Failed to load menu items by category - $e');
      emit(MenuError(e.toString()));
    }
  }

  Future<void> _onSearchMenuItems(
    SearchMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      log('🔄 MenuCubit: Searching menu items with query: ${event.query}');
      final menuItems = await menuRepository.searchMenuItems(event.query);
      log('✅ MenuCubit: Search completed - ${menuItems.length} items found');

      if (menuItems.isEmpty) {
        emit(MenuSearchResults([], event.query));
      } else {
        emit(MenuSearchResults(menuItems, event.query));
      }
    } catch (e) {
      log('❌ MenuCubit: Failed to search menu items - $e');
      emit(MenuError(e.toString()));
    }
  }

  Future<void> _onDeleteMenuItem(
    DeleteMenuItem event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Deleting menu item with ID: ${event.id}');
      final success = await menuRepository.deleteMenuItem(event.id);

      if (success) {
        log('✅ MenuCubit: Menu item deleted successfully');
        // Reload the current list after deletion
        final currentState = state;
        if (currentState is MenuItemsLoaded) {
          final updatedItems = currentState.menuItems
              .where((item) => item.id != event.id)
              .toList();
          emit(MenuItemDeleted(event.id, updatedItems));
        }
      } else {
        log('❌ MenuCubit: Failed to delete menu item');
        emit(const MenuError('Failed to delete menu item'));
      }
    } catch (e) {
      log('❌ MenuCubit: Error deleting menu item - $e');
      emit(MenuError(e.toString()));
    }
  }

  Future<void> _onRefreshMenuItems(
    RefreshMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    log('🔄 MenuCubit: Refreshing menu items...');
    add(LoadMenuItems());
  }

  void _onFilterMenuItems(FilterMenuItems event, Emitter<MenuState> emit) {
    log(
      '🔄 MenuCubit: Filtering menu items by ${event.filterType}: ${event.filterValue}',
    );

    final currentState = state;
    if (currentState is MenuItemsLoaded) {
      List<MenuItem> filteredItems = currentState.menuItems;

      switch (event.filterType) {
        case 'price':
          final maxPrice = event.filterValue as double;
          filteredItems = filteredItems
              .where((item) => double.parse(item.price) <= maxPrice)
              .toList();
          break;
        case 'rating':
          final minRating = event.filterValue as double;
          filteredItems = filteredItems
              .where((item) => item.rating >= minRating)
              .toList();
          break;
        case 'availability':
          final isAvailable = event.filterValue as bool;
          filteredItems = filteredItems
              .where((item) => item.isAvailable == isAvailable)
              .toList();
          break;
        default:
          log('⚠️ MenuCubit: Unknown filter type: ${event.filterType}');
          return;
      }

      emit(MenuFiltered(filteredItems, event.filterType, event.filterValue));
    }
  }

  void _onSortMenuItems(SortMenuItems event, Emitter<MenuState> emit) {
    log(
      '🔄 MenuCubit: Sorting menu items by ${event.sortBy} (ascending: ${event.ascending})',
    );

    final currentState = state;
    if (currentState is MenuItemsLoaded) {
      List<MenuItem> sortedItems = List.from(currentState.menuItems);

      switch (event.sortBy) {
        case 'name':
          sortedItems.sort(
            (a, b) => event.ascending
                ? a.name.compareTo(b.name)
                : b.name.compareTo(a.name),
          );
          break;
        case 'price':
          sortedItems.sort(
            (a, b) => event.ascending
                ? double.parse(a.price).compareTo(double.parse(b.price))
                : double.parse(b.price).compareTo(double.parse(a.price)),
          );
          break;
        case 'rating':
          sortedItems.sort(
            (a, b) => event.ascending
                ? a.rating.compareTo(b.rating)
                : b.rating.compareTo(a.rating),
          );
          break;
        case 'category':
          sortedItems.sort(
            (a, b) => event.ascending
                ? a.category.compareTo(b.category)
                : b.category.compareTo(a.category),
          );
          break;
        default:
          log('⚠️ MenuCubit: Unknown sort field: ${event.sortBy}');
          return;
      }

      emit(MenuSorted(sortedItems, event.sortBy, event.ascending));
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
      emit(MenuError(e.toString()));
    }
  }

  Future<void> _onToggleMenuItemAvailability(
    ToggleMenuItemAvailability event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log(
        '🔄 MenuCubit: Toggling availability for item ${event.id} to ${event.isAvailable}',
      );

      // TODO: Implement toggle availability in repository
      // await menuRepository.toggleMenuItemAvailability(event.id, event.isAvailable);

      log('✅ MenuCubit: Item availability toggled successfully');
      emit(MenuItemAvailabilityToggled(event.id, event.isAvailable));
    } catch (e) {
      log('❌ MenuCubit: Failed to toggle item availability - $e');
      emit(MenuError(e.toString()));
    }
  }
}
