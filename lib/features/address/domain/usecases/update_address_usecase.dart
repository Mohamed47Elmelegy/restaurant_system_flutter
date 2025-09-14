import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entitiy/address_entity.dart';
import '../repositories/address_repository.dart';

/// 🟦 UpdateAddressUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحديث عنوان موجود فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class UpdateAddressUseCase
    extends BaseUseCase<AddressEntity, UpdateAddressParams> {
  final AddressRepository repository;

  UpdateAddressUseCase({required this.repository});

  @override
  Future<Either<Failure, AddressEntity>> call(
    UpdateAddressParams params,
  ) async {
    return repository.updateAddress(params.address);
  }
}

/// 🟦 UpdateAddressParams - معايير تحديث عنوان
class UpdateAddressParams extends Equatable {
  final AddressEntity address;

  const UpdateAddressParams({required this.address});

  @override
  List<Object?> get props => [address];

  @override
  String toString() {
    return 'UpdateAddressParams(address: ${address.fullAddress})';
  }
}
