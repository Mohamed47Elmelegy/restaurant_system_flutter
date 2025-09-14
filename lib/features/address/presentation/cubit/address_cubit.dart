import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_address_usecase.dart';
import '../../domain/usecases/delete_address_usecase.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/set_default_address_usecase.dart';
import '../../domain/usecases/update_address_usecase.dart';
import 'address_event.dart';
import 'address_state.dart';

/// AddressCubit - Single Responsibility Principle (SRP)
/// Responsible for managing address state only
///
/// Dependency Inversion Principle (DIP)
/// Depends on abstractions (use cases) not implementations
class AddressCubit extends Bloc<AddressEvent, AddressState> {
  final GetAddressesUseCase getAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final SetDefaultAddressUseCase setDefaultAddressUseCase;

  AddressCubit({
    required this.getAddressesUseCase,
    required this.addAddressUseCase,
    required this.updateAddressUseCase,
    required this.deleteAddressUseCase,
    required this.setDefaultAddressUseCase,
  }) : super(AddressInitial()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<AddAddress>(_onAddAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<SetDefaultAddress>(_onSetDefaultAddress);
    on<RefreshAddresses>(_onRefreshAddresses);
    on<ResetAddressState>(_onResetAddressState);
  }

  /// Load addresses
  Future<void> _onLoadAddresses(
    LoadAddresses event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      log('🔄 AddressCubit: Loading addresses...');

      final result = await getAddressesUseCase();

      result.fold(
        (failure) {
          log('❌ AddressCubit: Failed to load addresses - $failure');
          emit(AddressError(failure.message));
        },
        (addresses) {
          log(
            '✅ AddressCubit: Addresses loaded successfully - ${addresses.length} addresses',
          );
          if (addresses.isEmpty) {
            emit(AddressEmpty());
          } else {
            emit(AddressLoaded(addresses));
          }
        },
      );
    } catch (e) {
      log('❌ AddressCubit: Failed to load addresses - $e');
      emit(
        const AddressError(
          'An unexpected error occurred while loading addresses',
        ),
      );
    }
  }

  /// Add new address
  Future<void> _onAddAddress(
    AddAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      log('🔄 AddressCubit: Adding address');
      log('📤 Address: ${event.address.fullAddress}');

      final params = AddAddressParams(address: event.address);
      final result = await addAddressUseCase(params);

      result.fold(
        (failure) {
          log('❌ AddressCubit: Failed to add address - $failure');
          emit(AddressError(failure.message));
        },
        (address) {
          log('✅ AddressCubit: Address added successfully');
          emit(AddressAdded(address: address));
          // Reload addresses to show updates
          if (!isClosed) {
            add(LoadAddresses());
          }
        },
      );
    } catch (e) {
      log('❌ AddressCubit: Failed to add address - $e');
      emit(
        const AddressError('An unexpected error occurred while adding address'),
      );
    }
  }

  /// Update existing address
  Future<void> _onUpdateAddress(
    UpdateAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      log('🔄 AddressCubit: Updating address ${event.address.id}');
      log('📤 Address: ${event.address.fullAddress}');

      final params = UpdateAddressParams(address: event.address);
      final result = await updateAddressUseCase(params);

      result.fold(
        (failure) {
          log('❌ AddressCubit: Failed to update address - $failure');
          emit(AddressError(failure.message));
        },
        (address) {
          log('✅ AddressCubit: Address updated successfully');
          emit(AddressUpdated(address: address));
          // Reload addresses to show updates
          if (!isClosed) {
            add(LoadAddresses());
          }
        },
      );
    } catch (e) {
      log('❌ AddressCubit: Failed to update address - $e');
      emit(
        const AddressError(
          'An unexpected error occurred while updating address',
        ),
      );
    }
  }

  /// Delete address
  Future<void> _onDeleteAddress(
    DeleteAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      log('🔄 AddressCubit: Deleting address ${event.addressId}');

      final params = DeleteAddressParams(addressId: event.addressId);
      final result = await deleteAddressUseCase(params);

      result.fold(
        (failure) {
          log('❌ AddressCubit: Failed to delete address - $failure');
          emit(AddressError(failure.message));
        },
        (success) {
          log('✅ AddressCubit: Address deleted successfully');
          emit(AddressDeleted(addressId: event.addressId));
          // Reload addresses to show updates
          if (!isClosed) {
            add(LoadAddresses());
          }
        },
      );
    } catch (e) {
      log('❌ AddressCubit: Failed to delete address - $e');
      emit(
        const AddressError(
          'An unexpected error occurred while deleting address',
        ),
      );
    }
  }

  /// Set address as default
  Future<void> _onSetDefaultAddress(
    SetDefaultAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      log('🔄 AddressCubit: Setting default address ${event.addressId}');

      final params = SetDefaultAddressParams(addressId: event.addressId);
      final result = await setDefaultAddressUseCase(params);

      result.fold(
        (failure) {
          log('❌ AddressCubit: Failed to set default address - $failure');
          emit(AddressError(failure.message));
        },
        (address) {
          log('✅ AddressCubit: Default address set successfully');
          emit(AddressSetAsDefault(address: address));
          // Reload addresses to show updates
          if (!isClosed) {
            add(LoadAddresses());
          }
        },
      );
    } catch (e) {
      log('❌ AddressCubit: Failed to set default address - $e');
      emit(
        const AddressError(
          'An unexpected error occurred while setting default address',
        ),
      );
    }
  }

  /// Refresh addresses
  Future<void> _onRefreshAddresses(
    RefreshAddresses event,
    Emitter<AddressState> emit,
  ) async {
    add(LoadAddresses());
  }

  /// Reset address state
  Future<void> _onResetAddressState(
    ResetAddressState event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressInitial());
  }
}
