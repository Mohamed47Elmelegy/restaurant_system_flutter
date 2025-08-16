import 'package:dartz/dartz.dart';
import 'dart:developer';

import '../../../../core/error/failures.dart';
import '../../domain/entitiy/address_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_remote_data_source.dart';
import '../model/address_model.dart';

/// 🟦 AddressRepositoryImpl - تطبيق مستودع العناوين
/// يطبق مبدأ قلب الاعتماديات (DIP)
class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() async {
    try {
      log('🔄 AddressRepositoryImpl: Getting addresses');

      final response = await remoteDataSource.getAddresses();

      if (response.status) {
        final addresses = response.data!;
        log(
          '✅ AddressRepositoryImpl: Addresses loaded successfully - ${addresses.length} addresses',
        );
        return Right(addresses.cast<AddressEntity>());
      } else {
        log(
          '❌ AddressRepositoryImpl: Failed to get addresses - ${response.message}',
        );
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ AddressRepositoryImpl: Exception getting addresses - $e');
      return Left(ServerFailure(message: 'حدث خطأ أثناء تحميل العناوين'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> addAddress(
    AddressEntity address,
  ) async {
    try {
      log('🔄 AddressRepositoryImpl: Adding address');
      log('📤 Address: ${address.fullAddress}');

      // التحقق من صحة البيانات
      if (address.addressLine1.isEmpty ||
          address.city.isEmpty ||
          address.state.isEmpty) {
        log('❌ AddressRepositoryImpl: Invalid address data');
        return Left(ValidationFailure(message: 'بيانات العنوان غير صحيحة'));
      }

      final addressModel = AddressModel.fromEntity(address);
      final response = await remoteDataSource.addAddress(addressModel);

      if (response.status) {
        final addedAddress = response.data!;
        log('✅ AddressRepositoryImpl: Address added successfully');
        log('📄 Address ID: ${addedAddress.id}');
        return Right(addedAddress);
      } else {
        log(
          '❌ AddressRepositoryImpl: Failed to add address - ${response.message}',
        );
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ AddressRepositoryImpl: Exception adding address - $e');
      return Left(ServerFailure(message: 'حدث خطأ أثناء إضافة العنوان'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> updateAddress(
    AddressEntity address,
  ) async {
    try {
      log('🔄 AddressRepositoryImpl: Updating address ${address.id}');
      log('📤 Address: ${address.fullAddress}');

      final addressModel = AddressModel.fromEntity(address);
      final response = await remoteDataSource.updateAddress(
        address.id,
        addressModel,
      );

      if (response.status) {
        final updatedAddress = response.data!;
        log('✅ AddressRepositoryImpl: Address updated successfully');
        log('📄 Address ID: ${updatedAddress.id}');
        return Right(updatedAddress);
      } else {
        log(
          '❌ AddressRepositoryImpl: Failed to update address - ${response.message}',
        );
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ AddressRepositoryImpl: Exception updating address - $e');
      return Left(ServerFailure(message: 'حدث خطأ أثناء تحديث العنوان'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAddress(int addressId) async {
    try {
      log('🔄 AddressRepositoryImpl: Deleting address $addressId');

      final response = await remoteDataSource.deleteAddress(addressId);

      if (response.status) {
        log('✅ AddressRepositoryImpl: Address deleted successfully');
        return const Right(true);
      } else {
        log(
          '❌ AddressRepositoryImpl: Failed to delete address - ${response.message}',
        );
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ AddressRepositoryImpl: Exception deleting address - $e');
      return Left(ServerFailure(message: 'حدث خطأ أثناء حذف العنوان'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> setDefaultAddress(
    int addressId,
  ) async {
    try {
      log('🔄 AddressRepositoryImpl: Setting default address $addressId');

      final response = await remoteDataSource.setDefaultAddress(addressId);

      if (response.status) {
        final defaultAddress = response.data!;
        log('✅ AddressRepositoryImpl: Default address set successfully');
        log('📄 Address ID: ${defaultAddress.id}');
        return Right(defaultAddress);
      } else {
        log(
          '❌ AddressRepositoryImpl: Failed to set default address - ${response.message}',
        );
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ AddressRepositoryImpl: Exception setting default address - $e');
      return Left(
        ServerFailure(message: 'حدث خطأ أثناء تعيين العنوان الافتراضي'),
      );
    }
  }
}
