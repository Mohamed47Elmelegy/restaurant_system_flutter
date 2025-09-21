import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/cart/domain/entities/cart_item_entity.dart';
import '../../features/cart/presentation/bloc/cart_cubit.dart';
import '../../features/cart/presentation/bloc/cubit/cart_item_cubit.dart';
import '../theme/theme_helper.dart';

class AddRemoveItem extends StatelessWidget {
  const AddRemoveItem({super.key, required this.cartItemEntity});
  final CartItemEntity cartItemEntity;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: GestureDetector(
            onTap: () {
              cartItemEntity.isValidQuantity;
              context.read<CartItemCubit>().updateCartItem(cartItemEntity);
            },
            child: Container(
              height: 30.h,
              width: 30.w,
              decoration: ShapeDecoration(
                color: ThemeHelper.getPrimaryColorForTheme(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
              child: Center(
                child: Icon(Icons.add, color: Colors.white, size: 16.sp),
              ),
            ),
          ),
        ),
        Text(cartItemEntity.totalPrice.toString()),
        ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: GestureDetector(
            onTap: () {
              cartItemEntity.isValidQuantity;
              if (cartItemEntity.quantity == 0) {
                context.read<CartCubit>().removeCartItemUseCase;
              } else {
                context.read<CartItemCubit>().updateCartItem(cartItemEntity);
              }
            },
            child: Container(
              height: 30.h,
              width: 30.w,
              decoration: ShapeDecoration(
                color: ThemeHelper.getSecondaryColorForTheme(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.remove,
                  color: ThemeHelper.getSecondaryColorForTheme(context),
                  size: 16.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
