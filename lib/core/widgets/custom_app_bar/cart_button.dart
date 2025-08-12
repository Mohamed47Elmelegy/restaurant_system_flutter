import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/app_icons.dart';
import '../../theme/app_colors.dart';

class CartButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int itemCount;

  const CartButton({super.key, required this.onPressed, this.itemCount = 0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: SvgPicture.asset(
              AppIcons.shoppingBag,
              width: 20.w,
              height: 20.h,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        if (itemCount > 0)
          Positioned(
            top: 0.h,
            right: 0.w,
            child: Container(
              width: 18.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: AppColors.lightPrimary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  itemCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
