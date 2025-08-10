import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
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
    on<ResetProductForm>(_onResetProductForm);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      log('🔄 ProductCubit: Loading products...');
      final result = await getProductsUseCase();

      result.fold(
        (failure) {
          log('❌ ProductCubit: Failed to load products - $failure');
          emit(ProductError(failure.message));
        },
        (products) {
          log(
            '✅ ProductCubit: Products loaded successfully - ${products.length} products',
          );
          emit(ProductsLoaded(products));
        },
      );
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

      // ✅ استخدام UseCase مع Product مباشرة
      final result = await createProductUseCase(event.product);

      result.fold(
        (failure) {
          log('❌ ProductCubit: Failed to create product - $failure');

          // ✅ معالجة أخطاء مختلفة
          if (failure.message.contains('اسم المنتج') ||
              failure.message.contains('السعر') ||
              failure.message.contains('فئة')) {
            emit(ProductValidationError(failure.message));
          } else if (failure.message.contains('تسجيل الدخول') ||
              failure.message.contains('مصادقة')) {
            emit(ProductAuthError(failure.message));
          } else {
            emit(ProductError(failure.message));
          }
        },
        (createdProduct) {
          log(
            '✅ ProductCubit: Product created successfully - ${createdProduct.name}',
          );
          log('✅ ProductCubit: Created product ID - ${createdProduct.id}');
          emit(ProductCreated(createdProduct));
        },
      );
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
      // final result = await updateProductUseCase(event.product);

      log(
        '✅ ProductCubit: Product updated successfully - ${event.product.name}',
      );

      emit(ProductUpdated(event.product));
    } catch (e) {
      log('❌ ProductCubit: Failed to update product - $e');
      emit(ProductError(e.toString()));
    }
  }

  void _onResetProductForm(ResetProductForm event, Emitter<ProductState> emit) {
    log('🔄 ProductCubit: Resetting product form');
    emit(ProductFormReset());
  }
}
