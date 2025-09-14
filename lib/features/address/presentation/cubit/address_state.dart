import 'package:equatable/equatable.dart';
import '../../domain/entitiy/address_entity.dart';

/// AddressState - Single Responsibility Principle (SRP)
/// Responsible for representing address states only
abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

/// Initial address state
class AddressInitial extends AddressState {}

/// Loading addresses state
class AddressLoading extends AddressState {}

/// Addresses loaded successfully state
class AddressLoaded extends AddressState {
  final List<AddressEntity> addresses;

  const AddressLoaded(this.addresses);

  /// Check if addresses list is empty
  bool get isEmpty => addresses.isEmpty;

  @override
  List<Object?> get props => [addresses];
}

/// Empty addresses state
class AddressEmpty extends AddressState {}

/// Address added successfully state
class AddressAdded extends AddressState {
  final AddressEntity address;
  final String message;

  const AddressAdded({
    required this.address,
    this.message = 'Address added successfully',
  });

  @override
  List<Object?> get props => [address, message];
}

/// Address updated successfully state
class AddressUpdated extends AddressState {
  final AddressEntity address;
  final String message;

  const AddressUpdated({
    required this.address,
    this.message = 'Address updated successfully',
  });

  @override
  List<Object?> get props => [address, message];
}

/// Address deleted successfully state
class AddressDeleted extends AddressState {
  final int addressId;
  final String message;

  const AddressDeleted({
    required this.addressId,
    this.message = 'Address deleted successfully',
  });

  @override
  List<Object?> get props => [addressId, message];
}

/// Address set as default successfully state
class AddressSetAsDefault extends AddressState {
  final AddressEntity address;
  final String message;

  const AddressSetAsDefault({
    required this.address,
    this.message = 'Address set as default successfully',
  });

  @override
  List<Object?> get props => [address, message];
}

/// Address error state
class AddressError extends AddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object?> get props => [message];
}
