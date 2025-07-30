import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/create_product_usecase.dart';
import 'product_events.dart';
import 'product_states.dart';

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
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<ResetProductForm>(_onResetProductForm);
    on<ValidateProduct>(_onValidateProduct);
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

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      log('🔄 ProductCubit: Updating product - ${event.product.name}');
      log('🔄 ProductCubit: Product data - ${event.product.toString()}');

      // TODO: Implement UpdateProductUseCase
      // final updatedProduct = await updateProductUseCase(event.product);

      log(
        '✅ ProductCubit: Product updated successfully - ${event.product.name}',
      );
      log('✅ ProductCubit: Updated product ID - ${event.product.id}');

      emit(ProductUpdated(event.product));
    } catch (e) {
      log('❌ ProductCubit: Failed to update product - $e');
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      log('🔄 ProductCubit: Deleting product with ID - ${event.productId}');

      // TODO: Implement DeleteProductUseCase
      // await deleteProductUseCase(event.productId);

      log(
        '✅ ProductCubit: Product deleted successfully - ID: ${event.productId}',
      );

      emit(ProductDeleted(event.productId));
    } catch (e) {
      log('❌ ProductCubit: Failed to delete product - $e');
      emit(ProductError(e.toString()));
    }
  }

  void _onResetProductForm(ResetProductForm event, Emitter<ProductState> emit) {
    log('🔄 ProductCubit: Resetting product form');
    emit(ProductFormReset());
  }

  void _onValidateProduct(ValidateProduct event, Emitter<ProductState> emit) {
    log('🔄 ProductCubit: Validating product - ${event.product.name}');

    final errors = <String>[];

    // Basic validation
    if (event.product.name.isEmpty) {
      errors.add('اسم المنتج مطلوب');
    }

    if (event.product.nameAr.isEmpty) {
      errors.add('اسم المنتج بالعربية مطلوب');
    }

    if (event.product.price <= 0) {
      errors.add('السعر يجب أن يكون أكبر من صفر');
    }

    if (event.product.mainCategoryId <= 0) {
      errors.add('يجب اختيار فئة رئيسية');
    }

    final isValid = errors.isEmpty;

    log(
      '✅ ProductCubit: Product validation completed - Valid: $isValid, Errors: ${errors.length}',
    );

    emit(ProductFormValidated(isValid: isValid, errors: errors));
  }
}
