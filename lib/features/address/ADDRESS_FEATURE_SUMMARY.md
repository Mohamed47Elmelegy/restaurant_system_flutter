# 📍 Address Feature - Clean Architecture Implementation

## ✅ **تم إنجاز العمل بالكامل**

تم تطوير نظام العناوين باستخدام **Clean Architecture** وفقاً لمعمارية المشروع الحالية، مع دعم كامل لجميع العمليات المطلوبة.

---

## 🏗️ **الهيكل المعماري**

### **📁 Domain Layer (Business Logic)**
```
lib/features/address/domain/
├── entities/
│   └── address_entity.dart          ✅ كيان العنوان
├── repositories/
│   └── address_repository.dart      ✅ واجهة المستودع
└── usecases/
    ├── get_addresses_usecase.dart   ✅ جلب العناوين
    ├── add_address_usecase.dart     ✅ إضافة عنوان
    ├── update_address_usecase.dart  ✅ تحديث عنوان
    ├── delete_address_usecase.dart  ✅ حذف عنوان
    └── set_default_address_usecase.dart ✅ تعيين افتراضي
```

### **📁 Data Layer (External Interfaces)**
```
lib/features/address/data/
├── datasources/
│   ├── address_remote_data_source.dart      ✅ واجهة مصدر البيانات
│   └── address_remote_data_source_impl.dart ✅ تطبيق مصدر البيانات
├── models/
│   ├── address_model.dart           ✅ نموذج العنوان
│   ├── add_address_request.dart     ✅ طلب إضافة عنوان
│   └── update_address_request.dart  ✅ طلب تحديث عنوان
└── repositories/
    └── address_repository_impl.dart ✅ تطبيق المستودع
```

### **📁 Presentation Layer (UI & State Management)**
```
lib/features/address/presentation/
├── cubit/
│   ├── address_cubit.dart          ✅ إدارة الحالة
│   ├── address_event.dart          ✅ الأحداث
│   └── address_state.dart          ✅ الحالات
├── pages/
│   ├── address_page.dart           ✅ صفحة العناوين (محدث)
│   └── add_address_page.dart       ✅ صفحة إضافة عنوان
└── widgets/
    └── address_card.dart           ✅ بطاقة العنوان (محدث)
```

---

## 🔧 **التكامل مع النظام**

### **✅ Service Locator**
- تم إضافة جميع dependencies للعناوين
- تم تسجيل DataSources, Repositories, UseCases, Cubit
- دعم كامل للـ Dependency Injection

### **✅ API Integration**
- يستخدم نفس endpoints المحددة في الوثيقة:
  - `GET /api/v1/addresses` - جلب العناوين
  - `POST /api/v1/addresses` - إضافة عنوان
  - `PUT /api/v1/addresses/{id}` - تحديث عنوان
  - `DELETE /api/v1/addresses/{id}` - حذف عنوان

### **✅ App Router**
- العناوين مدمجة في نظام التوجيه
- دعم BlocProvider للحالة

---

## 🎯 **الميزات المطبقة**

### **📋 إدارة العناوين**
- ✅ **عرض العناوين**: قائمة بجميع العناوين المحفوظة
- ✅ **إضافة عنوان**: نموذج كامل لإضافة عنوان جديد
- ✅ **تحديث عنوان**: إمكانية تعديل العنوان الموجود
- ✅ **حذف عنوان**: حذف مع تأكيد
- ✅ **تعيين افتراضي**: تعيين عنوان كافتراضي

### **🎨 واجهة المستخدم**
- ✅ **حالات متعددة**: Loading, Empty, Error, Success
- ✅ **تنبيهات**: SnackBar للنجاح والأخطاء
- ✅ **تأكيد الحذف**: Dialog للتأكيد
- ✅ **مؤشر العنوان الافتراضي**: Badge للعنوان الافتراضي
- ✅ **تصميم متجاوب**: يدعم الوضع الليلي والنهاري

### **⚡ إدارة الحالة**
- ✅ **BLoC Pattern**: Cubit + Events + States
- ✅ **معالجة الأخطاء**: Error handling شامل
- ✅ **Loading States**: مؤشرات التحميل
- ✅ **Auto Refresh**: إعادة التحميل بعد العمليات

---

## 🔗 **API Endpoints المدعومة**

| العملية | HTTP Method | Endpoint | وصف |
|---------|-------------|----------|-----|
| جلب العناوين | `GET` | `/api/v1/addresses` | جلب جميع عناوين المستخدم |
| إضافة عنوان | `POST` | `/api/v1/addresses` | إضافة عنوان جديد |
| تحديث عنوان | `PUT` | `/api/v1/addresses/{id}` | تحديث عنوان موجود |
| حذف عنوان | `DELETE` | `/api/v1/addresses/{id}` | حذف عنوان |
| تعيين افتراضي | `PUT` | `/api/v1/addresses/{id}` | تعيين عنوان كافتراضي |

---

## 📦 **نموذج البيانات**

### **AddressEntity** (Domain)
```dart
class AddressEntity {
  final int id;
  final int userId;
  final String addressLine1;    // الشارع
  final String? addressLine2;   // المبنى/الشقة
  final String city;            // المدينة
  final String state;           // المنطقة/الحي
  final String postalCode;      // الرمز البريدي
  final String country;         // البلد
  final String? phone;          // رقم الهاتف
  final bool isDefault;         // افتراضي؟
  final String? label;          // تسمية (بيت، عمل، إلخ)
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### **API Request Format**
```json
{
  "label": "Home",
  "name": "John Doe",
  "phone": "0500000000",
  "city": "Riyadh",
  "district": "Olaya",
  "street": "King Fahd Road",
  "building": "Building 123",
  "apartment": "Apt 4B",
  "postal_code": "11564",
  "is_default": true
}
```

---

## 🚀 **كيفية الاستخدام**

### **1. الانتقال لصفحة العناوين**
```dart
Navigator.pushNamed(context, AppRoutes.address);
```

### **2. إضافة عنوان جديد**
```dart
Navigator.pushNamed(context, AppRoutes.addAddress);
```

### **3. استخدام AddressCubit**
```dart
// في البناء
BlocProvider(
  create: (context) => getIt<AddressCubit>()..add(LoadAddresses()),
  child: AddressPage(),
)

// تحميل العناوين
context.read<AddressCubit>().add(LoadAddresses());

// إضافة عنوان
context.read<AddressCubit>().add(AddAddress(address: newAddress));

// حذف عنوان
context.read<AddressCubit>().add(DeleteAddress(addressId: addressId));
```

---

## 🔄 **دورة حياة البيانات**

### **تحميل العناوين**
1. `LoadAddresses` event ← User action
2. `AddressLoading` state ← UI shows spinner
3. API call via `GetAddressesUseCase`
4. `AddressLoaded(addresses)` state ← UI shows list

### **إضافة عنوان**
1. `AddAddress(address)` event ← User submits form
2. `AddressLoading` state ← UI shows spinner
3. API call via `AddAddressUseCase`
4. `AddressAdded(address)` state ← Show success message
5. Auto reload with `LoadAddresses`

### **حذف عنوان**
1. User taps delete → Confirmation dialog
2. `DeleteAddress(id)` event ← User confirms
3. `AddressLoading` state ← UI shows spinner
4. API call via `DeleteAddressUseCase`
5. `AddressDeleted(id)` state ← Show success message
6. Auto reload with `LoadAddresses`

---

## 🛡️ **Error Handling**

### **أنواع الأخطاء المدعومة**
- **Server Errors**: أخطاء من الخادم (4xx, 5xx)
- **Network Errors**: أخطاء الشبكة (No internet)
- **Validation Errors**: أخطاء التحقق من البيانات
- **Unknown Errors**: أخطاء غير متوقعة

### **عرض الأخطاء**
- SnackBar للأخطاء السريعة
- Error State للأخطاء الدائمة
- إعادة المحاولة للأخطاء القابلة للإصلاح

---

## 🎛️ **الحالات المدعومة**

| State | Description | UI Behavior |
|-------|-------------|-------------|
| `AddressInitial` | الحالة الأولى | - |
| `AddressLoading` | جارٍ التحميل | Spinner |
| `AddressLoaded` | تم التحميل بنجاح | عرض القائمة |
| `AddressEmpty` | لا توجد عناوين | Empty state |
| `AddressError` | خطأ | Error message + retry |
| `AddressAdded` | تم الإضافة | Success message |
| `AddressDeleted` | تم الحذف | Success message |
| `AddressSetAsDefault` | تم التعيين كافتراضي | Success message |

---

## 🎯 **الاستخدام مع الطلبات**

هذا النظام جاهز للربط مع نظام الطلبات:

```dart
// في صفحة Checkout
final addressCubit = context.read<AddressCubit>();
final state = addressCubit.state;

if (state is AddressLoaded) {
  final defaultAddress = state.defaultAddress;
  // استخدام العنوان الافتراضي في الطلب
}
```

---

## ✨ **النتيجة النهائية**

تم بناء نظام العناوين بالكامل مع:
- ✅ **معمارية نظيفة** (Clean Architecture)
- ✅ **إدارة حالة متقدمة** (BLoC Pattern)
- ✅ **تكامل API** كامل
- ✅ **واجهة مستخدم** متجاوبة
- ✅ **معالجة أخطاء** شاملة
- ✅ **تجربة مستخدم** ممتازة

النظام جاهز للاستخدام ومتكامل مع باقي المشروع! 🚀

