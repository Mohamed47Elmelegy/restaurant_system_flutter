import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/create_product_usecase.dart';

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

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class ProductCubit extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final CreateProductUseCase createProductUseCase;

  ProductCubit({
    required this.getProductsUseCase,
    required this.createProductUseCase,
  }) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<CreateProduct>(_onCreateProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      log('🔄 ProductCubit: Loading products...');
      final products = await getProductsUseCase();
      log(
        '✅ ProductCubit: Products loaded successfully - ${products.length} products',
      );
      emit(ProductsLoaded(products));
    } catch (e) {
      log('❌ ProductCubit: Failed to load products - $e');
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      log('🔄 ProductCubit: Creating product - ${event.product.name}');
      log('🔄 ProductCubit: Product data - ${event.product.toString()}');

      final createdProduct = await createProductUseCase(event.product);

      log(
        '✅ ProductCubit: Product created successfully - ${createdProduct.name}',
      );
      log('✅ ProductCubit: Created product ID - ${createdProduct.id}');

      emit(ProductCreated(createdProduct));
    } catch (e) {
      log('❌ ProductCubit: Failed to create product - $e');
      emit(ProductError(e.toString()));
    }
  }
}
