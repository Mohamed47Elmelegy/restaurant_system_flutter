import 'package:equatable/equatable.dart';
import '../../domain/usecases/load_menu_items_by_category_usecase.dart';
import '../../domain/usecases/search_menu_items_usecase.dart';
import '../../domain/usecases/delete_menu_item_usecase.dart';
import '../../domain/usecases/toggle_menu_item_availability_usecase.dart';

// Events
abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

class LoadMenuItems extends MenuEvent {}

class LoadMenuItemsByCategory extends MenuEvent {
  final LoadMenuItemsByCategoryParams params;

  const LoadMenuItemsByCategory(this.params);

  @override
  List<Object?> get props => [params];
}

class SearchMenuItems extends MenuEvent {
  final SearchMenuItemsParams params;

  const SearchMenuItems(this.params);

  @override
  List<Object?> get props => [params];
}

class DeleteMenuItem extends MenuEvent {
  final DeleteMenuItemParams params;

  const DeleteMenuItem(this.params);

  @override
  List<Object?> get props => [params];
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
  final ToggleMenuItemAvailabilityParams params;

  const ToggleMenuItemAvailability(this.params);

  @override
  List<Object?> get props => [params];
}
