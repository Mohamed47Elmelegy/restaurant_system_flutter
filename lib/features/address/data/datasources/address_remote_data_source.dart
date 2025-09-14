import '../../../../core/error/api_response.dart';
import '../model/address_model.dart';

/// AddressRemoteDataSource - Single Responsibility Principle (SRP)
/// Responsible for handling address API operations only
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
  /// PUT /api/v1/addresses/{address}
  Future<ApiResponse<AddressModel>> setDefaultAddress(int addressId);
}
