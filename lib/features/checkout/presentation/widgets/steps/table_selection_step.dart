import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/theme/theme_helper.dart';
import '../../../../cart/domain/entities/cart_entity.dart';
import '../../../../orders/presentation/cubit/table_cubit.dart';

/// 🟦 TableSelectionStep - Table selection step for dine-in orders
class TableSelectionStep extends StatefulWidget {
  final CartEntity cart;
  final int? selectedTableId;
  final String? tableQrCode;
  final ValueChanged<Map<String, dynamic>> onTableSelected;

  const TableSelectionStep({
    super.key,
    required this.cart,
    this.selectedTableId,
    this.tableQrCode,
    required this.onTableSelected,
  });

  @override
  State<TableSelectionStep> createState() => _TableSelectionStepState();
}

class _TableSelectionStepState extends State<TableSelectionStep> {
  int? _selectedTableId;
  String? _qrCode;

  @override
  void initState() {
    super.initState();
    _selectedTableId = widget.selectedTableId;
    _qrCode = widget.tableQrCode;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الطاولة',
          style: AppTextStyles.senBold18(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        SizedBox(height: 8.h),
        Text(
          'امسح QR الموجود على الطاولة أو أدخل رقم الطاولة يدوياً',
          style: AppTextStyles.senRegular14(
            context,
          ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: _selectedTableId != null
              ? _buildSelectedTableInfo()
              : _buildTableSelectionOptions(),
        ),
      ],
    );
  }

  Widget _buildSelectedTableInfo() {
    return BlocListener<TableCubit, TableState>(
      listener: (context, state) {
        if (state is TableLoaded) {
          // Update the selected table information
          setState(() {
            _selectedTableId = state.table.id;
          });
          widget.onTableSelected({
            'tableId': state.table.id,
            'qrCode': _qrCode,
          });
        } else if (state is TableError) {
          // Show error and reset selection
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _selectedTableId = null;
            _qrCode = null;
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: ThemeHelper.getCardBackgroundColor(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.lightPrimary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightPrimary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration:const  BoxDecoration(
                color: AppColors.lightPrimary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.table_restaurant,
                color: Colors.white,
                size: 32.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'تم تحديد الطاولة',
              style: AppTextStyles.senBold18(
                context,
              ).copyWith(color: AppColors.lightPrimary),
            ),
            SizedBox(height: 8.h),
            Text(
              'رقم الطاولة: $_selectedTableId',
              style: AppTextStyles.senMedium16(
                context,
              ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
            ),
            SizedBox(height: 24.h),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedTableId = null;
                  _qrCode = null;
                });
              },
              icon: Icon(
                Icons.refresh,
                color: AppColors.lightPrimary,
                size: 20.sp,
              ),
              label: Text(
                'اختيار طاولة أخرى',
                style: AppTextStyles.senMedium16(
                  context,
                ).copyWith(color: AppColors.lightPrimary),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.lightPrimary),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableSelectionOptions() {
    return Column(
      children: [
        _buildQRScanOption(),
        SizedBox(height: 20.h),
        _buildManualInputOption(),
      ],
    );
  }

  Widget _buildQRScanOption() {
    return GestureDetector(
      onTap: _navigateToQRScanner,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: ThemeHelper.getCardBackgroundColor(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ThemeHelper.getSecondaryTextColor(context).withOpacity(0.2),
          ),
          boxShadow: ThemeHelper.getCardShadow(context),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.lightPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.qr_code_scanner,
                color: AppColors.lightPrimary,
                size: 32.sp,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مسح QR Code',
                    style: AppTextStyles.senBold18(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'امسح الكود الموجود على الطاولة',
                    style: AppTextStyles.senRegular14(
                      context,
                    ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.lightPrimary,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualInputOption() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ThemeHelper.getSecondaryTextColor(context).withOpacity(0.2),
        ),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.edit,
                  color: AppColors.lightPrimary,
                  size: 32.sp,
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إدخال يدوي',
                      style: AppTextStyles.senBold18(
                        context,
                      ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'أدخل رقم الطاولة يدوياً',
                      style: AppTextStyles.senRegular14(
                        context,
                      ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'أدخل رقم الطاولة',
              hintStyle: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: ThemeHelper.getSecondaryTextColor(context).withOpacity(0.3),
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
            onChanged: (value) {
              if (value.isNotEmpty) {
                final tableId = int.tryParse(value);
                if (tableId != null) {
                  setState(() {
                    _selectedTableId = tableId;
                  });
                  widget.onTableSelected({
                    'tableId': tableId,
                    'qrCode': null,
                  });
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _navigateToQRScanner() {
    Navigator.of(context).pushNamed(
      AppRoutes.qrScanner,
      arguments: {'cart': widget.cart},
    ).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        final qrCode = result['qrCode'] as String?;
        if (qrCode != null) {
          setState(() {
            _qrCode = qrCode;
          });
          // Trigger table loading with QR code
          context.read<TableCubit>().getTableByQr(qrCode);
        }
      }
    });
  }
}
