import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entitiy/address_entity.dart';
import '../repositories/address_repository.dart';

/// 🟦 SetDefaultAddressUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تعيين عنوان كافتراضي فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class SetDefaultAddressUseCase
    extends BaseUseCase<AddressEntity, SetDefaultAddressParams> {
  final AddressRepository repository;

  SetDefaultAddressUseCase({required this.repository});

  @override
  Future<Either<Failure, AddressEntity>> call(
    SetDefaultAddressParams params,
  ) async {
    return await repository.setDefaultAddress(params.addressId);
  }
}

/// 🟦 SetDefaultAddressParams - معايير تعيين عنوان افتراضي
class SetDefaultAddressParams extends Equatable {
  final int addressId;

  const SetDefaultAddressParams({required this.addressId});

  @override
  List<Object?> get props => [addressId];

  @override
  String toString() {
    return 'SetDefaultAddressParams(addressId: $addressId)';
  }
}
