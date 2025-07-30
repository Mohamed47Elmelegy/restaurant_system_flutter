import 'package:equatable/equatable.dart';

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

class RefreshMenuItems extends MenuEvent {}

class FilterMenuItems extends MenuEvent {
  final String filterType;
  final dynamic filterValue;

  const FilterMenuItems(this.filterType, this.filterValue);

  @override
  List<Object?> get props => [filterType, filterValue];
}

class SortMenuItems extends MenuEvent {
  final String sortBy;
  final bool ascending;

  const SortMenuItems(this.sortBy, {this.ascending = true});

  @override
  List<Object?> get props => [sortBy, ascending];
}

class LoadMenuCategories extends MenuEvent {}

class ToggleMenuItemAvailability extends MenuEvent {
  final String id;
  final bool isAvailable;

  const ToggleMenuItemAvailability(this.id, this.isAvailable);

  @override
  List<Object?> get props => [id, isAvailable];
}
