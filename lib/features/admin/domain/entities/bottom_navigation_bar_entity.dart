import '../../../../core/constants/app_images.dart';

class BottomNavigationBarEntity {
  final String activeImage, notActiveImage;
  final String name;

  BottomNavigationBarEntity({
    required this.activeImage,
    required this.notActiveImage,
    required this.name,
  });
}

List<BottomNavigationBarEntity> get bottomNavigationBarItems => [
  BottomNavigationBarEntity(
    activeImage: AppImages.homeActive,
    notActiveImage: AppImages.homeInactive,
    name: 'الرئيسية',
  ),
  BottomNavigationBarEntity(
    activeImage: AppImages.menuActive,
    notActiveImage: AppImages.menuInactive,
    name: 'القائمة',
  ),
  BottomNavigationBarEntity(
    activeImage: AppImages.notificationsActive,
    notActiveImage: AppImages.notificationsInactive,
    name: 'الإشعارات',
  ),
  BottomNavigationBarEntity(
    activeImage: AppImages.userActive,
    notActiveImage: AppImages.userInactive,
    name: 'حسابي',
  ),
];
