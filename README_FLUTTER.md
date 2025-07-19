# Restaurant System Flutter App

## إعداد الفرونت اند (Flutter)

### المتطلبات:
- Flutter 3.0+
- Dart 3.0+
- Android Studio / VS Code

### خطوات التشغيل:

1. **تثبيت الـ dependencies:**
```bash
flutter pub get
```

2. **تشغيل التطبيق:**
```bash
flutter run
```

### هيكل المشروع:

```
lib/
├── core/
│   ├── constants/
│   ├── di/
│   ├── error/
│   ├── network/
│   ├── routes/
│   ├── theme/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── menu/
│   ├── cart/
│   └── orders/
└── main.dart
```

### الـ API Integration:

#### الإعدادات:
- **Base URL:** `http://127.0.0.1:8000/api/v1`
- **Authentication:** Bearer Token
- **Error Handling:** Custom error messages

#### الـ Endpoints المستخدمة:
- `POST /auth/register` - تسجيل مستخدم جديد
- `POST /auth/login` - تسجيل الدخول
- `GET /user` - جلب بيانات المستخدم

### الـ Features:

#### Authentication:
- ✅ تسجيل الدخول
- ✅ تسجيل مستخدم جديد
- ✅ إدارة الـ tokens
- ✅ Error handling

#### Clean Architecture:
- ✅ Domain Layer (Entities, Use Cases)
- ✅ Data Layer (Models, Repositories)
- ✅ Presentation Layer (BLoC, Pages)

#### State Management:
- ✅ BLoC Pattern
- ✅ GetIt for Dependency Injection
- ✅ Flutter Secure Storage

### الـ Models:

#### UserModel:
```dart
class UserModel extends UserEntity {
  // Properties: id, email, name, phone, avatar, role, createdAt, updatedAt
  // Methods: fromJson, toJson, copyWith, fromEntity
}
```

#### AuthModel:
```dart
class AuthModel extends AuthEntity {
  // Properties: accessToken, refreshToken, user, expiresAt
  // Methods: fromJson, toJson, copyWith
}
```

### الـ Error Handling:

#### Custom Errors:
- `AuthFailure` - أخطاء الـ authentication
- `NetworkFailure` - أخطاء الشبكة
- `ServerFailure` - أخطاء الخادم

#### Error Messages:
- رسائل خطأ باللغة العربية
- تنسيق موحد للـ errors
- Logging للـ debugging

### الـ Testing:

#### تشغيل الـ tests:
```bash
flutter test
```

#### تشغيل الـ integration tests:
```bash
flutter test integration_test/
```

### الـ Build:

#### Android:
```bash
flutter build apk
```

#### iOS:
```bash
flutter build ios
```

#### Web:
```bash
flutter build web
```

### ملاحظات مهمة:

1. **تأكد من تشغيل Laravel API** قبل تشغيل Flutter
2. **الـ API يجب أن يعمل على** `http://127.0.0.1:8000`
3. **للـ Android Emulator** استخدم `10.0.2.2:8000`
4. **للـ iOS Simulator** استخدم `127.0.0.1:8000`

### Troubleshooting:

#### مشاكل الشبكة:
- تأكد من تشغيل Laravel server
- تحقق من الـ firewall
- جرب `flutter clean` ثم `flutter pub get`

#### مشاكل الـ Dependencies:
```bash
flutter clean
flutter pub get
flutter pub upgrade
``` 