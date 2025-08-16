// ================= ASSUMPTIONS =================
// - يوجد PlaceOrderCubit و BlocProvider متاحين في الشجرة.
// - يوجد usecase/repo/datasource متكاملين لفلو PlaceOrder.
// - يوجد صفحة ThankYouPage تستقبل orderId و qrCode.
// - cart.items يحتوي على menuItemId و quantity.
// - نوع الطلب (dine-in/delivery) و tableId/deliveryAddress يتم تحديدهم هنا بشكل افتراضي (يمكن ربطهم بالـ UI لاحقاً).
// =================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../address/presentation/cubit/address_cubit.dart';
import '../../../address/domain/usecases/get_addresses_usecase.dart';
import '../../../address/domain/usecases/add_address_usecase.dart';
import '../../../address/domain/usecases/update_address_usecase.dart';
import '../../../address/domain/usecases/delete_address_usecase.dart';
import '../../../address/domain/usecases/set_default_address_usecase.dart';
import '../../../../core/di/service_locator.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/domain/repositories/table_repository.dart';
import '../../../orders/presentation/cubit/table_cubit.dart';
import '../../domain/usecases/check_out_place_order_usecase.dart';
import '../cubit/check_out_cubit.dart';
import '../widgets/checkout_body.dart';

class CheckoutPage extends StatelessWidget {
  final CartEntity cart;
  final OrderType orderType;
  final int? tableId;

  const CheckoutPage({
    super.key,
    required this.cart,
    required this.orderType,
    this.tableId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TableCubit>(
      create: (context) =>
          TableCubit(getIt<TableRepository>()), // تأكد من ربط TableRepository في getIt
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CheckOutCubit>(
            create: (context) =>
                CheckOutCubit(getIt<CheckOutPlaceOrderUseCase>()),
          ),
          BlocProvider<AddressCubit>(
            create: (context) => AddressCubit(
              getIt<GetAddressesUseCase>(),
              getAddressesUseCase: getIt<GetAddressesUseCase>(),
              addAddressUseCase: getIt<AddAddressUseCase>(),
              updateAddressUseCase: getIt<UpdateAddressUseCase>(),
              deleteAddressUseCase: getIt<DeleteAddressUseCase>(),
              setDefaultAddressUseCase: getIt<SetDefaultAddressUseCase>(),
            ),
          ),
        ],
        child: CheckoutBody(cart: cart, orderType: orderType, tableId: tableId),
      ),
    );
  }
}
