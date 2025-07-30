import 'package:equatable/equatable.dart';
import '../../domain/entities/menu_item.dart';

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
  final List<String> categories;
  final String? searchQuery;
  final String? sortBy;
  final bool ascending;

  const MenuItemsLoaded(
    this.menuItems, {
    this.selectedCategory,
    this.categories = const [],
    this.searchQuery,
    this.sortBy,
    this.ascending = true,
  });

  @override
  List<Object?> get props => [
    menuItems,
    selectedCategory,
    categories,
    searchQuery,
    sortBy,
    ascending,
  ];

  MenuItemsLoaded copyWith({
    List<MenuItem>? menuItems,
    String? selectedCategory,
    List<String>? categories,
    String? searchQuery,
    String? sortBy,
    bool? ascending,
  }) {
    return MenuItemsLoaded(
      menuItems ?? this.menuItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }
}

class MenuItemDeleted extends MenuState {
  final String deletedId;
  final List<MenuItem> remainingItems;

  const MenuItemDeleted(this.deletedId, this.remainingItems);

  @override
  List<Object?> get props => [deletedId, remainingItems];
}

class MenuItemAvailabilityToggled extends MenuState {
  final String itemId;
  final bool isAvailable;

  const MenuItemAvailabilityToggled(this.itemId, this.isAvailable);

  @override
  List<Object?> get props => [itemId, isAvailable];
}

class MenuCategoriesLoaded extends MenuState {
  final List<String> categories;

  const MenuCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class MenuSearchResults extends MenuState {
  final List<MenuItem> searchResults;
  final String query;

  const MenuSearchResults(this.searchResults, this.query);

  @override
  List<Object?> get props => [searchResults, query];
}

class MenuFiltered extends MenuState {
  final List<MenuItem> filteredItems;
  final String filterType;
  final dynamic filterValue;

  const MenuFiltered(this.filteredItems, this.filterType, this.filterValue);

  @override
  List<Object?> get props => [filteredItems, filterType, filterValue];
}

class MenuSorted extends MenuState {
  final List<MenuItem> sortedItems;
  final String sortBy;
  final bool ascending;

  const MenuSorted(this.sortedItems, this.sortBy, this.ascending);

  @override
  List<Object?> get props => [sortedItems, sortBy, ascending];
}

class MenuError extends MenuState {
  final String message;
  final String? code;

  const MenuError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class MenuValidationError extends MenuState {
  final String message;

  const MenuValidationError(this.message);

  @override
  List<Object?> get props => [message];
}

class MenuAuthError extends MenuState {
  final String message;

  const MenuAuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class MenuEmpty extends MenuState {
  final String? message;
  final String? selectedCategory;

  const MenuEmpty({this.message, this.selectedCategory});

  @override
  List<Object?> get props => [message, selectedCategory];
}
