import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../address/domain/entitiy/address_entity.dart';
import '../../../address/presentation/cubit/address_cubit.dart';
import '../../../address/presentation/cubit/address_state.dart';
import 'address_option.dart';

class AddressSectionWidget extends StatelessWidget {
  const AddressSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'عناويني',
                    style: AppTextStyles.senBold18(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.addAddress),
                    child: Text(
                      'إضافة عنوان',
                      style: AppTextStyles.senRegular14(
                        context,
                      ).copyWith(color: AppColors.lightPrimary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _buildAddressContent(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddressContent(BuildContext context, AddressState state) {
    if (state is AddressLoading) {
      return _buildLoadingState();
    } else if (state is AddressLoaded) {
      return _buildAddressList(context, state.addresses);
    } else if (state is AddressEmpty) {
      return _buildEmptyState(context);
    } else if (state is AddressError) {
      return _buildErrorState(context, state.message);
    }
    return _buildEmptyState(context);
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 80.h,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.lightPrimary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildAddressList(
    BuildContext context,
    List<AddressEntity> addresses,
  ) {
    if (addresses.isEmpty) {
      return _buildEmptyState(context);
    }

    // إظهار العنوان الافتراضي أو أول عنوان
    final defaultAddress =
        addresses.where((address) => address.isDefault).isNotEmpty
        ? addresses.where((address) => address.isDefault).first
        : addresses.first;

    return Container(
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.lightPrimary, width: 1),
      ),
      child: AddressOption(
        title: defaultAddress.name,
        subtitle: _formatAddress(defaultAddress),
        isSelected: true,
        onTap: () =>
            _showAddressSelectionDialog(context, addresses, defaultAddress),
        leadingIcon: Icons.location_on,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.addAddress),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ThemeHelper.getCardBackgroundColor(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.lightPrimary,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.lightPrimary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.add_location_alt,
                color: AppColors.lightPrimary,
                size: 20.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إضافة عنوان جديد',
                    style: AppTextStyles.senBold14(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  Text(
                    'أضف عنوانك الأول لتسهيل عملية التوصيل',
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
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 20.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAddress(AddressEntity address) {
    final parts = <String>[];

    if (address.city.isNotEmpty) {
      parts.add(address.city);
    }

    return parts.take(2).join(', '); // أخذ أول عنصرين فقط لتجنب النص الطويل
  }

  void _showAddressSelectionDialog(
    BuildContext context,
    List<AddressEntity> addresses,
    AddressEntity currentAddress,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'اختيار عنوان التوصيل',
          style: AppTextStyles.senBold16(context),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // عرض جميع العناوين
            ...addresses.map(
              (address) => AddressOption(
                title: address.name,
                subtitle: _formatAddress(address),
                isSelected: address.id == currentAddress.id,
                onTap: () {
                  // هنا يمكن إضافة منطق تحديد العنوان المختار
                  Navigator.pop(dialogContext);
                },
              ),
            ),
            const Divider(),
            // خيار إضافة عنوان جديد
            AddressOption(
              title: 'إضافة عنوان جديد',
              subtitle: 'أضف عنوان توصيل جديد',
              isSelected: false,
              onTap: () {
                Navigator.pop(dialogContext);
                Navigator.pushNamed(context, AppRoutes.addAddress);
              },
              leadingIcon: Icons.add_location,
            ),
            // خيار إدارة العناوين
            AddressOption(
              title: 'إدارة العناوين',
              subtitle: 'عرض وتعديل العناوين المحفوظة',
              isSelected: false,
              onTap: () {
                Navigator.pop(dialogContext);
                Navigator.pushNamed(context, AppRoutes.address);
              },
              leadingIcon: Icons.settings_outlined,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'إلغاء',
              style: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
            ),
          ),
        ],
      ),
    );
  }
}
