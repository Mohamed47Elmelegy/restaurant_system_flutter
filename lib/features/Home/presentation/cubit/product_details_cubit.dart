import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/product.dart';
import '../../../cart/domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import 'product_details_state.dart';

/// 🟦 ProductDetailsCubit - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إدارة حالة صفحة تفاصيل المنتج فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على Use Cases وليس Repository مباشرة
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final AddToCartUseCase addToCartUseCase;

  ProductDetailsCubit({
    required this.getProductDetailsUseCase,
    required this.toggleFavoriteUseCase,
    required this.addToCartUseCase,
  }) : super(ProductDetailsInitial());

  /// تحميل تفاصيل المنتج من الـ API
  Future<void> loadProductDetails(int productId) async {
    try {
      log('🔄 ProductDetailsCubit: Loading product details for ID: $productId');
      emit(ProductDetailsLoading());

      final result = await getProductDetailsUseCase(productId);

      result.fold(
        (failure) {
          log(
            '❌ ProductDetailsCubit: Failed to load product - ${failure.message}',
          );
          emit(ProductDetailsError(failure.message));
        },
        (product) {
          log(
            '✅ ProductDetailsCubit: Product loaded successfully - ${product.name}',
          );
          emit(ProductDetailsLoaded(product));
        },
      );
    } catch (e) {
      log('❌ ProductDetailsCubit: Failed to load product details - $e');
      emit(const ProductDetailsError('فشل تحميل تفاصيل المنتج'));
    }
  }

  /// تحميل تفاصيل المنتج (من object موجود)
  void loadProductFromEntity(ProductEntity product) {
    try {
      log(
        '🔄 ProductDetailsCubit: Loading product details for ${product.name}',
      );
      emit(ProductDetailsLoaded(product));
    } catch (e) {
      log('❌ ProductDetailsCubit: Failed to load product details - $e');
      emit(const ProductDetailsError('فشل تحميل تفاصيل المنتج'));
    }
  }

  /// تحديث حالة المفضلة
  Future<void> toggleFavorite(int productId, bool currentFavoriteStatus) async {
    try {
      log('🔄 ProductDetailsCubit: Toggling favorite for product $productId');

      final result = await toggleFavoriteUseCase(productId);

      result.fold(
        (failure) {
          log(
            '❌ ProductDetailsCubit: Failed to toggle favorite - ${failure.message}',
          );
          emit(ProductDetailsError(failure.message));
        },
        (isFavorite) {
          log(
            '✅ ProductDetailsCubit: Favorite toggled successfully to $isFavorite',
          );
          emit(ProductFavoriteUpdated(isFavorite));
        },
      );
    } catch (e) {
      log('❌ ProductDetailsCubit: Failed to toggle favorite - $e');
      emit(const ProductDetailsError('فشل تحديث المفضلة'));
    }
  }

  /// إضافة المنتج للسلة
  Future<void> addToCart({
    required int productId,
    required int quantity,
    String? selectedSize,
    List<String>? selectedAddons,
  }) async {
    try {
      log(
        '🔄 ProductDetailsCubit: Adding product $productId to cart (quantity: $quantity, size: $selectedSize)',
      );

      emit(ProductDetailsLoading());

      final params = AddToCartParams(productId: productId, quantity: quantity);

      final result = await addToCartUseCase(params);

      result.fold(
        (failure) {
          log(
            '❌ ProductDetailsCubit: Failed to add to cart - ${failure.message}',
          );
          emit(ProductAddToCartError(failure.message));
        },
        (cartItem) {
          log('✅ ProductDetailsCubit: Product added to cart successfully');
          emit(const ProductAddedToCart('تم إضافة المنتج إلى السلة بنجاح'));
        },
      );
    } catch (e) {
      log('❌ ProductDetailsCubit: Failed to add to cart - $e');
      emit(const ProductAddToCartError('حدث خطأ غير متوقع أثناء إضافة المنتج'));
    }
  }

  /// إعادة تعيين الحالة
  void resetState() {
    emit(ProductDetailsInitial());
  }
}
