import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import '../../domain/usecases/load_menu_items_usecase.dart';
import '../../domain/usecases/load_menu_items_by_category_usecase.dart';
import '../../domain/usecases/search_menu_items_usecase.dart';
import '../../domain/usecases/delete_menu_item_usecase.dart';
import '../../domain/usecases/toggle_menu_item_availability_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
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
  Future<Either<Failure, List<String>>> getCategories() async {
    return await menuRepository.getCategories();
  }

  Future<void> _onLoadMenuItems(
    LoadMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      log('🔄 MenuCubit: Loading menu items...');
      final menuItemsResult = await loadMenuItemsUseCase();

      return menuItemsResult.fold(
        (failure) {
          log('❌ MenuCubit: Failed to load menu items - ${failure.message}');
          _handleFailure(failure, emit);
        },
        (menuItems) async {
          final categoriesResult = await menuRepository.getCategories();

          return categoriesResult.fold(
            (failure) {
              log(
                '❌ MenuCubit: Failed to load categories - ${failure.message}',
              );
              _handleFailure(failure, emit);
            },
            (categories) {
              log(
                '✅ MenuCubit: Menu items loaded successfully - ${menuItems.length} items',
              );
              log(
                '✅ MenuCubit: Categories loaded - ${categories.length} categories',
              );
              emit(MenuItemsLoaded(menuItems, categories: categories));
            },
          );
        },
      );
    } catch (e) {
      log('❌ MenuCubit: Unexpected error loading menu items - $e');
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
      final menuItemsResult = await loadMenuItemsByCategoryUseCase(
        event.params,
      );

      return menuItemsResult.fold(
        (failure) {
          log(
            '❌ MenuCubit: Failed to load menu items by category - ${failure.message}',
          );
          _handleFailure(failure, emit);
        },
        (menuItems) async {
          final categoriesResult = await menuRepository.getCategories();

          return categoriesResult.fold(
            (failure) {
              log(
                '❌ MenuCubit: Failed to load categories - ${failure.message}',
              );
              _handleFailure(failure, emit);
            },
            (categories) {
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
            },
          );
        },
      );
    } catch (e) {
      log('❌ MenuCubit: Unexpected error loading menu items by category - $e');
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
      final menuItemsResult = await searchMenuItemsUseCase(event.params);

      return menuItemsResult.fold(
        (failure) {
          log('❌ MenuCubit: Failed to search menu items - ${failure.message}');
          _handleFailure(failure, emit);
        },
        (menuItems) {
          log(
            '✅ MenuCubit: Search completed - ${menuItems.length} items found',
          );

          if (menuItems.isEmpty) {
            emit(
              MenuEmpty(message: 'لا توجد نتائج للبحث: ${event.params.query}'),
            );
          } else {
            emit(MenuItemsLoaded(menuItems, searchQuery: event.params.query));
          }
        },
      );
    } catch (e) {
      log('❌ MenuCubit: Unexpected error searching menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onDeleteMenuItem(
    DeleteMenuItem event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Deleting menu item: ${event.params.id}');
      final deleteResult = await deleteMenuItemUseCase(event.params);

      return deleteResult.fold(
        (failure) {
          log('❌ MenuCubit: Failed to delete menu item - ${failure.message}');
          _handleFailure(failure, emit);
        },
        (success) async {
          log('✅ MenuCubit: Menu item deleted successfully');
          // Reload remaining items after deletion
          final remainingItemsResult = await loadMenuItemsUseCase();
          return remainingItemsResult.fold(
            (failure) {
              log(
                '❌ MenuCubit: Failed to load remaining items - ${failure.message}',
              );
              _handleFailure(failure, emit);
            },
            (remainingItems) {
              emit(MenuItemDeleted(event.params.id, remainingItems));
            },
          );
        },
      );
    } catch (e) {
      log('❌ MenuCubit: Unexpected error deleting menu item - $e');
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
      final menuItemsResult = await loadMenuItemsUseCase();

      return menuItemsResult.fold(
        (failure) {
          log('❌ MenuCubit: Failed to refresh menu items - ${failure.message}');
          _handleFailure(failure, emit);
        },
        (menuItems) async {
          final categoriesResult = await menuRepository.getCategories();

          return categoriesResult.fold(
            (failure) {
              log(
                '❌ MenuCubit: Failed to load categories - ${failure.message}',
              );
              _handleFailure(failure, emit);
            },
            (categories) {
              log(
                '✅ MenuCubit: Menu items refreshed - ${menuItems.length} items',
              );
              emit(MenuItemsLoaded(menuItems, categories: categories));
            },
          );
        },
      );
    } catch (e) {
      log('❌ MenuCubit: Unexpected error refreshing menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onFilterMenuItems(
    FilterMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Filtering menu items by ${event.filterType}');
      final allItemsResult = await loadMenuItemsUseCase();
      List<MenuItem> filteredItems = [];

      return allItemsResult.fold(
        (failure) {
          log('❌ MenuCubit: Failed to filter menu items - ${failure.message}');
          _handleFailure(failure, emit);
        },
        (allItems) {
          switch (event.filterType) {
            case 'category':
              filteredItems = allItems
                  .where((item) => item.category == event.filterValue)
                  .toList();
              break;
            case 'price':
              final maxPrice =
                  double.tryParse(event.filterValue.toString()) ?? 0.0;
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
          emit(
            MenuFiltered(filteredItems, event.filterType, event.filterValue),
          );
        },
      );
    } catch (e) {
      log('❌ MenuCubit: Unexpected error filtering menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onSortMenuItems(
    SortMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Sorting menu items by ${event.sortBy}');
      final allItemsResult = await loadMenuItemsUseCase();
      List<MenuItem> sortedItems = [];

      return allItemsResult.fold(
        (failure) {
          log('❌ MenuCubit: Failed to sort menu items - ${failure.message}');
          _handleFailure(failure, emit);
        },
        (allItems) {
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
        },
      );
    } catch (e) {
      log('❌ MenuCubit: Unexpected error sorting menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onLoadMenuCategories(
    LoadMenuCategories event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Loading menu categories...');
      final categoriesResult = await menuRepository.getCategories();

      return categoriesResult.fold(
        (failure) {
          log('❌ MenuCubit: Failed to load categories - ${failure.message}');
          _handleFailure(failure, emit);
        },
        (categories) {
          log(
            '✅ MenuCubit: Categories loaded - ${categories.length} categories',
          );
          emit(MenuCategoriesLoaded(categories));
        },
      );
    } catch (e) {
      log('❌ MenuCubit: Unexpected error loading categories - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onToggleMenuItemAvailability(
    ToggleMenuItemAvailability event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Toggling availability for item: ${event.params.id}');
      final toggleResult = await toggleMenuItemAvailabilityUseCase(
        event.params,
      );

      return toggleResult.fold(
        (failure) {
          log(
            '❌ MenuCubit: Failed to toggle availability - ${failure.message}',
          );
          _handleFailure(failure, emit);
        },
        (updatedItem) {
          log('✅ MenuCubit: Availability toggled successfully');
          emit(
            MenuItemAvailabilityToggled(
              event.params.id,
              event.params.isAvailable,
            ),
          );
        },
      );
    } catch (e) {
      log('❌ MenuCubit: Unexpected error toggling availability - $e');
      _handleError(e, emit);
    }
  }

  void _handleFailure(Failure failure, Emitter<MenuState> emit) {
    if (failure is ServerFailure) {
      final message = failure.message;
      if (message.contains('اسم الفئة') ||
          message.contains('نص البحث') ||
          message.contains('معرف المنتج')) {
        emit(MenuValidationError(message));
      } else if (message.contains('تسجيل الدخول') ||
          message.contains('غير مصرح')) {
        emit(MenuAuthError(message));
      } else {
        emit(MenuError(message));
      }
    } else {
      emit(MenuError(failure.message));
    }
  }

  void _handleError(dynamic error, Emitter<MenuState> emit) {
    final errorMessage = error.toString();
    emit(MenuError(errorMessage));
  }
}
