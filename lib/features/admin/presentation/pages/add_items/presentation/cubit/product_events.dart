import '../../../../../../../core/entities/product.dart';

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class CreateProduct extends ProductEvent {
  final ProductEntity product;
  CreateProduct(this.product);
}

class UpdateProduct extends ProductEvent {
  final ProductEntity product;
  UpdateProduct(this.product);
}

class ResetProductForm extends ProductEvent {}

class ValidateProduct extends ProductEvent {
  final ProductEntity product;
  ValidateProduct(this.product);
}
