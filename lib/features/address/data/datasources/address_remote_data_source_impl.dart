import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/error/api_response.dart';
import '../../../../core/network/api_path.dart';
import '../model/address_model.dart';
import 'address_remote_data_source.dart';

/// AddressRemoteDataSourceImpl - Implementation of remote data source for addresses
/// Implements Dependency Inversion Principle (DIP)
class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final Dio dio;

  AddressRemoteDataSourceImpl({required this.dio});

  @override
  Future<ApiResponse<List<AddressModel>>> getAddresses() async {
    try {
      log('🔄 AddressRemoteDataSourceImpl: Getting addresses');

      final response = await dio.get(ApiPath.addresses());

      log('✅ AddressRemoteDataSourceImpl: Addresses retrieved successfully');
      log('📄 Response data: ${response.data}');

      final List<dynamic> addressesData = response.data['data'] ?? [];
      final addresses = addressesData
          .map((addressJson) => AddressModel.fromJson(addressJson))
          .toList();

      return ApiResponse.success(addresses);
    } on DioException catch (e) {
      log('❌ AddressRemoteDataSourceImpl: Failed to get addresses - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ AddressRemoteDataSourceImpl: Failed to get addresses - $e');
      return ApiResponse.error('Failed to get addresses: $e');
    }
  }

  @override
  Future<ApiResponse<AddressModel>> addAddress(AddressModel request) async {
    try {
      log('🔄 AddressRemoteDataSourceImpl: Adding address');
      log('📤 Request data: ${request.toJson()}');

      final response = await dio.post(
        ApiPath.addresses(),
        data: request.toJson(),
      );

      log('✅ AddressRemoteDataSourceImpl: Address added successfully');
      log('📄 Response data: ${response.data}');

      final addressData = response.data['data'];
      final address = AddressModel.fromJson(addressData);

      return ApiResponse.success(address);
    } on DioException catch (e) {
      log('❌ AddressRemoteDataSourceImpl: Failed to add address - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ AddressRemoteDataSourceImpl: Failed to add address - $e');
      return ApiResponse.error('Failed to add address: $e');
    }
  }

  @override
  Future<ApiResponse<AddressModel>> updateAddress(
    int addressId,
    AddressModel request,
  ) async {
    try {
      log('🔄 AddressRemoteDataSourceImpl: Updating address $addressId');
      log('📤 Request data: ${request.toJson()}');

      final response = await dio.put(
        ApiPath.addressUD(addressId),
        data: request.toJson(),
      );

      log('✅ AddressRemoteDataSourceImpl: Address updated successfully');
      log('📄 Response data: ${response.data}');

      final addressData = response.data['data'];
      final address = AddressModel.fromJson(addressData);

      return ApiResponse.success(address);
    } on DioException catch (e) {
      log('❌ AddressRemoteDataSourceImpl: Failed to update address - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ AddressRemoteDataSourceImpl: Failed to update address - $e');
      return ApiResponse.error('Failed to update address: $e');
    }
  }

  @override
  Future<ApiResponse<bool>> deleteAddress(int addressId) async {
    try {
      log('🔄 AddressRemoteDataSourceImpl: Deleting address $addressId');

      final response = await dio.delete(ApiPath.addressUD(addressId));

      log('✅ AddressRemoteDataSourceImpl: Address deleted successfully');
      log('📄 Response data: ${response.data}');

      return ApiResponse.success(true);
    } on DioException catch (e) {
      log('❌ AddressRemoteDataSourceImpl: Failed to delete address - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ AddressRemoteDataSourceImpl: Failed to delete address - $e');
      return ApiResponse.error('Failed to delete address: $e');
    }
  }

  @override
  Future<ApiResponse<AddressModel>> setDefaultAddress(int addressId) async {
    try {
      log('🔄 AddressRemoteDataSourceImpl: Setting default address $addressId');

      // Using PATCH request with the new set-default endpoint
      final response = await dio.patch(ApiPath.addressSetDefault(addressId));

      log('✅ AddressRemoteDataSourceImpl: Default address set successfully');
      log('📄 Response data: ${response.data}');

      // Check if response contains address data
      final addressData = response.data['data'];
      if (addressData != null && addressData is Map<String, dynamic>) {
        // API returned the updated address
        final address = AddressModel.fromJson(addressData);
        return ApiResponse.success(address);
      } else {
        // API only returned success message without address data
        // This is common for set default operations
        // Return a minimal address model indicating success
        log(
          'ℹ️ AddressRemoteDataSourceImpl: API returned success without address data, creating placeholder',
        );

        final address = AddressModel(
          id: addressId,
          userId: 0, // Will be updated when addresses are reloaded
          name: 'Updated Address',
          city: '',
          phoneNumber: '',
          address: '',
          building: null,
          apartment: null,
          isDefault: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return ApiResponse.success(address);
      }
    } on DioException catch (e) {
      log('❌ AddressRemoteDataSourceImpl: Failed to set default address - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ AddressRemoteDataSourceImpl: Failed to set default address - $e');
      return ApiResponse.error('Failed to set default address: $e');
    }
  }
}
