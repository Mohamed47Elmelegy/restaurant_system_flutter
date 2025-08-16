import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/validation/form_validator.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/entitiy/address_entity.dart';
import '../cubit/address_cubit.dart';
import '../cubit/address_event.dart';
import '../cubit/address_state.dart';

class AddAddressPage extends StatelessWidget {
  final Function(AddressEntity)? onAddressAdded;

  const AddAddressPage({super.key, this.onAddressAdded});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddressCubit>(),
      child: _AddAddressPageContent(onAddressAdded: onAddressAdded),
    );
  }
}

class _AddAddressPageContent extends StatefulWidget {
  final Function(AddressEntity)? onAddressAdded;

  const _AddAddressPageContent({this.onAddressAdded});

  @override
  State<_AddAddressPageContent> createState() => _AddAddressPageContentState();
}

class _AddAddressPageContentState extends State<_AddAddressPageContent> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _phoneController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // تعيين قيمة افتراضية للبلد
    _countryController.text = 'مصر';
  }

  @override
  void dispose() {
    _labelController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _phoneController.dispose();
    _apartmentController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // الحصول على user ID من SecureStorage
      const secureStorage = FlutterSecureStorage();
      int userId = 1; // default value

      try {
        final userDataString = await secureStorage.read(key: 'user_data');
        if (userDataString != null) {
          final userData = json.decode(userDataString);
          userId = userData['id'] ?? 1;
        }
      } catch (e) {
        // في حالة فشل قراءة البيانات، نستخدم القيمة الافتراضية
        // Error reading user data: $e
      }

      final newAddress = AddressEntity(
        id: 0, // Will be set by the server
        userId: userId, // Get from current user session
        label: _labelController.text.trim().isNotEmpty
            ? _labelController.text.trim()
            : _nameController.text
                  .trim(), // Use label if provided, otherwise use name
        addressLine1: _addressController.text.trim(),
        addressLine2: _apartmentController.text.trim().isNotEmpty
            ? _apartmentController.text.trim()
            : null,
        city: _cityController.text.trim(),
        state: _districtController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        country: _countryController.text.trim(),
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        isDefault: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // استخدام AddressCubit لإضافة العنوان
      context.read<AddressCubit>().add(AddAddress(address: newAddress));

      // لا نحتاج للـ Navigator.pop هنا لأن BlocListener سيتعامل مع النجاح
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'حدث خطأ أثناء إضافة العنوان',
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getAppBarColor(context),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'إضافة عنوان جديد',
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
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.address);
            },
            icon: Icon(
              Icons.location_on_outlined,
              color: AppColors.lightPrimary,
              size: 20.w,
            ),
            label: Text(
              'العناوين',
              style: AppTextStyles.senRegular14(
                context,
              ).copyWith(color: AppColors.lightPrimary),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: BlocListener<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is AddressAdded) {
            // إظهار رسالة نجاح
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: AppTextStyles.senBold14(
                    context,
                  ).copyWith(color: Colors.white),
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );

            // إرجاع العنوان المضاف إذا كان هناك callback
            if (widget.onAddressAdded != null) {
              widget.onAddressAdded!(state.address);
            }

            // العودة للصفحة السابقة
            Navigator.pop(context);
          } else if (state is AddressError) {
            // إظهار رسالة خطأ
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
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
                    'تفاصيل العنوان',
                    style: AppTextStyles.senExtraBold24(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'يرجى ملء البيانات التالية لإضافة عنوان جديد',
                    style: AppTextStyles.senRegular16(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Label Field
                  Text(
                    'اسم العنوان *',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _labelController,
                    hint: 'مثال: المنزل، العمل، الجامعة',
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
                        FormValidator.validateRequired(value, 'اسم العنوان'),
                  ),
                  SizedBox(height: 20.h),

                  // Name Field
                  Text(
                    'اسم المستلم *',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _nameController,
                    hint: 'أدخل اسم المستلم',
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
                        FormValidator.validateRequired(value, 'اسم المستلم'),
                  ),
                  SizedBox(height: 20.h),

                  // Address Field
                  Text(
                    'العنوان *',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _addressController,
                    hint: 'أدخل العنوان التفصيلي',
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
                    onValidate: (value) =>
                        FormValidator.validateRequired(value, 'العنوان'),
                  ),
                  SizedBox(height: 20.h),

                  // City Field
                  Text(
                    'المدينة *',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _cityController,
                    hint: 'أدخل اسم المدينة',
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
                        FormValidator.validateRequired(value, 'المدينة'),
                  ),
                  SizedBox(height: 20.h),

                  // District Field
                  Text(
                    'الحي/المنطقة *',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _districtController,
                    hint: 'أدخل اسم الحي أو المنطقة',
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
                        FormValidator.validateRequired(value, 'الحي/المنطقة'),
                  ),
                  SizedBox(height: 20.h),

                  // Phone Field
                  Text(
                    'رقم الهاتف',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _phoneController,
                    hint: 'أدخل رقم الهاتف (اختياري)',
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
                  ),
                  SizedBox(height: 20.h),

                  // Postal Code Field
                  Text(
                    'الرمز البريدي',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _postalCodeController,
                    hint: 'أدخل الرمز البريدي',
                    keyboardType: TextInputType.number,
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

                  // Country Field
                  Text(
                    'البلد *',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _countryController,
                    hint: 'أدخل اسم البلد',
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
                        FormValidator.validateRequired(value, 'البلد'),
                  ),
                  SizedBox(height: 20.h),

                  // Apartment Field
                  Text(
                    'رقم الشقة',
                    style: AppTextStyles.senBold16(
                      context,
                    ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _apartmentController,
                    hint: 'أدخل رقم الشقة (اختياري)',
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
                  SizedBox(height: 40.h),

                  // Save Button
                  CustomButton(
                    text: 'حفظ العنوان',
                    onPressed: _saveAddress,
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
