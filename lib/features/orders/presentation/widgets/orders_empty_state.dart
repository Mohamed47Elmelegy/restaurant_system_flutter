import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';

/// Empty state widget for different order tabs
class OrdersEmptyState extends StatelessWidget {
  final String tabName;

  const OrdersEmptyState({super.key, required this.tabName});

  @override
  Widget build(BuildContext context) {
    final config = _getEmptyStateConfig(tabName);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            config.icon,
            size: 80.sp,
            color: ThemeHelper.getSecondaryTextColor(
              context,
            ).withValues(alpha: 0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            config.title,
            style: AppTextStyles.senBold16(
              context,
            ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          ),
          SizedBox(height: 8.h),
          Text(
            config.subtitle,
            style: AppTextStyles.senRegular14(
              context,
            ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
            textAlign: TextAlign.center,
          ),
          if (config.showActionButton) ...[
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.mainLayout),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPrimary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'ابدأ الطلب',
                style: AppTextStyles.senMedium14(
                  context,
                ).copyWith(color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }

  _EmptyStateConfig _getEmptyStateConfig(String tabName) {
    switch (tabName) {
      case 'نشطة':
        return const _EmptyStateConfig(
          title: 'لا توجد طلبات نشطة',
          subtitle: 'عندما تقوم بطلب شيء، ستظهر هنا',
          icon: Icons.shopping_cart_outlined,
          showActionButton: true,
        );
      case 'مكتملة':
        return const _EmptyStateConfig(
          title: 'لا توجد طلبات مكتملة',
          subtitle: 'ستظهر هنا الطلبات التي تم إنجازها',
          icon: Icons.check_circle_outline,
          showActionButton: false,
        );
      case 'ملغية':
        return const _EmptyStateConfig(
          title: 'لا توجد طلبات ملغية',
          subtitle: 'الطلبات الملغية ستظهر هنا',
          icon: Icons.cancel_outlined,
          showActionButton: false,
        );
      default:
        return const _EmptyStateConfig(
          title: 'لا توجد طلبات',
          subtitle: 'لا توجد طلبات في هذا القسم',
          icon: Icons.inbox_outlined,
          showActionButton: false,
        );
    }
  }
}

class _EmptyStateConfig {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool showActionButton;

  const _EmptyStateConfig({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.showActionButton,
  });
}
