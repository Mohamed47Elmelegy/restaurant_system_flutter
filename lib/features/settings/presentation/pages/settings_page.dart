import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/theme_helper.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';

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
        padding: EdgeInsets.all(16.w),
        children: [
          _buildSettingsSection(context, 'الحساب', [
            _buildSettingsTile(
              context,
              icon: Icons.person_outline,
              title: 'الملف الشخصي',
              subtitle: 'إدارة معلومات حسابك',
              onTap: () {
                // Navigate to profile page
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.notifications_outlined,
              title: 'الإشعارات',
              subtitle: 'إعدادات الإشعارات والتنبيهات',
              onTap: () {
                // Navigate to notifications settings
              },
            ),
          ]),
          SizedBox(height: 24.h),
          _buildSettingsSection(context, 'التطبيق', [
            _buildSettingsTile(
              context,
              icon: Icons.dark_mode_outlined,
              title: 'المظهر',
              subtitle: 'تغيير بين الوضع الفاتح والداكن',
              trailing: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Switch(
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: AppColors.lightPrimary,
                  );
                },
              ),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.language_outlined,
              title: 'اللغة',
              subtitle: 'العربية',
              onTap: () {
                // Navigate to language settings
              },
            ),
          ]),
          SizedBox(height: 24.h),
          _buildSettingsSection(context, 'المساعدة والدعم', [
            _buildSettingsTile(
              context,
              icon: Icons.help_outline,
              title: 'المساعدة',
              subtitle: 'الأسئلة الشائعة والدعم',
              onTap: () {
                // Navigate to help page
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.info_outline,
              title: 'حول التطبيق',
              subtitle: 'معلومات حول التطبيق',
              onTap: () {
                // Show about dialog
                _showAboutDialog(context);
              },
            ),
          ]),
          SizedBox(height: 24.h),
          _buildSettingsTile(
            context,
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            subtitle: 'تسجيل الخروج من الحساب',
            titleColor: Colors.red,
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
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

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حول التطبيق', style: AppTextStyles.senBold16(context)),
        content: Text(
          'تطبيق المطعم\nالإصدار 1.0.0\n\nتطبيق لطلب الطعام من المطعم',
          style: AppTextStyles.senRegular14(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'حسناً',
              style: AppTextStyles.senMedium14(
                context,
              ).copyWith(color: AppColors.lightPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تسجيل الخروج', style: AppTextStyles.senBold16(context)),
        content: Text(
          'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          style: AppTextStyles.senRegular14(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: AppTextStyles.senMedium14(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle logout logic here
            },
            child: Text(
              'تسجيل الخروج',
              style: AppTextStyles.senMedium14(
                context,
              ).copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
