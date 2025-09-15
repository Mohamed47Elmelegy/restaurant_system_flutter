import '../../features/address/presentation/cubit/address_cubit.dart';
import '../../features/address/presentation/cubit/address_event.dart';
import '../../features/address/presentation/cubit/address_state.dart';
import '../../features/cart/presentation/bloc/cart_cubit.dart';
import '../../features/cart/presentation/bloc/cart_event.dart';
import '../../features/cart/presentation/bloc/cart_state.dart';
import '../di/service_locator.dart';

/// Helper class to safely initialize cubits
class CubitInitializer {
  /// Safely get AddressCubit and load addresses if not already loaded
  static AddressCubit getAddressCubitWithData() {
    final cubit = getIt<AddressCubit>();

    // Only load addresses if cubit is not closed and not already loading/loaded
    if (!cubit.isClosed && cubit.state is! AddressLoading) {
      // Check if we need to load addresses
      final currentState = cubit.state;
      if (currentState is AddressInitial ||
          currentState is AddressError ||
          (currentState is AddressLoaded && currentState.addresses.isEmpty)) {
        cubit.add(LoadAddresses());
      }
    }

    return cubit;
  }

  /// Safely get CartCubit and load cart if not already loaded
  static CartCubit getCartCubitWithData() {
    final cubit = getIt<CartCubit>();

    // Only load cart if cubit is not closed and not already loading/loaded
    if (!cubit.isClosed && cubit.state is! CartLoading) {
      // Check if we need to load cart
      final currentState = cubit.state;
      if (currentState is CartInitial ||
          currentState is CartError ||
          (currentState is CartLoaded && currentState.cart.items.isEmpty)) {
        cubit.add(LoadCart());
      }
    }

    return cubit;
  }
}
