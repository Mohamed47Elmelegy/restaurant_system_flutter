import 'package:equatable/equatable.dart';
import '../../domain/entitiy/address_entity.dart';

/// 🟦 AddressState - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل حالات العناوين فقط
abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية للعناوين
class AddressInitial extends AddressState {}

/// حالة تحميل العناوين
class AddressLoading extends AddressState {}

/// حالة تحميل العناوين بنجاح
class AddressLoaded extends AddressState {
  final List<AddressEntity> addresses;

  const AddressLoaded(this.addresses);

  /// Get default address if any
  AddressEntity? get defaultAddress {
    try {
      return addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return null;
    }
  }

  /// Check if addresses list is empty
  bool get isEmpty => addresses.isEmpty;

  @override
  List<Object?> get props => [addresses];
}

/// حالة العناوين فارغة
class AddressEmpty extends AddressState {}

/// حالة إضافة عنوان بنجاح
class AddressAdded extends AddressState {
  final AddressEntity address;
  final String message;

  const AddressAdded({
    required this.address,
    this.message = 'تم إضافة العنوان بنجاح',
  });

  @override
  List<Object?> get props => [address, message];
}

/// حالة تحديث عنوان بنجاح
class AddressUpdated extends AddressState {
  final AddressEntity address;
  final String message;

  const AddressUpdated({
    required this.address,
    this.message = 'تم تحديث العنوان بنجاح',
  });

  @override
  List<Object?> get props => [address, message];
}

/// حالة حذف عنوان بنجاح
class AddressDeleted extends AddressState {
  final int addressId;
  final String message;

  const AddressDeleted({
    required this.addressId,
    this.message = 'تم حذف العنوان بنجاح',
  });

  @override
  List<Object?> get props => [addressId, message];
}

/// حالة تعيين عنوان افتراضي بنجاح
class AddressSetAsDefault extends AddressState {
  final AddressEntity address;
  final String message;

  const AddressSetAsDefault({
    required this.address,
    this.message = 'تم تعيين العنوان كافتراضي',
  });

  @override
  List<Object?> get props => [address, message];
}

/// حالة خطأ في العناوين
class AddressError extends AddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object?> get props => [message];
}
