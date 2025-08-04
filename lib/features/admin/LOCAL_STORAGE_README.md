# 🗄️ نظام التخزين المحلي باستخدام Hive

## 📋 نظرة عامة

تم إنشاء نظام تخزين محلي شامل لجميع صفحات الإدارة باستخدام **Hive** لتوفير:
- **سرعة الاستجابة** - البيانات متاحة فوراً
- **توفير البيانات** - تقليل استهلاك الإنترنت
- **العمل بدون إنترنت** - إمكانية العمل offline
- **إدارة الـ Cache** - صلاحية محددة للبيانات

## 🏗️ البنية المعمارية

### 📁 Local DataSources

```
lib/features/admin/presentation/pages/
├── add_items/
│   └── data/datasources/
│       └── product_local_data_source.dart ✅
├── add_category/
│   └── data/datasources/
│       └── category_local_data_source.dart ✅
├── menu/
│   └── data/datasources/
│       └── menu_local_data_source.dart ✅
├── meal_times/
│   └── data/datasources/
│       └── meal_time_local_data_source.dart ✅
└── dashbord/
    └── data/datasources/
        └── dashboard_local_data_source.dart ✅
```

## 🔧 الميزات المتاحة

### 1. **ProductLocalDataSource** - المنتجات
- ✅ حفظ المنتجات محلياً
- ✅ جلب المنتجات من التخزين المحلي
- ✅ البحث في المنتجات
- ✅ جلب المنتجات حسب الفئة
- ✅ جلب المنتجات المميزة
- ✅ تحديث حالة توفر المنتج
- ⏰ مدة الـ cache: 2 ساعة

### 2. **CategoryLocalDataSource** - الفئات
- ✅ حفظ الفئات الرئيسية والفرعية
- ✅ جلب الفئات النشطة فقط
- ✅ البحث في الفئات
- ✅ تحديث حالة نشاط الفئة
- ✅ جلب الفئات الفرعية لفئة رئيسية
- ⏰ مدة الـ cache: 3 ساعات

### 3. **MenuLocalDataSource** - القوائم
- ✅ حفظ عناصر القائمة
- ✅ جلب العناصر المتاحة فقط
- ✅ البحث في القوائم
- ✅ جلب العناصر حسب الفئة
- ✅ تحديث حالة توفر العنصر
- ⏰ مدة الـ cache: 2 ساعة

### 4. **MealTimeLocalDataSource** - أوقات الوجبات
- ✅ حفظ أوقات الوجبات
- ✅ جلب الأوقات النشطة فقط
- ✅ جلب الأوقات حسب الفئة
- ✅ ترتيب الأوقات حسب الترتيب
- ✅ تحديث حالة نشاط الوقت
- ⏰ مدة الـ cache: 4 ساعات

### 5. **DashboardLocalDataSource** - لوحة التحكم
- ✅ حفظ إحصائيات المبيعات
- ✅ حفظ بيانات الطلبات
- ✅ حفظ بيانات المنتجات
- ✅ حفظ بيانات الإيرادات
- ✅ حفظ بيانات العملاء
- ⏰ مدة الـ cache: 30 دقيقة

## 🚀 كيفية الاستخدام

### 1. **الحصول على Local DataSource**
```dart
final productLocalDataSource = getIt<ProductLocalDataSource>();
final categoryLocalDataSource = getIt<CategoryLocalDataSource>();
```

### 2. **حفظ البيانات محلياً**
```dart
// حفظ المنتجات
await productLocalDataSource.saveProducts(products);

// حفظ الفئات
await categoryLocalDataSource.saveMainCategories(categories);
```

### 3. **جلب البيانات من التخزين المحلي**
```dart
// جلب المنتجات
final products = await productLocalDataSource.getProducts();

// جلب الفئات النشطة
final activeCategories = await categoryLocalDataSource.getActiveMainCategories();
```

### 4. **التحقق من وجود بيانات محلية**
```dart
// التحقق من وجود منتجات
final hasProducts = await productLocalDataSource.hasProducts();

// التحقق من وجود فئات
final hasCategories = await categoryLocalDataSource.hasCategories();
```

### 5. **البحث في البيانات المحلية**
```dart
// البحث في المنتجات
final searchResults = await productLocalDataSource.searchProducts("بيتزا");

// البحث في الفئات
final categoryResults = await categoryLocalDataSource.searchMainCategories("حلويات");
```

### 6. **تحديث البيانات**
```dart
// تحديث حالة توفر منتج
await productLocalDataSource.updateProductAvailability("1", false);

// تحديث حالة نشاط فئة
await categoryLocalDataSource.updateCategoryActivity("1", true);
```

### 7. **مسح البيانات**
```dart
// مسح جميع المنتجات
await productLocalDataSource.clearAllProducts();

// مسح جميع الفئات
await categoryLocalDataSource.clearAllCategories();
```

## 🔄 استراتيجية الـ Cache

### **مدة صلاحية الـ Cache:**
- **Dashboard**: 30 دقيقة (بيانات متغيرة بسرعة)
- **Products**: 2 ساعة (منتجات ثابتة نسبياً)
- **Menu**: 2 ساعة (قوائم ثابتة نسبياً)
- **Categories**: 3 ساعات (فئات ثابتة)
- **Meal Times**: 4 ساعات (أوقات ثابتة)

### **آلية التحقق من الصلاحية:**
```dart
// التحقق من صلاحية الـ cache
final isValid = await productLocalDataSource.hasProducts();
if (isValid) {
  // استخدام البيانات المحلية
  final products = await productLocalDataSource.getProducts();
} else {
  // جلب البيانات من الخادم
  final products = await remoteDataSource.getProducts();
  // حفظ البيانات محلياً
  await localDataSource.saveProducts(products);
}
```

## 📊 إدارة البيانات

### **Box Names:**
- جميع البيانات محفوظة في `admin_cache` box
- كل نوع بيانات له مفتاح فريد

### **Data Keys:**
- `products` - المنتجات
- `main_categories` - الفئات الرئيسية
- `sub_categories` - الفئات الفرعية
- `menu_items` - عناصر القائمة
- `menu_categories` - فئات القائمة
- `meal_times` - أوقات الوجبات
- `dashboard_sales_stats` - إحصائيات المبيعات
- `dashboard_orders_data` - بيانات الطلبات
- `dashboard_products_data` - بيانات المنتجات
- `dashboard_revenue_data` - بيانات الإيرادات
- `dashboard_customers_data` - بيانات العملاء

## 🛠️ التكامل مع Repository Pattern

### **Repository Implementation:**
```dart
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  @override
  Future<List<Product>> getProducts() async {
    // التحقق من وجود بيانات محلية
    if (await localDataSource.hasProducts()) {
      return localDataSource.getProducts();
    }
    
    // جلب البيانات من الخادم
    final products = await remoteDataSource.getProducts();
    
    // حفظ البيانات محلياً
    await localDataSource.saveProducts(products);
    
    return products;
  }
}
```

## 🔍 Logging

جميع العمليات مسجلة مع رموز تعبيرية:
- 💾 **حفظ البيانات**
- 📥 **جلب البيانات**
- 🔍 **البحث**
- 🗑️ **مسح البيانات**
- 🔄 **تحديث البيانات**
- ❌ **الأخطاء**

## ⚡ المزايا

1. **سرعة الاستجابة** - البيانات متاحة فوراً
2. **توفير البيانات** - تقليل استهلاك الإنترنت
3. **العمل بدون إنترنت** - إمكانية العمل offline
4. **إدارة ذكية للـ cache** - صلاحية محددة لكل نوع بيانات
5. **سهولة الاستخدام** - واجهة بسيطة وواضحة
6. **التكامل السلس** - مع Repository Pattern
7. **Logging شامل** - لتتبع العمليات
8. **إدارة الأخطاء** - معالجة شاملة للأخطاء

## 🎯 الاستخدام الأمثل

1. **استخدم البيانات المحلية أولاً** - للسرعة
2. **حدّث البيانات بانتظام** - للحفاظ على التحديث
3. **امسح الـ cache عند الحاجة** - لتحرير المساحة
4. **راقب الـ logs** - لتتبع العمليات
5. **تعامل مع الأخطاء** - لضمان الاستقرار

---

**تم إنشاء نظام تخزين محلي شامل ومتقدم لجميع صفحات الإدارة باستخدام Hive! 🎉** 