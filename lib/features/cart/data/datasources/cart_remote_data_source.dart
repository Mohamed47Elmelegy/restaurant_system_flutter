import '../../../../core/error/api_response.dart';
import '../models/add_to_cart_request.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';
import '../models/update_cart_item_request.dart';

/// 🟦 CartRemoteDataSource - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن التعامل مع API الخاص بالسلة فقط
abstract class CartRemoteDataSource {
  /// Get cart contents
  /// GET /api/v1/cart
  Future<ApiResponse<CartModel>> getCart();

  /// Add item to cart
  /// POST /api/v1/cart
  Future<ApiResponse<CartItemModel>> addToCart(AddToCartRequest request);

  /// Update cart item quantity
  /// PUT /api/v1/cart/items/{cartItem}
  Future<ApiResponse<CartItemModel>> updateCartItem(
    int cartItemId,
    UpdateCartItemRequest request,
  );

  /// Remove item from cart
  /// DELETE /api/v1/cart/items/{cartItem}
  Future<ApiResponse<bool>> removeCartItem(int cartItemId);

  /// Clear entire cart
  /// DELETE /api/v1/cart/clear
  Future<ApiResponse<bool>> clearCart();
}
