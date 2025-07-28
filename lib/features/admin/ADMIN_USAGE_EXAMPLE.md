# مثال استخدام نظام الادمن

## 1. إضافة التوجيه في main.dart

```dart
import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant System',
      onGenerateRoute: appRouter,
      initialRoute: AppRoutes.splash,
    );
  }
}
```

## 2. الانتقال إلى صفحة الادمن

```dart
// من أي صفحة في التطبيق
Navigator.pushNamed(context, AppRoutes.admin);
```

## 3. الانتقال إلى صفحة إضافة منتج

```dart
// من صفحة القائمة
Navigator.pushNamed(context, AppRoutes.adminAddItem);
```

## 4. إضافة زر للانتقال إلى الادمن

```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, AppRoutes.admin);
  },
  child: Text('لوحة الإدارة'),
)
```

## 5. استخدام في صفحة تسجيل الدخول

```dart
// في صفحة تسجيل الدخول، بعد التحقق من نوع المستخدم
if (userType == 'admin') {
  Navigator.pushReplacementNamed(context, AppRoutes.admin);
} else {
  Navigator.pushReplacementNamed(context, AppRoutes.home);
}
```

## 6. إضافة في قائمة التنقل الرئيسية

```dart
// في القائمة الجانبية أو أي مكان آخر
ListTile(
  leading: Icon(Icons.admin_panel_settings),
  title: Text('لوحة الإدارة'),
  onTap: () {
    Navigator.pushNamed(context, AppRoutes.admin);
  },
)
```

## 7. حماية الصفحات (للادمن فقط)

```dart
// في صفحة الادمن، التحقق من الصلاحيات
class AdminMainView extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    // التحقق من أن المستخدم هو ادمن
    if (!isAdmin) {
      return Scaffold(
        body: Center(
          child: Text('غير مصرح لك بالوصول لهذه الصفحة'),
        ),
      );
    }
    
    return Scaffold(
      // محتوى الصفحة
    );
  }
}
``` 