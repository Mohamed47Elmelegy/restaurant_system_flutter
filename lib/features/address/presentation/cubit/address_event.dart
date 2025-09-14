import 'package:equatable/equatable.dart';
import '../../domain/entitiy/address_entity.dart';

/// AddressEvent - Single Responsibility Principle (SRP)
/// Responsible for representing address events only
abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

/// Load addresses event
class LoadAddresses extends AddressEvent {}

/// Add new address event
class AddAddress extends AddressEvent {
  final AddressEntity address;

  const AddAddress({required this.address});

  @override
  List<Object?> get props => [address];
}

/// Update existing address event
class UpdateAddress extends AddressEvent {
  final AddressEntity address;

  const UpdateAddress({required this.address});

  @override
  List<Object?> get props => [address];
}

/// Delete address event
class DeleteAddress extends AddressEvent {
  final int addressId;

  const DeleteAddress({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

/// Set default address event
class SetDefaultAddress extends AddressEvent {
  final int addressId;

  const SetDefaultAddress({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

/// Refresh addresses event
class RefreshAddresses extends AddressEvent {}

/// Reset address state event
class ResetAddressState extends AddressEvent {}
