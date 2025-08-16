import '../../../../core/error/api_response.dart';
import '../model/address_model.dart';

/// 🟦 AddressRemoteDataSource - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن التعامل مع API الخاص بالعناوين فقط
abstract class AddressRemoteDataSource {
  /// Get all user addresses
  /// GET /api/v1/addresses
  Future<ApiResponse<List<AddressModel>>> getAddresses();

  /// Add new address
  /// POST /api/v1/addresses
  Future<ApiResponse<AddressModel>> addAddress(AddressModel request);

  /// Update existing address
  /// PUT /api/v1/addresses/{address}
  Future<ApiResponse<AddressModel>> updateAddress(
    int addressId,
    AddressModel request,
  );

  /// Delete address
  /// DELETE /api/v1/addresses/{address}
  Future<ApiResponse<bool>> deleteAddress(int addressId);

  /// Set address as default
  /// PATCH /api/v1/addresses/{address}/default
  Future<ApiResponse<AddressModel>> setDefaultAddress(int addressId);
}
