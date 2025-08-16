import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

import '../../domain/usecases/add_address_usecase.dart';
import '../../domain/usecases/delete_address_usecase.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/set_default_address_usecase.dart';
import '../../domain/usecases/update_address_usecase.dart';
import 'address_event.dart';
import 'address_state.dart';

/// 🟦 AddressCubit - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إدارة حالة العناوين فقط
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions (use cases) وليس implementations
class AddressCubit extends Bloc<AddressEvent, AddressState> {
  final GetAddressesUseCase getAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final SetDefaultAddressUseCase setDefaultAddressUseCase;

  AddressCubit(param0, {
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

  /// تحميل العناوين
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
      emit(const AddressError('حدث خطأ غير متوقع أثناء تحميل العناوين'));
    }
  }

  /// إضافة عنوان جديد
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
          // إعادة تحميل العناوين لعرض التحديثات
          add(LoadAddresses());
        },
      );
    } catch (e) {
      log('❌ AddressCubit: Failed to add address - $e');
      emit(const AddressError('حدث خطأ غير متوقع أثناء إضافة العنوان'));
    }
  }

  /// تحديث عنوان موجود
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
          // إعادة تحميل العناوين لعرض التحديثات
          add(LoadAddresses());
        },
      );
    } catch (e) {
      log('❌ AddressCubit: Failed to update address - $e');
      emit(const AddressError('حدث خطأ غير متوقع أثناء تحديث العنوان'));
    }
  }

  /// حذف عنوان
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
          // إعادة تحميل العناوين لعرض التحديثات
          add(LoadAddresses());
        },
      );
    } catch (e) {
      log('❌ AddressCubit: Failed to delete address - $e');
      emit(const AddressError('حدث خطأ غير متوقع أثناء حذف العنوان'));
    }
  }

  /// تعيين عنوان كافتراضي
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
          // إعادة تحميل العناوين لعرض التحديثات
          add(LoadAddresses());
        },
      );
    } catch (e) {
      log('❌ AddressCubit: Failed to set default address - $e');
      emit(
        const AddressError('حدث خطأ غير متوقع أثناء تعيين العنوان الافتراضي'),
      );
    }
  }

  /// إعادة تحميل العناوين
  Future<void> _onRefreshAddresses(
    RefreshAddresses event,
    Emitter<AddressState> emit,
  ) async {
    add(LoadAddresses());
  }

  /// إعادة تعيين حالة العناوين
  Future<void> _onResetAddressState(
    ResetAddressState event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressInitial());
  }
}
