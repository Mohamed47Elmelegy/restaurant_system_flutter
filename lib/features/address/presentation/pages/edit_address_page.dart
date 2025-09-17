import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_system_flutter/core/services/snack_bar_service.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/utils/cubit_initializer.dart';
import '../../../../core/validation/form_validator.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/entitiy/address_entity.dart';
import '../cubit/address_cubit.dart';
import '../cubit/address_event.dart';
import '../cubit/address_state.dart';

class EditAddressPage extends StatelessWidget {
  final AddressEntity address;

  const EditAddressPage({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: CubitInitializer.getAddressCubitWithData(),
      child: _EditAddressPageContent(address: address),
    );
  }
}

class _EditAddressPageContent extends StatefulWidget {
  final AddressEntity address;

  const _EditAddressPageContent({required this.address});

  @override
  State<_EditAddressPageContent> createState() =>
      _EditAddressPageContentState();
}

class _EditAddressPageContentState extends State<_EditAddressPageContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _addressController;
  late final TextEditingController _buildingController;
  late final TextEditingController _apartmentController;
  late bool _isDefault;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address.name);
    _cityController = TextEditingController(text: widget.address.city);
    _phoneNumberController = TextEditingController(
      text: widget.address.phoneNumber,
    );
    _addressController = TextEditingController(text: widget.address.address);
    _buildingController = TextEditingController(
      text: widget.address.building ?? '',
    );
    _apartmentController = TextEditingController(
      text: widget.address.apartment ?? '',
    );
    _isDefault = widget.address.isDefault;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _buildingController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }

  Future<void> _updateAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create updated address entity
      final updatedAddress = AddressEntity(
        id: widget.address.id,
        userId: widget.address.userId,
        name: _nameController.text.trim(),
        city: _cityController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        address: _addressController.text.trim(),
        building: _buildingController.text.trim().isNotEmpty
            ? _buildingController.text.trim()
            : null,
        apartment: _apartmentController.text.trim().isNotEmpty
            ? _apartmentController.text.trim()
            : null,
        isDefault: _isDefault,
        createdAt: widget.address.createdAt,
        updatedAt: DateTime.now(),
      );

      // Update address using cubit
      context.read<AddressCubit>().add(UpdateAddress(address: updatedAddress));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred: $e',
            style: AppTextStyles.senBold14(
              context,
            ).copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Address',
          style: AppTextStyles.senBold18(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        backgroundColor: ThemeHelper.getAppBarColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ThemeHelper.getPrimaryTextColor(context),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is AddressUpdated) {
            SnackBarService.showSuccessSnackBar(state.message);
            // Go back to previous page
            Navigator.pop(context);
          } else if (state is AddressError) {
            SnackBarService.showErrorMessage(context, state.message);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Title
                  Text(
                    'Edit Address',
                    style: AppTextStyles.senExtraBold24(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Update your address information',
                    style: AppTextStyles.senRegular16(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Name Field
                  Text(
                    'Full Name *',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _nameController,
                    hint: 'Enter your full name',
                    keyboardType: TextInputType.name,
                    textStyle: AppTextStyles.senRegular14(context),
                    hintTextStyle: AppTextStyles.senRegular14(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                    fillColor: ThemeHelper.getInputBackgroundColor(context),
                    borderColor: ThemeHelper.getDividerColor(context),
                    focusedBorderColor: AppColors.lightPrimary,
                    borderRadius: 12.r,
                    contentPadding: EdgeInsets.all(16.w),
                    onValidate: (value) =>
                        FormValidator.validateRequired(value, 'Full Name'),
                  ),
                  SizedBox(height: 20.h),

                  // City Field
                  Text(
                    'City *',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _cityController,
                    hint: 'Enter city name',
                    keyboardType: TextInputType.text,
                    textStyle: AppTextStyles.senRegular14(context),
                    hintTextStyle: AppTextStyles.senRegular14(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                    fillColor: ThemeHelper.getInputBackgroundColor(context),
                    borderColor: ThemeHelper.getDividerColor(context),
                    focusedBorderColor: AppColors.lightPrimary,
                    borderRadius: 12.r,
                    contentPadding: EdgeInsets.all(16.w),
                    onValidate: (value) =>
                        FormValidator.validateRequired(value, 'City'),
                  ),
                  SizedBox(height: 20.h),

                  // Phone Number Field
                  Text(
                    'Phone Number *',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _phoneNumberController,
                    hint: 'Enter phone number',
                    keyboardType: TextInputType.phone,
                    textStyle: AppTextStyles.senRegular14(context),
                    hintTextStyle: AppTextStyles.senRegular14(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                    fillColor: ThemeHelper.getInputBackgroundColor(context),
                    borderColor: ThemeHelper.getDividerColor(context),
                    focusedBorderColor: AppColors.lightPrimary,
                    borderRadius: 12.r,
                    contentPadding: EdgeInsets.all(16.w),
                    onValidate: (value) =>
                        FormValidator.validateRequired(value, 'Phone Number'),
                  ),
                  SizedBox(height: 20.h),

                  // Address Field
                  Text(
                    'Address *',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _addressController,
                    hint: 'Enter street address and details',
                    keyboardType: TextInputType.streetAddress,
                    textStyle: AppTextStyles.senRegular14(context),
                    hintTextStyle: AppTextStyles.senRegular14(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                    fillColor: ThemeHelper.getInputBackgroundColor(context),
                    borderColor: ThemeHelper.getDividerColor(context),
                    focusedBorderColor: AppColors.lightPrimary,
                    borderRadius: 12.r,
                    contentPadding: EdgeInsets.all(16.w),
                    maxLines: 3,
                    onValidate: (value) =>
                        FormValidator.validateRequired(value, 'Address'),
                  ),
                  SizedBox(height: 20.h),

                  // Building Field
                  Text(
                    'Building',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _buildingController,
                    hint: 'Enter building number/name (optional)',
                    keyboardType: TextInputType.text,
                    textStyle: AppTextStyles.senRegular14(context),
                    hintTextStyle: AppTextStyles.senRegular14(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                    fillColor: ThemeHelper.getInputBackgroundColor(context),
                    borderColor: ThemeHelper.getDividerColor(context),
                    focusedBorderColor: AppColors.lightPrimary,
                    borderRadius: 12.r,
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                  SizedBox(height: 20.h),

                  // Apartment Field
                  Text(
                    'Apartment',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _apartmentController,
                    hint: 'Enter apartment number (optional)',
                    keyboardType: TextInputType.text,
                    textStyle: AppTextStyles.senRegular14(context),
                    hintTextStyle: AppTextStyles.senRegular14(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                    fillColor: ThemeHelper.getInputBackgroundColor(context),
                    borderColor: ThemeHelper.getDividerColor(context),
                    focusedBorderColor: AppColors.lightPrimary,
                    borderRadius: 12.r,
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                  SizedBox(height: 20.h),

                  // Default Address Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _isDefault,
                        onChanged: (value) {
                          setState(() {
                            _isDefault = value ?? false;
                          });
                        },
                        activeColor: AppColors.lightPrimary,
                      ),
                      Expanded(
                        child: Text(
                          'Set as default address',
                          style: AppTextStyles.senRegular14(context).copyWith(
                            color: ThemeHelper.getPrimaryTextColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),

                  // Update Button
                  CustomButton(
                    text: 'Update Address',
                    onPressed: _updateAddress,
                    isLoading: _isLoading,
                    width: double.infinity,
                    height: 56.h,
                    borderRadius: 16.r,
                    textStyle: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: Colors.white),
                    boxShadow: ThemeHelper.getButtonShadow(context),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
