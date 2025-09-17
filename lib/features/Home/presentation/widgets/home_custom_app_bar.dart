import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/bloc/cart_state.dart';

class HomeCustomAppBar extends StatelessWidget {
  const HomeCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        // Calculate cart item count from cart state
        int cartItemCount = 0;
        if (cartState is CartLoaded) {
          cartItemCount = cartState.cart.uniqueItemsCount;
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: ThemeHelper.getSurfaceColor(context),
          ),
          child: Row(
            children: [
              // App Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً بك',
                      style: AppTextStyles.senRegular14(context).copyWith(
                        color: ThemeHelper.getSecondaryTextColor(context),
                      ),
                    ),
                    Text(
                      'اختر طعامك المفضل',
                      style: AppTextStyles.senBold18(context).copyWith(
                        color: ThemeHelper.getPrimaryTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),

              // Cart Icon with Badge
              Stack(
                children: [
                  IconButton(
                    onPressed: () => _handleCartPressed(context),
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: ThemeHelper.getPrimaryTextColor(context),
                      size: 24.sp,
                    ),
                  ),
                  if (cartItemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: AppColors.lightPrimary,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16.w,
                          minHeight: 16.h,
                        ),
                        child: Text(
                          cartItemCount.toString(),
                          style: AppTextStyles.senBold10(
                            context,
                          ).copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleCartPressed(BuildContext context) {
    // Navigate to cart page using named route
    Navigator.of(context).pushNamed(AppRoutes.cart);
  }
}
