# دليل إعدادات iOS - Restaurant System Flutter

## الإعدادات المطلوبة لـ iOS

### 1. الأذونات (Permissions) في Info.plist

تم إضافة الأذونات التالية:

```xml
<!-- إذن الكاميرا لمسح QR codes -->
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes</string>

<!-- إذن Face ID للتخزين الآمن -->
<key>NSFaceIDUsageDescription</key>
<string>This app uses Face ID for secure authentication</string>
```

### 2. إعدادات الشبكة

```xml
<!-- السماح بالاتصال بـ HTTP (للتطوير) -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 3. ملف Entitlements

تم إنشاء ملف `Runner.entitlements` للسماح بالتخزين الآمن:

```xml
<key>keychain-access-groups</key>
<array>
    <string>$(AppIdentifierPrefix)com.example.restaurantSystemFlutter</string>
</array>
```

### 4. إعدادات Xcode Project

تم تحديث إعدادات المشروع لتشمل:
- `CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements`
- Bundle Identifier: `com.example.restaurantSystemFlutter`

## الأذونات المطلوبة حسب الـ Packages

### flutter_secure_storage
- ✅ تم إضافة keychain access groups
- ✅ تم إضافة Face ID usage description

### qr_code_scanner_plus
- ✅ تم إضافة camera usage description

### camera
- ✅ تم إضافة camera usage description

### pusher_channels_flutter
- ✅ تم إضافة NSAllowsArbitraryLoads للاتصال بـ WebSocket

## خطوات إضافية مطلوبة

### 1. تحديث Bundle Identifier
يجب تغيير `com.example.restaurantSystemFlutter` إلى معرف فريد خاص بك:
- في Xcode: Runner > General > Bundle Identifier
- في ملف project.pbxproj

### 2. إعدادات التوقيع (Code Signing)
- إضافة Apple Developer Account
- إنشاء Provisioning Profile
- إعداد Team ID

### 3. إعدادات Push Notifications (إذا لزم الأمر)
إذا كنت تخطط لاستخدام الإشعارات، أضف:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
```

### 4. إعدادات App Store Connect
- إعداد App Information
- إضافة App Icons
- إعداد App Review Information

## ملاحظات مهمة

1. **NSAllowsArbitraryLoads**: يجب إزالته في الإنتاج واستخدام HTTPS فقط
2. **Bundle Identifier**: يجب أن يكون فريداً ولا يتطابق مع تطبيقات أخرى
3. **Entitlements**: مطلوب للتخزين الآمن والـ keychain access
4. **Camera Permission**: مطلوب لمسح QR codes

## اختبار الإعدادات

```bash
# تنظيف المشروع
flutter clean

# الحصول على dependencies
flutter pub get

# بناء المشروع لـ iOS
flutter build ios

# تشغيل على محاكي iOS
flutter run -d ios
```

## استكشاف الأخطاء

### مشاكل شائعة:
1. **Code Signing Error**: تأكد من إعداد Team ID
2. **Camera Permission Denied**: تأكد من وجود NSCameraUsageDescription
3. **Keychain Access Error**: تأكد من وجود entitlements file
4. **Network Error**: تأكد من إعدادات NSAppTransportSecurity

### حلول:
- تنظيف المشروع: `flutter clean && flutter pub get`
- إعادة بناء: `flutter build ios --release`
- فحص logs: `flutter logs`
