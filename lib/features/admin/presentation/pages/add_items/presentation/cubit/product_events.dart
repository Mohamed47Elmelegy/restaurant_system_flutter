import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class CreateProduct extends ProductEvent {
  final Product product;
  CreateProduct(this.product);
}

class UpdateProduct extends ProductEvent {
  final Product product;
  UpdateProduct(this.product);
}

class ResetProductForm extends ProductEvent {}

class ValidateProduct extends ProductEvent {
  final Product product;
  ValidateProduct(this.product);
}
