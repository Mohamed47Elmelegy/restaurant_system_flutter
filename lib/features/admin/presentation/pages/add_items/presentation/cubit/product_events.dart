import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product_usecase.dart';

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class CreateProduct extends ProductEvent {
  final CreateProductParams params;
  CreateProduct(this.params);
}

class UpdateProduct extends ProductEvent {
  final CreateProductParams params;
  UpdateProduct(this.params);
}

class ResetProductForm extends ProductEvent {}

class ValidateProduct extends ProductEvent {
  final CreateProductParams params;
  ValidateProduct(this.params);
}
