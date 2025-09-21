import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/theme/theme_helper.dart';

/// 🟦 PaymentMethodStep - Payment method selection step
class PaymentMethodStep extends StatefulWidget {
  final String? selectedPaymentMethod;
  final ValueChanged<String> onPaymentMethodSelected;

  const PaymentMethodStep({
    super.key,
    this.selectedPaymentMethod,
    required this.onPaymentMethodSelected,
  });

  @override
  State<PaymentMethodStep> createState() => _PaymentMethodStepState();
}

class _PaymentMethodStepState extends State<PaymentMethodStep> {
  String? _selectedMethod;

  final List<PaymentMethodOption> _paymentMethods = [
    const PaymentMethodOption(
      id: 'cash',
      title: 'نقداً',
      description: 'ادفع نقداً عند الاستلام',
      icon: Icons.money,
      isEnabled: true,
    ),
    const PaymentMethodOption(
      id: 'credit_card',
      title: 'بطاقة ائتمان',
      description: 'ادفع باستخدام بطاقة الائتمان',
      icon: Icons.credit_card,
      isEnabled: true,
    ),
    const PaymentMethodOption(
      id: 'digital_wallet',
      title: 'محفظة رقمية',
      description: 'ادفع باستخدام محفظتك الرقمية',
      icon: Icons.account_balance_wallet,
      isEnabled: false, // Will be enabled later
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedPaymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر طريقة الدفع',
          style: AppTextStyles.senBold18(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        SizedBox(height: 8.h),
        Text(
          'حدد الطريقة المفضلة لديك للدفع',
          style: AppTextStyles.senRegular14(
            context,
          ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: ListView.separated(
            itemCount: _paymentMethods.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final method = _paymentMethods[index];
              return _buildPaymentMethodCard(context, method);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    PaymentMethodOption method,
  ) {
    final isSelected = _selectedMethod == method.id;
    final isEnabled = method.isEnabled;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.6,
      child: GestureDetector(
        onTap: isEnabled
            ? () {
                setState(() {
                  _selectedMethod = method.id;
                });
                widget.onPaymentMethodSelected(method.id);
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: ThemeHelper.getCardBackgroundColor(context),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected && isEnabled
                  ? AppColors.lightPrimary
                  : ThemeHelper.getSecondaryTextColor(
                      context,
                    ).withValues(alpha: 0.2),
              width: isSelected && isEnabled ? 2 : 1,
            ),
            boxShadow: isSelected && isEnabled
                ? [
                    BoxShadow(
                      color: AppColors.lightPrimary.withValues(alpha: 0.2),
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
                  color: isSelected && isEnabled
                      ? AppColors.lightPrimary
                      : AppColors.lightPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  method.icon,
                  color: isSelected && isEnabled
                      ? Colors.white
                      : AppColors.lightPrimary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          method.title,
                          style: AppTextStyles.senBold16(context).copyWith(
                            color: isSelected && isEnabled
                                ? AppColors.lightPrimary
                                : ThemeHelper.getPrimaryTextColor(context),
                          ),
                        ),
                        if (!isEnabled) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'قريباً',
                              style: AppTextStyles.senRegular10(
                                context,
                              ).copyWith(color: Colors.orange),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      method.description,
                      style: AppTextStyles.senRegular14(context).copyWith(
                        color: ThemeHelper.getSecondaryTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected && isEnabled)
                Icon(
                  Icons.check_circle,
                  color: AppColors.lightPrimary,
                  size: 24.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Payment method option model
class PaymentMethodOption {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool isEnabled;

  const PaymentMethodOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isEnabled,
  });
}
