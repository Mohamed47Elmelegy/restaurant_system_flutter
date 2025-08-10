import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {
  
  const LoadHomeData();
}

class RefreshHomeData extends HomeEvent {
  const RefreshHomeData();
}

class SelectCategory extends HomeEvent {
  final int categoryId;

  const SelectCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
