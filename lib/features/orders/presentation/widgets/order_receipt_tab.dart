import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/utils/order_utils.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_enums.dart';

class OrderReceiptTab extends StatelessWidget {
  final OrderEntity order;

  const OrderReceiptTab({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildReceiptContainer(context),
          SizedBox(height: 20.h),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildReceiptContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReceiptHeader(context),
          SizedBox(height: 20.h),
          _buildOrderDetails(context),
          SizedBox(height: 16.h),
          _buildItemsList(context),
          SizedBox(height: 16.h),
          _buildReceiptSummary(context),
          SizedBox(height: 16.h),
          _buildReceiptFooter(context),
        ],
      ),
    );
  }

  Widget _buildReceiptHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'مطعم الذواقة',
          style: AppTextStyles.senBold20(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        SizedBox(height: 4.h),
        Text(
          'شارع الملك فهد، الرياض',
          style: AppTextStyles.senRegular14(
            context,
          ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
        ),
        SizedBox(height: 2.h),
        Text(
          'هاتف: +966 11 123 4567',
          style: AppTextStyles.senRegular12(
            context,
          ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
        ),
        SizedBox(height: 16.h),
        Container(
          height: 1.h,
          color: ThemeHelper.getSecondaryTextColor(context).withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildOrderDetails(BuildContext context) {
    return Column(
      children: [
        _buildReceiptRow(context, 'رقم الطلب:', '#${order.id}'),
        _buildReceiptRow(context, 'التاريخ:', _formatDate(order.createdAt)),
        _buildReceiptRow(context, 'الوقت:', _formatTime(order.createdAt)),
        _buildReceiptRow(
          context,
          'نوع الطلب:',
          OrderUtils.getOrderTypeDisplayName(order.type),
        ),
        if (order.type == OrderType.delivery && order.deliveryAddress != null)
          _buildReceiptRow(context, 'عنوان التوصيل:', order.deliveryAddress!),
        if (order.type == OrderType.dineIn && order.tableId != null)
          _buildReceiptRow(context, 'رقم الطاولة:', '${order.tableId}'),
      ],
    );
  }

  Widget _buildItemsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1.h,
          color: ThemeHelper.getSecondaryTextColor(context).withOpacity(0.3),
        ),
        SizedBox(height: 12.h),
        Text(
          'الأصناف المطلوبة:',
          style: AppTextStyles.senBold14(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        SizedBox(height: 8.h),
        if (order.items.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Text(
              'لا توجد أصناف في هذا الطلب',
              style: AppTextStyles.senRegular12(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
            ),
          )
        else
          ...order.items.map(
            (item) => _buildReceiptItem(
              context,
              item.name,
              item.quantity,
              item.unitPrice,
            ),
          ),
        SizedBox(height: 12.h),
        Container(
          height: 1.h,
          color: ThemeHelper.getSecondaryTextColor(context).withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildReceiptItem(
    BuildContext context,
    String name,
    int quantity,
    double price,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Text(
            '${quantity}x',
            style: AppTextStyles.senRegular12(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.senRegular12(
                context,
              ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
            ),
          ),
          Text(
            '${(price * quantity).toStringAsFixed(2)} ر.س',
            style: AppTextStyles.senRegular12(
              context,
            ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptSummary(BuildContext context) {
    return Column(
      children: [
        _buildReceiptRow(
          context,
          'المبلغ الفرعي:',
          '${order.subtotalAmount.toStringAsFixed(2)} ر.س',
        ),
        _buildReceiptRow(
          context,
          'الضريبة (15%):',
          '${order.taxAmount.toStringAsFixed(2)} ر.س',
        ),
        if (order.deliveryFee > 0)
          _buildReceiptRow(
            context,
            'رسوم التوصيل:',
            '${order.deliveryFee.toStringAsFixed(2)} ر.س',
          ),
        SizedBox(height: 8.h),
        Container(
          height: 1.h,
          color: ThemeHelper.getSecondaryTextColor(context).withOpacity(0.3),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'المجموع الإجمالي:',
              style: AppTextStyles.senBold16(
                context,
              ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
            ),
            Text(
              '${order.totalAmount.toStringAsFixed(2)} ر.س',
              style: AppTextStyles.senBold16(
                context,
              ).copyWith(color: AppColors.lightPrimary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReceiptFooter(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Container(
          height: 1.h,
          color: ThemeHelper.getSecondaryTextColor(context).withOpacity(0.3),
        ),
        SizedBox(height: 12.h),
        Text(
          'شكراً لاختياركم مطعم الذواقة',
          style: AppTextStyles.senBold14(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          'نتطلع لخدمتكم مرة أخرى',
          style: AppTextStyles.senRegular12(
            context,
          ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'تم الطباعة في: ${_formatDateTime(DateTime.now())}',
          style: AppTextStyles.senRegular10(
            context,
          ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReceiptRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.senRegular12(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.senRegular12(
                context,
              ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement share receipt functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم إضافة ميزة مشاركة الفاتورة قريباً'),
                ),
              );
            },
            icon: const Icon(Icons.share, color: Colors.white),
            label: Text(
              'مشاركة الفاتورة',
              style: AppTextStyles.senMedium16(
                context,
              ).copyWith(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement download receipt functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم إضافة ميزة تحميل الفاتورة قريباً'),
                ),
              );
            },
            icon: Icon(
              Icons.download,
              color: ThemeHelper.getPrimaryTextColor(context),
            ),
            label: Text(
              'تحميل الفاتورة',
              style: AppTextStyles.senMedium16(
                context,
              ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: ThemeHelper.getPrimaryTextColor(context)),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} ${_formatTime(date)}';
  }
}
