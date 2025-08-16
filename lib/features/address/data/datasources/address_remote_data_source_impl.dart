import 'package:dio/dio.dart';
import 'dart:developer';

import '../../../../core/error/api_response.dart';
import '../../../../core/network/api_path.dart';
import '../model/address_model.dart';
import 'address_remote_data_source.dart';

/// 🟦 AddressRemoteDataSourceImpl - تطبيق مصدر البيانات البعيد للعناوين
/// يطبق مبدأ قلب الاعتماديات (DIP)
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
  Future<ApiResponse<AddressModel>> addAddress(
    AddressModel request,
  ) async {
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

      // Using PUT request to update the address with is_default: true
      final response = await dio.put(
        ApiPath.addressUD(addressId),
        data: {'is_default': true},
      );

      log('✅ AddressRemoteDataSourceImpl: Default address set successfully');
      log('📄 Response data: ${response.data}');

      final addressData = response.data['data'];
      final address = AddressModel.fromJson(addressData);

      return ApiResponse.success(address);
    } on DioException catch (e) {
      log('❌ AddressRemoteDataSourceImpl: Failed to set default address - $e');
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log('❌ AddressRemoteDataSourceImpl: Failed to set default address - $e');
      return ApiResponse.error('Failed to set default address: $e');
    }
  }
}
