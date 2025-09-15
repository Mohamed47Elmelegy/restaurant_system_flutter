import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/theme/theme_helper.dart';
import '../../../../orders/domain/entities/order_entity.dart';

/// 🟦 OrderTypeStep - Order type selection step
class OrderTypeStep extends StatefulWidget {
  final OrderType? selectedOrderType;
  final ValueChanged<OrderType> onOrderTypeSelected;
  final VoidCallback? onDineInSelected; // Callback for dine-in to handle QR scanning

  const OrderTypeStep({
    super.key,
    this.selectedOrderType,
    required this.onOrderTypeSelected,
    this.onDineInSelected,
  });

  @override
  State<OrderTypeStep> createState() => _OrderTypeStepState();
}

class _OrderTypeStepState extends State<OrderTypeStep> {
  OrderType? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedOrderType;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر نوع الطلب',
          style: AppTextStyles.senBold18(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        SizedBox(height: 8.h),
        Text(
          'حدد كيف تريد استلام طلبك',
          style: AppTextStyles.senRegular14(
            context,
          ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
        ),
        SizedBox(height: 24.h),
        _buildOrderTypeCard(
          context,
          OrderType.delivery,
          'توصيل',
          'سيتم توصيل طلبك إلى عنوانك',
          Icons.delivery_dining,
        ),
        SizedBox(height: 16.h),
        _buildOrderTypeCard(
          context,
          OrderType.dineIn,
          'داخل المطعم',
          'استمتع بطلبك داخل المطعم',
          Icons.restaurant,
        ),
      ],
    );
  }

  Widget _buildOrderTypeCard(
    BuildContext context,
    OrderType type,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
        widget.onOrderTypeSelected(type);
        
        // If dine-in is selected and callback is provided, trigger QR scanning
        if (type == OrderType.dineIn && widget.onDineInSelected != null) {
          widget.onDineInSelected!();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ThemeHelper.getCardBackgroundColor(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.lightPrimary
                : ThemeHelper.getSecondaryTextColor(context).withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.lightPrimary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : ThemeHelper.getCardShadow(context),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.lightPrimary
                    : AppColors.lightPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.lightPrimary,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.senBold16(context).copyWith(
                      color: isSelected
                          ? AppColors.lightPrimary
                          : ThemeHelper.getPrimaryTextColor(context),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: AppTextStyles.senRegular14(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.lightPrimary,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }
}
