import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/error/api_response.dart';
import '../../../../core/network/api_path.dart';
import '../models/add_to_cart_request.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';
import '../models/update_cart_item_request.dart';
import 'cart_remote_data_source.dart';

/// 🟦 CartRemoteDataSourceImpl - تطبيق مصدر البيانات البعيد للسلة
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio dio;

  CartRemoteDataSourceImpl(this.dio);

  @override
  Future<ApiResponse<CartModel>> getCart() async {
    try {
      log('🔄 CartRemoteDataSourceImpl: Getting cart contents');

      final response = await dio.get(ApiPath.cart());

      log('✅ CartRemoteDataSourceImpl: Cart loaded successfully');
      log('📄 Response data: ${response.data}');

      final cartData = response.data['data'];
      final cart = CartModel.fromJson(cartData);

      return ApiResponse.success(cart);
    } on DioException catch (e) {
      log('❌ CartRemoteDataSourceImpl: Failed to get cart - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ CartRemoteDataSourceImpl: Failed to get cart - $e');
      return ApiResponse.error('Failed to get cart: $e');
    }
  }

  @override
  Future<ApiResponse<CartItemModel>> addToCart(AddToCartRequest request) async {
    try {
      log('🔄 CartRemoteDataSourceImpl: Adding item to cart');
      log('📤 Request data: ${request.toJson()}');

      final response = await dio.post(ApiPath.cart(), data: request.toJson());

      log('✅ CartRemoteDataSourceImpl: Item added to cart successfully');
      log('📄 Response data: ${response.data}');

      final cartItemData = response.data['data'];
      final cartItem = CartItemModel.fromJson(cartItemData);

      return ApiResponse.success(cartItem);
    } on DioException catch (e) {
      log('❌ CartRemoteDataSourceImpl: Failed to add item to cart - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ CartRemoteDataSourceImpl: Failed to add item to cart - $e');
      return ApiResponse.error('Failed to add item to cart: $e');
    }
  }

  @override
  Future<ApiResponse<CartItemModel>> updateCartItem(
    int cartItemId,
    UpdateCartItemRequest request,
  ) async {
    try {
      log('🔄 CartRemoteDataSourceImpl: Updating cart item $cartItemId');
      log('📤 Request data: ${request.toJson()}');

      final response = await dio.put(
        ApiPath.cartItems(cartItemId),
        data: request.toJson(),
      );

      log('✅ CartRemoteDataSourceImpl: Cart item updated successfully');
      log('📄 Response data: ${response.data}');

      final cartItemData = response.data['data'];
      final cartItem = CartItemModel.fromJson(cartItemData);

      return ApiResponse.success(cartItem);
    } on DioException catch (e) {
      log('❌ CartRemoteDataSourceImpl: Failed to update cart item - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ CartRemoteDataSourceImpl: Failed to update cart item - $e');
      return ApiResponse.error('Failed to update cart item: $e');
    }
  }

  @override
  Future<ApiResponse<bool>> removeCartItem(int cartItemId) async {
    try {
      log('🔄 CartRemoteDataSourceImpl: Removing cart item $cartItemId');

      final response = await dio.delete(ApiPath.cartItems(cartItemId));

      log('✅ CartRemoteDataSourceImpl: Cart item removed successfully');
      log('📄 Response data: ${response.data}');

      return ApiResponse.success(true);
    } on DioException catch (e) {
      log('❌ CartRemoteDataSourceImpl: Failed to remove cart item - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ CartRemoteDataSourceImpl: Failed to remove cart item - $e');
      return ApiResponse.error('Failed to remove cart item: $e');
    }
  }

  @override
  Future<ApiResponse<bool>> clearCart() async {
    try {
      log('🔄 CartRemoteDataSourceImpl: Clearing cart');

      final response = await dio.delete(ApiPath.cartClear());

      log('✅ CartRemoteDataSourceImpl: Cart cleared successfully');
      log('📄 Response data: ${response.data}');

      return ApiResponse.success(true);
    } on DioException catch (e) {
      log('❌ CartRemoteDataSourceImpl: Failed to clear cart - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ CartRemoteDataSourceImpl: Failed to clear cart - $e');
      return ApiResponse.error('Failed to clear cart: $e');
    }
  }
}
