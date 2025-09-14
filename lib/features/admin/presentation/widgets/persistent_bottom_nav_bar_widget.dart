import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../pages/Profile/presentation/pages/admin_profile_page.dart';
import '../pages/menu/presentation/pages/admin_menu_page.dart';
import '../pages/notifications/presentation/pages/admin_notifications_page.dart';
import 'plus_button_widget.dart';

class PersistentBottomNavBarWidget extends StatefulWidget {
  const PersistentBottomNavBarWidget({super.key});

  @override
  State<PersistentBottomNavBarWidget> createState() =>
      _PersistentBottomNavBarWidgetState();
}

class _PersistentBottomNavBarWidgetState
    extends State<PersistentBottomNavBarWidget> {
  int selectedIndex = 0;

  final List<Widget> _pages = [
    //const SellerDashboardHome(),
    const AdminMenuPage(),
    const AdminNotificationsPage(),
    const AdminProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: _pages),
      bottomNavigationBar: _buildCustomNavBar(),
    );
  }

  Widget _buildCustomNavBar() {
    return Container(
      height: 65.h,
      decoration: ShapeDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        shadows: ThemeHelper.getCardShadow(context),
      ),
      child: Row(
        children: [
          // Left side items (2 items)
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _onItemTapped(0),
              child: SizedBox(
                height: 65.h,
                child: _buildNavItem(
                  activeImage: AppImages.homeActive,
                  notActiveImage: AppImages.homeInactive,
                  text: 'الرئيسية',
                  isSelected: selectedIndex == 0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _onItemTapped(1),
              child: SizedBox(
                height: 65.h,
                child: _buildNavItem(
                  activeImage: AppImages.menuActive,
                  notActiveImage: AppImages.menuInactive,
                  text: 'القائمة',
                  isSelected: selectedIndex == 1,
                ),
              ),
            ),
          ),

          // Plus button in the middle
          Expanded(
            flex: 2,
            child: Center(
              child: PlusButtonWidget(
                onPressed: () {
                  Navigator.pushNamed(context, '/admin/add-item');
                },
              ),
            ),
          ),

          // Right side items (2 items)
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _onItemTapped(2),
              child: SizedBox(
                height: 65.h,
                child: _buildNavItem(
                  activeImage: AppImages.notificationsActive,
                  notActiveImage: AppImages.notificationsInactive,
                  text: 'الإشعارات',
                  isSelected: selectedIndex == 2,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _onItemTapped(3),
              child: SizedBox(
                height: 65.h,
                child: _buildNavItem(
                  activeImage: AppImages.userActive,
                  notActiveImage: AppImages.userInactive,
                  text: 'حسابي',
                  isSelected: selectedIndex == 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String activeImage,
    required String notActiveImage,
    required String text,
    required bool isSelected,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: isSelected
          ? ShapeDecoration(
              color: ThemeHelper.getPrimaryColorForTheme(
                context,
              ).withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24.w,
            height: 24.h,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Center(
              child: Image.asset(
                isSelected ? activeImage : notActiveImage,
                width: 16.w,
                height: 16.h,
              ),
            ),
          ),
          if (isSelected) ...[
            SizedBox(height: 2.h),
            Text(
              text,
              style: AppTextStyles.senBold14(context).copyWith(
                fontSize: 10,
                color: ThemeHelper.getPrimaryTextColor(context),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
