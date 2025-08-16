import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/address_repository.dart';

/// 🟦 DeleteAddressUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن حذف عنوان فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class DeleteAddressUseCase extends BaseUseCase<bool, DeleteAddressParams> {
  final AddressRepository repository;

  DeleteAddressUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(DeleteAddressParams params) async {
    return await repository.deleteAddress(params.addressId);
  }
}

/// 🟦 DeleteAddressParams - معايير حذف عنوان
class DeleteAddressParams extends Equatable {
  final int addressId;

  const DeleteAddressParams({required this.addressId});

  @override
  List<Object?> get props => [addressId];

  @override
  String toString() {
    return 'DeleteAddressParams(addressId: $addressId)';
  }
}
