import 'package:equatable/equatable.dart';
import '../../domain/entitiy/address_entity.dart';

/// 🟦 AddressEvent - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل أحداث العناوين فقط
abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

/// حدث تحميل العناوين
class LoadAddresses extends AddressEvent {}

/// حدث إضافة عنوان جديد
class AddAddress extends AddressEvent {
  final AddressEntity address;

  const AddAddress({required this.address});

  @override
  List<Object?> get props => [address];
}

/// حدث تحديث عنوان موجود
class UpdateAddress extends AddressEvent {
  final AddressEntity address;

  const UpdateAddress({required this.address});

  @override
  List<Object?> get props => [address];
}

/// حدث حذف عنوان
class DeleteAddress extends AddressEvent {
  final int addressId;

  const DeleteAddress({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

/// حدث تعيين عنوان كافتراضي
class SetDefaultAddress extends AddressEvent {
  final int addressId;

  const SetDefaultAddress({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

/// حدث إعادة تحميل العناوين
class RefreshAddresses extends AddressEvent {}

/// حدث إعادة تعيين حالة العناوين
class ResetAddressState extends AddressEvent {}
