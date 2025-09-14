import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entitiy/address_entity.dart';
import '../repositories/address_repository.dart';

class SetDefaultAddressUseCase {
  final AddressRepository repository;

  SetDefaultAddressUseCase({required this.repository});

  Future<Either<Failure, AddressEntity>> call(
    SetDefaultAddressParams params,
  ) async {
    return await repository.setDefaultAddress(params.addressId);
  }
}

class SetDefaultAddressParams {
  final int addressId;

  SetDefaultAddressParams({required this.addressId});
}
