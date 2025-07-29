import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';

// Events
abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

class LoadMenuItems extends MenuEvent {}

class LoadMenuItemsByCategory extends MenuEvent {
  final String category;

  const LoadMenuItemsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchMenuItems extends MenuEvent {
  final String query;

  const SearchMenuItems(this.query);

  @override
  List<Object?> get props => [query];
}

class DeleteMenuItem extends MenuEvent {
  final String id;

  const DeleteMenuItem(this.id);

  @override
  List<Object?> get props => [id];
}

// States
abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuItemsLoaded extends MenuState {
  final List<MenuItem> menuItems;
  final String? selectedCategory;

  const MenuItemsLoaded(this.menuItems, {this.selectedCategory});

  @override
  List<Object?> get props => [menuItems, selectedCategory];
}

class MenuItemDeleted extends MenuState {
  final String deletedId;
  final List<MenuItem> remainingItems;

  const MenuItemDeleted(this.deletedId, this.remainingItems);

  @override
  List<Object?> get props => [deletedId, remainingItems];
}

class MenuError extends MenuState {
  final String message;

  const MenuError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class MenuCubit extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;

  MenuCubit({required this.menuRepository}) : super(MenuInitial()) {
    on<LoadMenuItems>(_onLoadMenuItems);
    on<LoadMenuItemsByCategory>(_onLoadMenuItemsByCategory);
    on<SearchMenuItems>(_onSearchMenuItems);
    on<DeleteMenuItem>(_onDeleteMenuItem);
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
      log(
        '✅ MenuCubit: Menu items loaded successfully - ${menuItems.length} items',
      );
      emit(MenuItemsLoaded(menuItems));
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
      log(
        '✅ MenuCubit: Menu items loaded for category - ${menuItems.length} items',
      );
      emit(MenuItemsLoaded(menuItems, selectedCategory: event.category));
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
      emit(MenuItemsLoaded(menuItems));
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
}
