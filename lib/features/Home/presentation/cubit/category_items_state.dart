import 'package:equatable/equatable.dart';
import '../../../../core/entities/product.dart';

abstract class CategoryItemsState extends Equatable {
  const CategoryItemsState();

  @override
  List<Object?> get props => [];
}

class CategoryItemsInitial extends CategoryItemsState {}

class CategoryItemsLoading extends CategoryItemsState {}

class CategoryItemsLoaded extends CategoryItemsState {
  final List<ProductEntity> products;
  const CategoryItemsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class CategoryItemsError extends CategoryItemsState {
  final String message;
  const CategoryItemsError(this.message);

  @override
  List<Object?> get props => [message];
}
