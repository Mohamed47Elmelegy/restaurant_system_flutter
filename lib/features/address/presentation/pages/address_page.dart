import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/dialog_constants.dart';
import '../../../../core/constants/empty_page.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/utils/cubit_initializer.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entitiy/address_entity.dart';
import '../cubit/address_cubit.dart';
import '../cubit/address_event.dart';
import '../cubit/address_state.dart';
import '../widgets/address_card.dart';
import 'edit_address_page.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: CubitInitializer.getAddressCubitWithData(),
      child: const _AddressPageContent(),
    );
  }
}

class _AddressPageContent extends StatelessWidget {
  const _AddressPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getAppBarColor(context),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Addresses',
          style: AppTextStyles.senBold18(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ThemeHelper.getPrimaryTextColor(context),
            size: 20.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<AddressCubit, AddressState>(
              listener: (context, state) {
                if (state is AddressError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                } else if (state is AddressAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else if (state is AddressDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is AddressLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.lightPrimary,
                    ),
                  );
                } else if (state is AddressEmpty) {
                  return EmptyPagePresets.noAddresses(context);
                } else if (state is AddressLoaded) {
                  return _buildAddressesList(context, state.addresses);
                } else if (state is AddressError) {
                  return _buildErrorState(context, state.message);
                }
                return EmptyPagePresets.noAddresses(context);
              },
            ),
          ),
          // Add Address Button
          Padding(
            padding: EdgeInsets.all(24.w),
            child: CustomButton(
              text: 'Add New Address',
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.addAddress),
              width: double.infinity,
              height: 56.h,
              borderRadius: 16.r,
              textStyle: AppTextStyles.senBold16(
                context,
              ).copyWith(color: Colors.white),
              boxShadow: ThemeHelper.getButtonShadow(context),
            ),
          ),
        ],
      ),
    );
  }

 
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80.w, color: AppColors.error),
          SizedBox(height: 16.h),
          Text(
            'An Error Occurred',
            style: AppTextStyles.senBold18(
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
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<AddressCubit>().add(LoadAddresses());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressesList(
    BuildContext context,
    List<AddressEntity> addresses,
  ) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses[index];
        return CustomAddressCart(
          title: address.name,
          address: address.fullAddress,
          isDefault: address.isDefault,
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditAddressPage(address: address),
              ),
            );
          },
          onDelete: () {
            DialogConstants.showPlatformConfirmation(
              context: context,
              title: 'Delete Address',
              content: 'Are you sure you want to delete this address?',
              confirmText: 'Delete',
              cancelText: 'Cancel',
              isDestructive: true,
            );
          },
          onSetDefault: address.isDefault
              ? null
              : () {
                  context.read<AddressCubit>().add(
                    SetDefaultAddress(addressId: address.id),
                  );
                },
        );
      },
    );
  }
}
