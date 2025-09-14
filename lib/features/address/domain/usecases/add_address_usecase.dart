import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entitiy/address_entity.dart';
import '../repositories/address_repository.dart';

/// 🟦 AddAddressUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إضافة عنوان جديد فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class AddAddressUseCase extends BaseUseCase<AddressEntity, AddAddressParams> {
  final AddressRepository repository;

  AddAddressUseCase({required this.repository});

  @override
  Future<Either<Failure, AddressEntity>> call(AddAddressParams params) async {
    return repository.addAddress(params.address);
  }
}

/// 🟦 AddAddressParams - معايير إضافة عنوان
class AddAddressParams extends Equatable {
  final AddressEntity address;

  const AddAddressParams({required this.address});

  @override
  List<Object?> get props => [address];

  @override
  String toString() {
    return 'AddAddressParams(address: ${address.fullAddress})';
  }
}
