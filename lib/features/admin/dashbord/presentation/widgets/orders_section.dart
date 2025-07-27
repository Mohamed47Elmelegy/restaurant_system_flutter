import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/theme/theme_helper.dart';
import '../../../../orders/data/repositories/order_repository_impl.dart';
import '../../../../orders/domain/usecases/get_running_orders_usecase.dart';
import '../../../../orders/domain/usecases/mark_order_done_usecase.dart';
import '../../../../orders/domain/usecases/cancel_order_usecase.dart';
import '../../../../orders/presentation/bloc/order_bloc.dart';
import '../../../../orders/presentation/bloc/order_event.dart';
import '../../../../orders/presentation/widgets/orders_bottom_sheet.dart';

class OrdersSection extends StatelessWidget {
  final String title;
  final int orderCount;

  const OrdersSection({
    super.key,
    required this.title,
    required this.orderCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showOrdersBottomSheet(context);
      },
      child: Container(
        width: 157.w,
        height: 115.h,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: ThemeHelper.getCardShadow(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$orderCount', style: AppTextStyles.senBold52(context)),
            Text(
              title,
              style: AppTextStyles.senBold14(context).copyWith(
                fontSize: 13.sp,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrdersBottomSheet(BuildContext context) {
    final orderType = title.toLowerCase().contains('active')
        ? 'running'
        : 'new';
    final bottomSheetTitle = title.trim();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) =>
            OrderBloc(
              getRunningOrdersUseCase: GetRunningOrdersUseCase(
                OrderRepositoryImpl(),
              ),
              markOrderDoneUseCase: MarkOrderDoneUseCase(OrderRepositoryImpl()),
              cancelOrderUseCase: CancelOrderUseCase(OrderRepositoryImpl()),
            )..add(
              orderType == 'running'
                  ? const LoadRunningOrders()
                  : const LoadNewOrders(),
            ),
        child: OrdersBottomSheet(title: bottomSheetTitle, orderType: orderType),
      ),
    );
  }
}
