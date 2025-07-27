# 🔗 الارتباط بين تطبيق الأدمن وتطبيق المستخدم

## 📊 نظرة سريعة على النظام

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   User App      │    │   API Server    │    │   Admin App     │
│   (تطبيق المستخدم)  │    │   (الخادم)       │    │   (تطبيق الأدمن)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │ 1. إنشاء طلب جديد    │                       │
         ├───────────────────────►│                       │
         │                       │ 2. حفظ في قاعدة البيانات │
         │                       ├───────────────────────►│
         │                       │                       │ 3. عرض الطلب
         │                       │                       │ في لوحة التحكم
         │                       │                       │
         │                       │ 4. تحديث الحالة      │
         │                       │◄──────────────────────┤
         │ 5. إشعار المستخدم     │                       │
         │◄──────────────────────┤                       │
```

## 🎯 حالات الطلب والارتباط

### 📱 **في تطبيق المستخدم (User App)**

| الحالة | ما يرى المستخدم | الإجراء المطلوب |
|--------|-----------------|-----------------|
| **جديد** | "طلبك قيد المعالجة" | انتظار |
| **قيد التحضير** | "جاري تحضير طلبك" | انتظار |
| **جاهز** | "طلبك جاهز للاستلام" | الذهاب للمطعم |
| **مكتمل** | "تم تسليم طلبك" | تقييم الطلب |
| **ملغي** | "تم إلغاء طلبك" | طلب جديد |

### 🏪 **في تطبيق الأدمن (Admin App)**

| الحالة | ما يرى الأدمن | الإجراء المطلوب |
|--------|---------------|-----------------|
| **جديد** | يظهر في "New Orders" | بدء التحضير |
| **قيد التحضير** | يظهر في "Active Orders" | إكمال التحضير |
| **جاهز** | يظهر في "Ready Orders" | تسليم للعميل |
| **مكتمل** | يظهر في "Completed" | أرشفة |
| **ملغي** | يظهر في "Cancelled" | إشعار العميل |

## 🔄 تدفق البيانات

### 1️⃣ **إنشاء طلب جديد**
```dart
// User App
POST /api/orders
{
  "customer_id": 123,
  "items": [
    {"food_id": 1, "quantity": 2},
    {"food_id": 3, "quantity": 1}
  ],
  "total": 45.0,
  "status": "new"
}
```

### 2️⃣ **عرض الطلب في الأدمن**
```dart
// Admin App - يتم تحديث تلقائياً
GET /api/orders/new
Response: [
  {
    "id": 12345,
    "customer_name": "أحمد محمد",
    "items": [...],
    "total": 45.0,
    "status": "new",
    "created_at": "2024-01-15T10:30:00Z"
  }
]
```

### 3️⃣ **تحديث حالة الطلب**
```dart
// Admin App
PUT /api/orders/12345/status
{
  "status": "preparing"
}
```

### 4️⃣ **إشعار المستخدم**
```dart
// User App - يتم تحديث تلقائياً
GET /api/orders/12345
Response: {
  "id": 12345,
  "status": "preparing",
  "estimated_time": "15 minutes"
}
```

## 📱 الميزات المنجزة

### ✅ **تطبيق الأدمن**
- [x] عرض الطلبات النشطة والجديدة
- [x] Bottom Sheet لإدارة الطلبات
- [x] أزرار Done/Cancel
- [x] تحديث تلقائي للقائمة
- [x] رسائل نجاح وخطأ

### ✅ **تطبيق المستخدم**
- [x] إنشاء طلبات جديدة
- [x] تتبع حالة الطلب
- [x] عرض تاريخ الطلبات
- [x] إشعارات التحديثات

## 🚀 الميزات المستقبلية

### 📈 **Real-time Updates**
```dart
// WebSocket Connection
ws://api.restaurant.com/orders/updates
{
  "order_id": 12345,
  "status": "ready",
  "timestamp": "2024-01-15T10:45:00Z"
}
```

### 🔔 **Push Notifications**
```dart
// إشعارات فورية
{
  "title": "طلب جديد",
  "body": "طلب #12345 من أحمد محمد",
  "data": {"order_id": 12345}
}
```

### 📊 **Analytics Dashboard**
```dart
// إحصائيات الطلبات
{
  "total_orders": 150,
  "active_orders": 12,
  "completed_today": 45,
  "average_preparation_time": "12 minutes"
}
```

## 🔧 التكوين المطلوب

### 📡 **API Endpoints**
```yaml
# في ملف pubspec.yaml
dependencies:
  dio: ^5.0.0
  flutter_bloc: ^8.1.3
  web_socket_channel: ^2.4.0
```

### 🔐 **Authentication**
```dart
// Bearer Token
headers: {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
}
```

### 🗄️ **Database Schema**
```sql
-- جدول الطلبات
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  customer_id INTEGER,
  status VARCHAR(20),
  total DECIMAL(10,2),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

## 📞 الدعم

لأي استفسارات أو مشاكل:
- 📧 Email: support@restaurant.com
- 📱 WhatsApp: +966-50-123-4567
- 🐛 GitHub Issues: [Report Bug](https://github.com/restaurant-system/issues)

---

**تم التطوير بواسطة فريق Restaurant System** 🍕 