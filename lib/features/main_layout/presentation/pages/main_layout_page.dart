import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../Home/presentation/pages/home_page.dart';
import '../../../address/presentation/pages/address_page.dart';
import '../../../favorites/presentation/pages/favorites_page.dart';
import '../../../orders/presentation/pages/my_orders_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({super.key});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MyOrdersPage(),
    const AddressPage(),
    const FavoritesPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: ThemeHelper.getSurfaceColor(context),
          selectedItemColor: ThemeHelper.getPrimaryColor(),
          unselectedItemColor: ThemeHelper.getSecondaryTextColor(context),
          selectedFontSize: 10.sp,
          unselectedFontSize: 10.sp,
          elevation: 0,
          items: [
            _buildBottomNavigationBarItem(
              activeIcon: AppImages.homeActive,
              inactiveIcon: AppImages.homeInactive,
              label: 'الرئيسية',
              index: 0,
            ),
            _buildBottomNavigationBarItem(
              activeIcon: Icons.receipt_long,
              inactiveIcon: Icons.receipt_long_outlined,
              label: 'طلباتي',
              index: 1,
            ),
            _buildBottomNavigationBarItem(
              activeIcon: Icons.location_on,
              inactiveIcon: Icons.location_on_outlined,
              label: 'العناوين',
              index: 2,
            ),
            _buildBottomNavigationBarItem(
              activeIcon: Icons.favorite,
              inactiveIcon: Icons.favorite_outline,
              label: 'المفضلة',
              index: 3,
            ),
            _buildBottomNavigationBarItem(
              activeIcon: Icons.settings,
              inactiveIcon: Icons.settings_outlined,
              label: 'الإعدادات',
              index: 4,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required dynamic activeIcon,
    required dynamic inactiveIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    Widget iconWidget;
    if (activeIcon is String && inactiveIcon is String) {
      // For image assets
      iconWidget = Image.asset(
        isSelected ? activeIcon : inactiveIcon,
        width: 24.w,
        height: 24.h,
        color: isSelected
            ? ThemeHelper.getPrimaryColor()
            : ThemeHelper.getSecondaryTextColor(context),
      );
    } else {
      // For IconData
      iconWidget = Icon(
        isSelected ? activeIcon : inactiveIcon,
        size: 24.sp,
        color: isSelected
            ? ThemeHelper.getPrimaryColor()
            : ThemeHelper.getSecondaryTextColor(context),
      );
    }

    return BottomNavigationBarItem(icon: iconWidget, label: label);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
