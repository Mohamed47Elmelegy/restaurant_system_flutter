import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entitiy/address_entity.dart';

/// 🟦 AddressRepository - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحديد عمليات العناوين فقط
///
/// 🟦 مبدأ الفتح والإغلاق (OCP)
/// يمكن إضافة repositories جديدة بدون تعديل AddressRepository
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstraction وليس implementation
abstract class AddressRepository {
  /// Get all user addresses
  /// GET /api/v1/addresses
  Future<Either<Failure, List<AddressEntity>>> getAddresses();

  /// Add new address
  /// POST /api/v1/addresses
  Future<Either<Failure, AddressEntity>> addAddress(AddressEntity address);

  /// Update existing address
  /// PUT /api/v1/addresses/{address}
  Future<Either<Failure, AddressEntity>> updateAddress(AddressEntity address);

  /// Delete address
  /// DELETE /api/v1/addresses/{address}
  Future<Either<Failure, bool>> deleteAddress(int addressId);

  /// Set address as default
  Future<Either<Failure, AddressEntity>> setDefaultAddress(int addressId);
}
