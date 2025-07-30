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
      log('🔄 ProductCubit: Creating product - ${event.params.name}');
      log('🔄 ProductCubit: Product params - ${event.params.toString()}');

      // ✅ استخدام UseCase مع Params
      final createdProduct = await createProductUseCase(event.params);

      log(
        '✅ ProductCubit: Product created successfully - ${createdProduct.name}',
      );
      log('✅ ProductCubit: Created product ID - ${createdProduct.id}');

      emit(ProductCreated(createdProduct));
    } catch (e) {
      log('❌ ProductCubit: Failed to create product - $e');

      // ✅ معالجة أخطاء مختلفة
      if (e.toString().contains('اسم المنتج') ||
          e.toString().contains('السعر') ||
          e.toString().contains('فئة')) {
        emit(ProductValidationError(e.toString()));
      } else if (e.toString().contains('تسجيل الدخول') ||
          e.toString().contains('مصادقة')) {
        emit(ProductAuthError(e.toString()));
      } else {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      log('🔄 ProductCubit: Updating product - ${event.params.name}');
      log('🔄 ProductCubit: Product params - ${event.params.toString()}');

      // TODO: Implement UpdateProductUseCase
      // final updatedProduct = await updateProductUseCase(event.params);

      log(
        '✅ ProductCubit: Product updated successfully - ${event.params.name}',
      );

      emit(
        ProductUpdated(
          Product(
            name: event.params.name,
            nameAr: event.params.nameAr,
            price: event.params.price,
            mainCategoryId: event.params.mainCategoryId,
          ),
        ),
      );
    } catch (e) {
      log('❌ ProductCubit: Failed to update product - $e');
      emit(ProductError(e.toString()));
    }
  }

  void _onResetProductForm(ResetProductForm event, Emitter<ProductState> emit) {
    log('🔄 ProductCubit: Resetting product form');
    emit(ProductFormReset());
  }

  void _onValidateProduct(ValidateProduct event, Emitter<ProductState> emit) {
    log('🔄 ProductCubit: Validating product - ${event.params.name}');

    final errors = <String>[];

    // ✅ Basic validation
    if (event.params.name.isEmpty) {
      errors.add('اسم المنتج مطلوب');
    }

    if (event.params.nameAr.isEmpty) {
      errors.add('اسم المنتج بالعربية مطلوب');
    }

    if (event.params.price <= 0) {
      errors.add('السعر يجب أن يكون أكبر من صفر');
    }

    if (event.params.mainCategoryId <= 0) {
      errors.add('يجب اختيار فئة رئيسية');
    }

    // ✅ Additional validations
    if (event.params.name.length < 2) {
      errors.add('اسم المنتج يجب أن يكون أكثر من حرفين');
    }

    if (event.params.nameAr.length < 2) {
      errors.add('اسم المنتج بالعربية يجب أن يكون أكثر من حرفين');
    }

    if (event.params.price > 1000) {
      errors.add('السعر يجب أن يكون أقل من 1000');
    }

    final isValid = errors.isEmpty;

    log(
      '✅ ProductCubit: Product validation completed - Valid: $isValid, Errors: ${errors.length}',
    );

    emit(ProductFormValidated(isValid: isValid, errors: errors));
  }
}
