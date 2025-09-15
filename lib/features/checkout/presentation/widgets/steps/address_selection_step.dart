import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/theme/theme_helper.dart';
import '../../../../address/domain/entitiy/address_entity.dart';
import '../../../../address/presentation/cubit/address_cubit.dart';
import '../../../../address/presentation/cubit/address_event.dart';
import '../../../../address/presentation/cubit/address_state.dart';

/// 🟦 AddressSelectionStep - Address selection step for delivery orders
class AddressSelectionStep extends StatefulWidget {
  final int? selectedAddressId;
  final ValueChanged<Map<String, dynamic>> onAddressSelected;

  const AddressSelectionStep({
    super.key,
    this.selectedAddressId,
    required this.onAddressSelected,
  });

  @override
  State<AddressSelectionStep> createState() => _AddressSelectionStepState();
}

class _AddressSelectionStepState extends State<AddressSelectionStep> {
  int? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    _selectedAddressId = widget.selectedAddressId;
    // Load addresses when the step initializes
    context.read<AddressCubit>().add(LoadAddresses());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر عنوان التوصيل',
          style: AppTextStyles.senBold18(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        SizedBox(height: 8.h),
        Text(
          'اختر العنوان الذي تريد توصيل طلبك إليه',
          style: AppTextStyles.senRegular14(
            context,
          ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: BlocBuilder<AddressCubit, AddressState>(
            builder: (context, state) {
              if (state is AddressLoading) {
                return _buildLoadingState();
              } else if (state is AddressError) {
                return _buildErrorState(state.message);
              } else if (state is AddressLoaded) {
                if (state.addresses.isEmpty) {
                  return _buildEmptyAddressState(context);
                }
                return _buildAddressList(state.addresses);
              }
              return _buildEmptyAddressState(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.lightPrimary),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            'حدث خطأ في تحميل العناوين',
            style: AppTextStyles.senBold16(
              context,
            ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: AppTextStyles.senRegular14(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              context.read<AddressCubit>().add(LoadAddresses());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
            ),
            child: Text(
              'إعادة المحاولة',
              style: AppTextStyles.senMedium16(
                context,
              ).copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAddressState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 80.sp,
            color: ThemeHelper.getSecondaryTextColor(context),
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد عناوين محفوظة',
            style: AppTextStyles.senBold18(
              context,
            ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          ),
          SizedBox(height: 8.h),
          Text(
            'يجب إضافة عنوان واحد على الأقل للمتابعة',
            style: AppTextStyles.senRegular14(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddAddress(context),
            icon: const Icon(Icons.add_location, color: Colors.white),
            label: Text(
              'إضافة عنوان جديد',
              style: AppTextStyles.senMedium16(
                context,
              ).copyWith(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
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

  Widget _buildAddressList(List<AddressEntity> addresses) {
    // Auto-select default address if none is selected yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedAddressId == null && addresses.isNotEmpty) {
        final defaultAddress = addresses.firstWhere(
          (address) => address.isDefault,
          orElse: () => addresses.first, // Fallback to first address
        );

        if (mounted) {
          setState(() {
            _selectedAddressId = defaultAddress.id;
          });
          widget.onAddressSelected({
            'addressId': defaultAddress.id,
            'deliveryAddress': defaultAddress.fullAddress,
          });
        }
      }
    });

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: addresses.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final address = addresses[index];
              return _buildAddressCard(address);
            },
          ),
        ),
        SizedBox(height: 16.h),
        _buildAddNewAddressButton(context),
      ],
    );
  }

  Widget _buildAddressCard(AddressEntity address) {
    final isSelected = _selectedAddressId == address.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAddressId = address.id;
        });
        widget.onAddressSelected({
          'addressId': address.id,
          'deliveryAddress': address.fullAddress,
        });
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
                Icons.location_on,
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
                    address.name,
                    style: AppTextStyles.senBold16(context).copyWith(
                      color: isSelected
                          ? AppColors.lightPrimary
                          : ThemeHelper.getPrimaryTextColor(context),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    address.fullAddress,
                    style: AppTextStyles.senRegular14(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (address.phoneNumber.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'الهاتف: ${address.phoneNumber}',
                      style: AppTextStyles.senRegular12(context).copyWith(
                        color: ThemeHelper.getSecondaryTextColor(context),
                      ),
                    ),
                  ],
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

  Widget _buildAddNewAddressButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _navigateToAddAddress(context),
      icon: Icon(
        Icons.add_location,
        color: AppColors.lightPrimary,
        size: 20.sp,
      ),
      label: Text(
        'إضافة عنوان جديد',
        style: AppTextStyles.senMedium16(
          context,
        ).copyWith(color: AppColors.lightPrimary),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.lightPrimary),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  void _navigateToAddAddress(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.addAddress).then((_) {
      // Reload addresses after returning from add address page
      context.read<AddressCubit>().add(LoadAddresses());
    });
  }
}
