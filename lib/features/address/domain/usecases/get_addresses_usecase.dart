import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entitiy/address_entity.dart';
import '../repositories/address_repository.dart';

/// 🟦 GetAddressesUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن جلب عناوين المستخدم فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class GetAddressesUseCase extends BaseUseCaseNoParams<List<AddressEntity>> {
  final AddressRepository repository;

  GetAddressesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<AddressEntity>>> call() async {
    return await repository.getAddresses();
  }
}
