# Admin Feature

## نظرة عامة
هذا القسم يحتوي على جميع المكونات المتعلقة بواجهة الإدارة في تطبيق المطعم.

## البنية
```
admin/
├── domain/
│   └── entities/
│       ├── bottom_navigation_bar_entity.dart
│       └── index.dart
└── presentation/
    ├── pages/
    │   ├── admin.dart (الصفحة الرئيسية)
    │   ├── admin_home_page.dart (لوحة التحكم)
    │   ├── admin_menu_page.dart (إدارة القائمة)
    │   ├── admin_notifications_page.dart (الإشعارات)
    │   ├── admin_profile_page.dart (الملف الشخصي)
    │   ├── admin_add_item_page.dart (إضافة منتج)
    │   └── index.dart
    └── widgets/
        ├── custom_bottom_navigation_bar.dart
        ├── navigation_bar_item.dart
        ├── active_navigation_items.dart
        ├── not_active_navigation_items.dart
        └── index.dart
```

## المكونات الرئيسية

### 1. Navigation Bar
- **CustomBottomNavigationBar**: شريط التنقل المخصص
- **NavigationBarItem**: عنصر واحد في شريط التنقل
- **ActiveNavigationItems**: العناصر النشطة
- **NotActiveNavigationItems**: العناصر غير النشطة

### 2. الصفحات
- **AdminMainView**: الصفحة الرئيسية مع navigation bar
- **AdminHomePage**: لوحة التحكم مع الإحصائيات
- **AdminMenuPage**: إدارة المنتجات والقائمة
- **AdminNotificationsPage**: عرض الإشعارات
- **AdminProfilePage**: الملف الشخصي والإعدادات
- **AdminAddItemPage**: إضافة منتج جديد

### 3. Entities
- **BottomNavigationBarEntity**: كيان شريط التنقل

## الاستخدام

```dart
// استيراد الصفحة الرئيسية
import 'package:restaurant_system_flutter/features/admin/presentation/pages/admin.dart';

// استخدام الصفحة
AdminMainView()

// التوجيه باستخدام Routes
Navigator.pushNamed(context, AppRoutes.admin);
Navigator.pushNamed(context, AppRoutes.adminAddItem);
```

## المسارات المتاحة

- `/admin` - الصفحة الرئيسية للادمن
- `/admin/add-item` - صفحة إضافة منتج جديد

## الميزات
- ✅ Navigation bar مخصص مع أيقونات نشطة وغير نشطة
- ✅ 4 صفحات رئيسية (الرئيسية، القائمة، الإشعارات، الملف الشخصي)
- ✅ صفحة إضافة منتجات جديدة
- ✅ تصميم متجاوب ومتسق
- ✅ دعم اللغة العربية
- ✅ انتقالات سلسة بين الصفحات

## الأيقونات المستخدمة
- `assets/icons/active_icons/` - الأيقونات النشطة
- `assets/icons/notActive_icons/` - الأيقونات غير النشطة 