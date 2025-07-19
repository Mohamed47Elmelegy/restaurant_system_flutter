# API Debugging Guide

## المشاكل المحتملة وحلولها:

### 1. **مشكلة الاتصال بالشبكة**

#### للأندرويد Emulator:
```dart
// استخدم هذا URL
static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
```

#### للـ iOS Simulator:
```dart
// استخدم هذا URL
static const String baseUrl = 'http://127.0.0.1:8000/api/v1';
```

#### للويب:
```dart
// استخدم هذا URL
static const String baseUrl = 'http://localhost:8000/api/v1';
```

### 2. **تأكد من تشغيل Laravel Server**

```bash
cd restaurant-system_laravel
php artisan serve --host=0.0.0.0 --port=8000
```

### 3. **اختبار الـ API مباشرة**

#### باستخدام curl:
```bash
# Test register
curl -X POST http://127.0.0.1:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'

# Test login
curl -X POST http://127.0.0.1:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

#### باستخدام Postman:
- **URL:** `http://127.0.0.1:8000/api/v1/auth/register`
- **Method:** POST
- **Body:** JSON
```json
{
  "name": "Test User",
  "email": "test@example.com",
  "password": "password123"
}
```

### 4. **فحص الـ Logs**

#### في Flutter:
افتح Debug Console وابحث عن:
- 🔵 (Request logs)
- 🟢 (Response logs)
- 🔴 (Error logs)

#### في Laravel:
```bash
tail -f storage/logs/laravel.log
```

### 5. **مشاكل شائعة وحلولها**

#### مشكلة CORS:
أضف في Laravel `config/cors.php`:
```php
'paths' => ['api/*'],
'allowed_methods' => ['*'],
'allowed_origins' => ['*'],
'allowed_origins_patterns' => [],
'allowed_headers' => ['*'],
'exposed_headers' => [],
'max_age' => 0,
'supports_credentials' => false,
```

#### مشكلة Network Security:
أضف في `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:usesCleartextTraffic="true"
    ...>
```

#### مشكلة iOS Network:
أضف في `ios/Runner/Info.plist`:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 6. **اختبار سريع**

شغل هذا الكود في Flutter:
```dart
import 'package:dio/dio.dart';

void testAPI() async {
  final dio = Dio();
  dio.options.baseUrl = 'http://10.0.2.2:8000/api/v1';
  
  try {
    final response = await dio.post('/auth/register', data: {
      'name': 'Test',
      'email': 'test@test.com',
      'password': '123456'
    });
    print('Success: ${response.data}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### 7. **خطوات التشخيص**

1. ✅ تأكد من تشغيل Laravel server
2. ✅ تأكد من صحة الـ URL
3. ✅ تأكد من صحة الـ database
4. ✅ تأكد من تشغيل الـ migrations
5. ✅ اختبر الـ API خارج Flutter
6. ✅ راجع الـ logs في Flutter
7. ✅ راجع الـ logs في Laravel

### 8. **أوامر مفيدة**

```bash
# Laravel
php artisan config:clear
php artisan cache:clear
php artisan route:list
php artisan migrate:status

# Flutter
flutter clean
flutter pub get
flutter run --verbose
``` 