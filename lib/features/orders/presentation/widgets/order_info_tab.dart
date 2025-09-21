import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/utils/order_utils.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_enums.dart';
import 'status_chip.dart';

class OrderInfoTab extends StatelessWidget {
  final OrderEntity order;

  const OrderInfoTab({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(context, 'معلومات الطلب', [
            _buildInfoRow(context, 'رقم الطلب', '#${order.id}'),
            _buildInfoRow(
              context,
              'نوع الطلب',
              OrderUtils.getOrderTypeDisplayName(order.type),
            ),
            _buildInfoRowWithWidget(
              context,
              'حالة الطلب',
              StatusChip(status: order.status, fontSize: 11),
            ),
            _buildInfoRow(
              context,
              'حالة الدفع',
              OrderUtils.getPaymentStatusDisplayName(order.paymentStatus),
            ),
            _buildInfoRow(
              context,
              'تاريخ الطلب',
              _formatDateTime(order.createdAt),
            ),
            _buildInfoRow(
              context,
              'آخر تحديث',
              _formatDateTime(order.updatedAt),
            ),
          ]),

          SizedBox(height: 20.h),

          if (order.type == OrderType.delivery) ...[
            _buildInfoSection(context, 'معلومات التوصيل', [
              _buildInfoRow(
                context,
                'العنوان',
                order.deliveryAddress ?? 'غير محدد',
              ),
              _buildInfoRow(
                context,
                'رسوم التوصيل',
                '${order.deliveryFee.toStringAsFixed(2)} ج.م',
              ),
            ]),
            SizedBox(height: 20.h),
          ],

          if (order.type == OrderType.dineIn && order.tableId != null) ...[
            _buildInfoSection(context, 'معلومات الطاولة', [
              _buildInfoRow(context, 'رقم الطاولة', '${order.tableId}'),
            ]),
            SizedBox(height: 20.h),
          ],

          _buildInfoSection(context, 'تفاصيل إضافية', [
            if (order.specialInstructions != null)
              _buildInfoRow(
                context,
                'تعليمات خاصة',
                order.specialInstructions!,
              ),
            if (order.notes != null)
              _buildInfoRow(context, 'ملاحظات', order.notes!),
            if (order.paymentMethod != null)
              _buildInfoRow(context, 'طريقة الدفع', order.paymentMethod!),
          ]),

          SizedBox(height: 20.h),

          _buildTotalSummary(context),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
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
          Text(
            title,
            style: AppTextStyles.senBold16(
              context,
            ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: AppTextStyles.senMedium14(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowWithWidget(
    BuildContext context,
    String label,
    Widget widget,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: AppTextStyles.senMedium14(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
            ),
          ),
          Expanded(
            child: Align(alignment: Alignment.centerRight, child: widget),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSummary(BuildContext context) {
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
          Text(
            'ملخص المبالغ',
            style: AppTextStyles.senBold16(
              context,
            ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          ),
          SizedBox(height: 12.h),
          _buildAmountRow(context, 'المبلغ الفرعي', order.subtotalAmount),
          _buildAmountRow(context, 'الضريبة', order.taxAmount),
          if (order.deliveryFee > 0)
            _buildAmountRow(context, 'رسوم التوصيل', order.deliveryFee),
          Divider(
            color: ThemeHelper.getSecondaryTextColor(
              context,
            ).withValues(alpha: 0.3),
            height: 20.h,
          ),
          _buildAmountRow(
            context,
            'المجموع الإجمالي',
            order.totalAmount,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(
    BuildContext context,
    String label,
    double amount, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                (isTotal
                        ? AppTextStyles.senBold14(context)
                        : AppTextStyles.senRegular14(context))
                    .copyWith(
                      color: isTotal
                          ? ThemeHelper.getPrimaryTextColor(context)
                          : ThemeHelper.getSecondaryTextColor(context),
                    ),
          ),
          Text(
            '${amount.toStringAsFixed(2)} ج.م',
            style:
                (isTotal
                        ? AppTextStyles.senBold16(context)
                        : AppTextStyles.senMedium14(context))
                    .copyWith(
                      color: isTotal
                          ? AppColors.lightPrimary
                          : ThemeHelper.getPrimaryTextColor(context),
                    ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
