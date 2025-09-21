import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/theme/theme_helper.dart';
import '../../../../cart/domain/entities/cart_entity.dart';

/// 🟦 OrderReviewStep - Order review and notes step
class OrderReviewStep extends StatefulWidget {
  final CartEntity cart;
  final String? notes;
  final ValueChanged<String> onNotesChanged;

  const OrderReviewStep({
    super.key,
    required this.cart,
    this.notes,
    required this.onNotesChanged,
  });

  @override
  State<OrderReviewStep> createState() => _OrderReviewStepState();
}

class _OrderReviewStepState extends State<OrderReviewStep> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مراجعة الطلب',
          style: AppTextStyles.senBold18(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        SizedBox(height: 8.h),
        Text(
          'راجع عناصر طلبك وأضف أي ملاحظات إضافية',
          style: AppTextStyles.senRegular14(
            context,
          ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderSummary(),
                SizedBox(height: 24.h),
                _buildNotesSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                color: AppColors.lightPrimary,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'ملخص الطلب',
                style: AppTextStyles.senBold16(
                  context,
                ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...widget.cart.items.map((item) => _buildOrderItem(item)),
          SizedBox(height: 12.h),
          Divider(
            color: ThemeHelper.getSecondaryTextColor(
              context,
            ).withValues(alpha: 0.2),
          ),
          SizedBox(height: 12.h),
          _buildTotalRow(),
        ],
      ),
    );
  }

  Widget _buildOrderItem(dynamic item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              item.product.imageUrl,
              width: 50.w,
              height: 50.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.fastfood,
                    color: Colors.grey[600],
                    size: 24.sp,
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: AppTextStyles.senMedium14(
                    context,
                  ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                ),
                Text(
                  'الكمية: ${item.quantity}',
                  style: AppTextStyles.senRegular12(
                    context,
                  ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
                ),
              ],
            ),
          ),
          Text(
            '${item.totalPrice.toStringAsFixed(2)} ج.م',
            style: AppTextStyles.senBold14(
              context,
            ).copyWith(color: AppColors.lightPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'المجموع الكلي',
          style: AppTextStyles.senBold16(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        Text(
          '${widget.cart.subtotal.toStringAsFixed(2)} ج.م',
          style: AppTextStyles.senBold18(
            context,
          ).copyWith(color: AppColors.lightPrimary),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note_add, color: AppColors.lightPrimary, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'ملاحظات إضافية (اختياري)',
                style: AppTextStyles.senBold16(
                  context,
                ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'أضف أي ملاحظات خاصة بطلبك... (اختياري)',
              hintStyle: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: ThemeHelper.getSecondaryTextColor(
                    context,
                  ).withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(
                  color: AppColors.lightPrimary,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(12.w),
            ),
            onChanged: widget.onNotesChanged,
          ),
        ],
      ),
    );
  }
}
