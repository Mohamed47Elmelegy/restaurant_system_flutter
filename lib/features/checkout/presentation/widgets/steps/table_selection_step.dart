import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/theme/theme_helper.dart';
import '../../../../cart/domain/entities/cart_entity.dart';
import '../../../../orders/presentation/cubit/table_cubit.dart';
import '../../bloc/checkout_process_bloc.dart';
import '../../bloc/checkout_process_event.dart';

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
    return BlocListener<TableCubit, TableState>(
      listener: (context, state) {
        if (state is TableLoaded) {
          // Hide any loading snackbars
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          // Update the selected table information
          setState(() {
            _selectedTableId = state.table.id;
          });
          widget.onTableSelected({
            'tableId': state.table.id,
            'qrCode': _qrCode,
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Text('تم تحديد الطاولة بنجاح!'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Automatically proceed to next step after successful table selection
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              context.read<CheckoutProcessBloc>().add(
                const NavigateToNextStep(),
              );
            }
          });
        } else if (state is TableError) {
          // Hide loading snackbars
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          // Show error and reset selection
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'إعادة المحاولة',
                textColor: Colors.white,
                onPressed: _navigateToQRScanner,
              ),
              duration: const Duration(seconds: 4),
            ),
          );
          setState(() {
            _selectedTableId = null;
            _qrCode = null;
          });
        } else if (state is TableLoading) {
          // Show loading state in UI if needed
        }
      },
      child: Column(
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
                ? _buildSelectedTableInfoContent()
                : _buildTableSelectionOptions(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTableInfoContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.lightPrimary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightPrimary.withValues(alpha: 0.2),
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
            decoration: const BoxDecoration(
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
    );
  }

  Widget _buildTableSelectionOptions() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildQRScanOption(),
          SizedBox(height: 20.h),
          _buildManualInputOption(),
        ],
      ),
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
            color: ThemeHelper.getSecondaryTextColor(
              context,
            ).withValues(alpha: 0.2),
          ),
          boxShadow: ThemeHelper.getCardShadow(context),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.lightPrimary.withValues(alpha: 0.1),
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
                    style: AppTextStyles.senRegular14(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
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
          color: ThemeHelper.getSecondaryTextColor(
            context,
          ).withValues(alpha: 0.2),
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
                  color: AppColors.lightPrimary.withValues(alpha: 0.1),
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
                      style: AppTextStyles.senBold18(context).copyWith(
                        color: ThemeHelper.getPrimaryTextColor(context),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'أدخل رقم الطاولة يدوياً',
                      style: AppTextStyles.senRegular14(context).copyWith(
                        color: ThemeHelper.getSecondaryTextColor(context),
                      ),
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
            onChanged: (value) {
              if (value.isNotEmpty) {
                final tableId = int.tryParse(value.trim());
                if (tableId != null && tableId > 0) {
                  // Show loading indicator for manual input
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text('جاري التحقق من الطاولة $tableId...'),
                        ],
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: AppColors.lightPrimary,
                    ),
                  );

                  setState(() {
                    _selectedTableId = tableId;
                    _qrCode = null; // Manual input doesn't have QR code
                  });

                  widget.onTableSelected({'tableId': tableId, 'qrCode': null});

                  // Auto-proceed to next step for manual input
                  Future.delayed(const Duration(seconds: 1), () {
                    if (mounted) {
                      context.read<CheckoutProcessBloc>().add(
                        const NavigateToNextStep(),
                      );
                    }
                  });
                } else {
                  // Invalid table number
                  setState(() {
                    _selectedTableId = null;
                    _qrCode = null;
                  });
                }
              } else {
                // Empty input
                setState(() {
                  _selectedTableId = null;
                  _qrCode = null;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void _navigateToQRScanner() {
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.qrScanner, arguments: {'cart': widget.cart}).then((
      result,
    ) {
      if (result != null && result is Map<String, dynamic>) {
        final success = result['success'] as bool? ?? false;
        final qrCode = result['qrCode'] as String?;

        if (success && qrCode != null && qrCode.isNotEmpty) {
          setState(() {
            _qrCode = qrCode;
          });

          // Show loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('جاري التحقق من الطاولة...'),
                ],
              ),
              duration: Duration(seconds: 3),
              backgroundColor: AppColors.lightPrimary,
            ),
          );

          // Trigger table loading with QR code
          context.read<TableCubit>().getTableByQr(qrCode);
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'فشل في قراءة QR Code. يرجى المحاولة مرة أخرى.',
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'إعادة المحاولة',
                textColor: Colors.white,
                onPressed: _navigateToQRScanner,
              ),
            ),
          );
        }
      }
    });
  }
}
