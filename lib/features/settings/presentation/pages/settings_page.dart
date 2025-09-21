import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/constants.dart';
import '../../../../core/constants/dialog_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/theme_helper.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getSurfaceColor(context),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الإعدادات',
          style: AppTextStyles.senBold18(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: Constants.mediumPadding,
        children: [
          // User Profile Card
          _buildUserProfileCard(context),
          SizedBox(height: Constants.largeSpacing),

          // Account Section
          _buildSettingsSection(context, 'الحساب', [
            _buildSettingsTile(
              context,
              icon: Icons.person_outline,
              title: 'الملف الشخصي',
              subtitle: 'إدارة معلومات حسابك',
              onTap: () => _navigateToProfile(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.location_on_outlined,
              title: 'العناوين المحفوظة',
              subtitle: 'إدارة عناوين التوصيل',
              onTap: () => Navigator.pushNamed(context, AppRoutes.address),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.payment_outlined,
              title: 'طرق الدفع',
              subtitle: 'إدارة البطاقات ووسائل الدفع',
              onTap: () => _showPaymentMethods(context),
            ),
          ]),

          SizedBox(height: Constants.largeSpacing),

          // App Settings Section
          _buildSettingsSection(context, 'إعدادات التطبيق', [
            _buildSettingsTile(
              context,
              icon: Icons.dark_mode_outlined,
              title: 'المظهر',
              subtitle: 'تغيير بين الوضع الفاتح والداكن',
              trailing: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, themeState) {
                  return Switch(
                    value: themeState.isDarkMode,
                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value
                                ? 'تم تفعيل الوضع الداكن'
                                : 'تم تفعيل الوضع الفاتح',
                          ),
                          backgroundColor: AppColors.success,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    activeColor: AppColors.lightPrimary,
                  );
                },
              ),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.notifications_outlined,
              title: 'الإشعارات',
              subtitle: 'إعدادات الإشعارات والتنبيهات',
              onTap: () => _showNotificationSettings(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.language_outlined,
              title: 'اللغة',
              subtitle: 'العربية',
              onTap: () => _showLanguageOptions(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.security_outlined,
              title: 'الخصوصية والأمان',
              subtitle: 'إعدادات الحساب والخصوصية',
              onTap: () => _showPrivacySettings(context),
            ),
          ]),

          SizedBox(height: Constants.largeSpacing),

          // Orders & Favorites Section
          _buildSettingsSection(context, 'الطلبات والمفضلة', [
            _buildSettingsTile(
              context,
              icon: Icons.history_outlined,
              title: 'تاريخ الطلبات',
              subtitle: 'عرض جميع طلباتك السابقة',
              onTap: () => _navigateToOrderHistory(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.favorite_outline,
              title: 'المفضلة',
              subtitle: 'إدارة منتجاتك المفضلة',
              onTap: () => _navigateToFavorites(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.star_outline,
              title: 'التقييمات والمراجعات',
              subtitle: 'مراجعة تقييماتك السابقة',
              onTap: () => _showReviews(context),
            ),
          ]),

          SizedBox(height: Constants.largeSpacing),

          // Help & Support Section
          _buildSettingsSection(context, 'المساعدة والدعم', [
            _buildSettingsTile(
              context,
              icon: Icons.help_outline,
              title: 'مركز المساعدة',
              subtitle: 'الأسئلة الشائعة والدعم',
              onTap: () => _showHelpCenter(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.phone_outlined,
              title: 'اتصل بنا',
              subtitle: 'تواصل مع فريق الدعم',
              onTap: () => _showContactOptions(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.feedback_outlined,
              title: 'إرسال ملاحظات',
              subtitle: 'شاركنا رأيك لتحسين التطبيق',
              onTap: () => _showFeedbackForm(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.info_outline,
              title: 'حول التطبيق',
              subtitle: 'معلومات حول التطبيق والإصدار',
              onTap: () => _showAboutDialog(context),
            ),
          ]),

          SizedBox(height: Constants.largeSpacing),

          // Logout Button
          _buildLogoutSection(context),

          SizedBox(height: Constants.extraLargeSpacing),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 16.w, bottom: 8.h),
          child: Text(
            title,
            style: AppTextStyles.senBold16(
              context,
            ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ThemeHelper.getCardBackgroundColor(context),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: titleColor ?? ThemeHelper.getPrimaryTextColor(context),
        size: 24.sp,
      ),
      title: Text(
        title,
        style: AppTextStyles.senMedium16(context).copyWith(
          color: titleColor ?? ThemeHelper.getPrimaryTextColor(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.senRegular12(
          context,
        ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 16.sp,
            color: ThemeHelper.getSecondaryTextColor(context),
          ),
      onTap: onTap,
    );
  }

  // === USER PROFILE CARD ===
  Widget _buildUserProfileCard(BuildContext context) {
    return Container(
      padding: Constants.mediumPadding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.lightPrimary, AppColors.lightSecondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: Constants.mediumRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.lightPrimary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 36.sp,
              color: AppColors.lightPrimary,
            ),
          ),
          SizedBox(width: Constants.mediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أحمد محمد',
                  style: AppTextStyles.senBold18(
                    context,
                  ).copyWith(color: Colors.white),
                ),
                SizedBox(height: Constants.extraSmallSpacing),
                Text(
                  'ahmed.mohamed@example.com',
                  style: AppTextStyles.senRegular14(
                    context,
                  ).copyWith(color: Colors.white.withValues(alpha: 0.9)),
                ),
                SizedBox(height: Constants.extraSmallSpacing),
                Text(
                  'عضو منذ يناير 2024',
                  style: AppTextStyles.senRegular12(
                    context,
                  ).copyWith(color: Colors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _navigateToProfile(context),
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // === LOGOUT SECTION ===
  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Constants.smallSpacing),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: Constants.mediumRadius,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        leading: Icon(
          Icons.logout,
          color: AppColors.error,
          size: Constants.mediumIcon,
        ),
        title: Text(
          'تسجيل الخروج',
          style: AppTextStyles.senMedium16(
            context,
          ).copyWith(color: AppColors.error),
        ),
        subtitle: Text(
          'تسجيل الخروج من الحساب',
          style: AppTextStyles.senRegular12(
            context,
          ).copyWith(color: AppColors.error.withValues(alpha: 0.7)),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: AppColors.error,
        ),
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }

  // === NAVIGATION METHODS ===
  void _navigateToProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('فتح صفحة الملف الشخصي'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _navigateToOrderHistory(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('فتح تاريخ الطلبات'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _navigateToFavorites(BuildContext context) {
    // Navigate to favorites page in bottom navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('انتقل لتبويب المفضلة'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  // === DIALOG METHODS ===
  void _showPaymentMethods(BuildContext context) {
    DialogConstants.showPlatformAlert(
      context: context,
      title: 'طرق الدفع',
      content:
          'سيتم إضافة إدارة طرق الدفع قريباً.\n\nطرق الدفع المتوفرة حالياً:\n• الدفع النقدي عند التوصيل\n• البطاقات الائتمانية (قريباً)',
      primaryButtonText: 'حسناً',
    );
  }

  void _showNotificationSettings(BuildContext context) {
    DialogConstants.showPlatformAlert(
      context: context,
      title: 'إعدادات الإشعارات',
      content:
          'إعدادات الإشعارات:\n\n✅ إشعارات الطلبات\n✅ إشعارات العروض الخاصة\n✅ تحديثات حالة الطلب\n❌ إشعارات التسويق\n\nيمكنك تعديل هذه الإعدادات من إعدادات النظام.',
      primaryButtonText: 'حسناً',
    );
  }

  void _showLanguageOptions(BuildContext context) {
    DialogConstants.showPlatformAlert(
      context: context,
      title: 'اختيار اللغة',
      content:
          'اللغات المتوفرة:\n\n🇸🇦 العربية (الحالية)\n🇺🇸 English (قريباً)\n🇫🇷 Français (قريباً)',
      primaryButtonText: 'حسناً',
    );
  }

  void _showPrivacySettings(BuildContext context) {
    DialogConstants.showPlatformAlert(
      context: context,
      title: 'الخصوصية والأمان',
      content:
          'إعدادات الخصوصية والأمان:\n\n🔒 كلمة المرور\n📧 البريد الإلكتروني\n📱 المصادقة الثنائية (قريباً)\n🗑️ حذف البيانات\n\nجميع بياناتك محمية وفقاً لسياسة الخصوصية.',
      primaryButtonText: 'حسناً',
    );
  }

  void _showReviews(BuildContext context) {
    DialogConstants.showPlatformAlert(
      context: context,
      title: 'التقييمات والمراجعات',
      content:
          'تقييماتك السابقة:\n\n⭐⭐⭐⭐⭐ بيتزا مارجريتا\n⭐⭐⭐⭐ برجر الدجاج\n⭐⭐⭐⭐⭐ كاليفورنيا رول\n\nمتوسط تقييماتك: 4.7/5',
      primaryButtonText: 'حسناً',
    );
  }

  void _showHelpCenter(BuildContext context) {
    DialogConstants.showPlatformAlert(
      context: context,
      title: 'مركز المساعدة',
      content:
          'الأسئلة الشائعة:\n\n❓ كيف أضع طلبية؟\n❓ كيف أتتبع طلبي؟\n❓ كيف أغير عنوان التوصيل؟\n❓ ما هي أوقات التوصيل؟\n❓ كيف أتواصل مع الدعم؟\n\nللمزيد من المساعدة، تواصل معنا.',
      primaryButtonText: 'حسناً',
    );
  }

  void _showContactOptions(BuildContext context) {
    DialogConstants.showPlatformAlert(
      context: context,
      title: 'تواصل معنا',
      content:
          'طرق التواصل:\n\n📞 الهاتف: 920001234\n📧 البريد: support@restaurant.com\n💬 الواتساب: +966501234567\n🕐 ساعات العمل: 9 صباحاً - 12 منتصف الليل',
      primaryButtonText: 'حسناً',
    );
  }

  void _showFeedbackForm(BuildContext context) {
    DialogConstants.showPlatformAlert(
      context: context,
      title: 'إرسال ملاحظات',
      content:
          'نحن نقدر ملاحظاتك!\n\nساعدنا في تحسين التطبيق من خلال:\n• تقييم التطبيق في المتجر\n• إرسال اقتراحاتك\n• الإبلاغ عن المشاكل\n\nشكراً لك على دعمك!',
      primaryButtonText: 'حسناً',
    );
  }

  void _showAboutDialog(BuildContext context) {
    DialogConstants.showPlatformAlert(
      context: context,
      title: 'حول التطبيق',
      content:
          '🍕 تطبيق نظام المطعم\n📱 الإصدار 1.0.0\n🗓️ تاريخ الإصدار: يناير 2024\n\n📝 الوصف:\nتطبيق متكامل لطلب الطعام من المطعم مع إمكانيات متقدمة للطلب والتوصيل.\n\n👨‍💻 المطور: Restaurant System Team\n📧 البريد: dev@restaurant.com\n\n🔒 جميع الحقوق محفوظة © 2024',
      primaryButtonText: 'حسناً',
    );
  }

  void _showLogoutDialog(context) async {
    final result = await DialogConstants.showLogoutConfirmation(
      context: context,
    );

    if (result == true) {
      // Show loading dialog
      DialogConstants.showPlatformLoading(
        context: context,
        message: 'جاري تسجيل الخروج...',
      );

      // Simulate logout process
      await Future.delayed(const Duration(seconds: 2));

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Navigate to login page
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تسجيل الخروج بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }
}
