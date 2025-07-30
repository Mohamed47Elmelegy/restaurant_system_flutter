import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

// States
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;

  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductCreated extends ProductState {
  final Product product;

  const ProductCreated(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductUpdated extends ProductState {
  final Product product;

  const ProductUpdated(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductDeleted extends ProductState {
  final int productId;

  const ProductDeleted(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ProductFormValidated extends ProductState {
  final bool isValid;
  final List<String> errors;

  const ProductFormValidated({required this.isValid, this.errors = const []});

  @override
  List<Object?> get props => [isValid, errors];
}

class ProductFormReset extends ProductState {}

class ProductError extends ProductState {
  final String message;
  final String? code;

  const ProductError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}
