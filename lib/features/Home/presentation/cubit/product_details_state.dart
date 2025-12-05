import 'package:equatable/equatable.dart';
import '../../../../core/entities/product.dart';

/// 🟦 ProductDetailsState - حالات صفحة تفاصيل المنتج
abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object?> get props => [];
}

/// حالة ابتدائية
class ProductDetailsInitial extends ProductDetailsState {}

/// حالة تحميل
class ProductDetailsLoading extends ProductDetailsState {}

/// حالة تحميل المنتج بنجاح
class ProductDetailsLoaded extends ProductDetailsState {
  final ProductEntity product;

  const ProductDetailsLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

/// حالة خطأ
class ProductDetailsError extends ProductDetailsState {
  final String message;

  const ProductDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// حالة تحديث المفضلة
class ProductFavoriteUpdated extends ProductDetailsState {
  final bool isFavorite;

  const ProductFavoriteUpdated(this.isFavorite);

  @override
  List<Object?> get props => [isFavorite];
}

/// حالة إضافة للسلة بنجاح
class ProductAddedToCart extends ProductDetailsState {
  final String message;

  const ProductAddedToCart(this.message);

  @override
  List<Object?> get props => [message];
}

/// حالة إضافة للسلة مع خطأ
class ProductAddToCartError extends ProductDetailsState {
  final String message;

  const ProductAddToCartError(this.message);

  @override
  List<Object?> get props => [message];
}
