import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

// Events
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {}

class CreateProduct extends ProductEvent {
  final Product product;

  const CreateProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProduct extends ProductEvent {
  final Product product;

  const UpdateProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final int productId;

  const DeleteProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ResetProductForm extends ProductEvent {}

class ValidateProduct extends ProductEvent {
  final Product product;

  const ValidateProduct(this.product);

  @override
  List<Object?> get props => [product];
}
