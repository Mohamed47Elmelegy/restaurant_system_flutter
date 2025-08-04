# 🔗 ربط Flutter مع Laravel Backend

## 📋 **نظرة عامة**

تم ربط تطبيق Flutter مع Laravel Backend باستخدام Clean Architecture و SOLID Principles. النظام يدعم إدارة المنتجات بشكل كامل مع واجهة مستخدم ثنائية اللغة.

## 🏗️ **البنية المعمارية (Architecture)**

### **Clean Architecture Layers:**

```
📁 Presentation Layer (UI)
├── 📄 admin_add_item_page.dart
├── 📄 my_food_list_page.dart
└── 📄 product_cubit.dart

📁 Domain Layer (Business Logic)
├── 📄 entities/product.dart
├── 📄 repositories/product_repository.dart
└── 📄 usecases/
    ├── 📄 get_products_usecase.dart
    └── 📄 create_product_usecase.dart

📁 Data Layer (Data Management)
├── 📄 datasources/product_remote_data_source.dart
├── 📄 repositories/product_repository_impl.dart
└── 📄 models/product_model.dart

📁 DI (Dependency Injection)
└── 📄 product_di.dart
```

## 🔧 **المكونات الرئيسية**

### **1. Product Entity**
```dart
class Product extends Equatable {
  final int? id;
  final String name;
  final String nameAr;
  final String? description;
  final String? descriptionAr;
  final double price;
  final int mainCategoryId;
  final int? subCategoryId;
  final String? imageUrl;
  final bool isAvailable;
  final double? rating;
  final int? reviewCount;
  final int? preparationTime;
  final List<String>? ingredients;
  final List<String>? allergens;
  final bool isFeatured;
  final int? sortOrder;
  // ... المزيد من الحقول
}
```

### **2. Product Cubit (State Management)**
```dart
class ProductCubit extends Cubit<ProductState> {
  // Events: LoadProducts, CreateProduct
  // States: ProductInitial, ProductLoading, ProductsLoaded, ProductCreated, ProductError
}
```

### **3. Remote Data Source**
```dart
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  // API calls to Laravel backend
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(int id);
}
```

## 🌐 **API Endpoints**

### **Base URL:** `http://10.0.2.2:8000/api/v1`

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/admin/products` | جلب جميع المنتجات |
| POST | `/admin/products` | إنشاء منتج جديد |
| PUT | `/admin/products/{id}` | تحديث منتج |
| DELETE | `/admin/products/{id}` | حذف منتج |
| GET | `/admin/products/{id}` | جلب منتج محدد |

## 📱 **الصفحات المحدثة**

### **1. Admin Add Item Page**
- ✅ **حقول ثنائية اللغة** (إنجليزي + عربي)
- ✅ **اختيار الفئات** (رئيسية + فرعية)
- ✅ **إعدادات المنتج** (متاح/مميز)
- ✅ **إدارة المكونات والحساسية**
- ✅ **حقول إضافية** (وقت التحضير، ترتيب العرض)
- ✅ **ربط مع الباك إند** عبر Cubit

### **2. My Food List Page**
- ✅ **عرض المنتجات** من الباك إند
- ✅ **تصميم بطاقات** جذاب
- ✅ **معلومات شاملة** (السعر، التقييم، الوقت)
- ✅ **حالات التحميل والأخطاء**
- ✅ **دعم ثنائي اللغة**

## 🔄 **Workflow**

### **إنشاء منتج جديد:**
1. **User Input** → Admin Add Item Page
2. **Form Validation** → Client-side validation
3. **Product Entity** → Create from form data
4. **Cubit Action** → `CreateProduct` event
5. **Use Case** → `CreateProductUseCase`
6. **Repository** → `ProductRepositoryImpl`
7. **Data Source** → HTTP POST to Laravel
8. **Response** → Success/Error state
9. **UI Update** → Show result to user

### **عرض المنتجات:**
1. **Page Load** → My Food List Page
2. **Cubit Action** → `LoadProducts` event
3. **Use Case** → `GetProductsUseCase`
4. **Repository** → `ProductRepositoryImpl`
5. **Data Source** → HTTP GET from Laravel
6. **Response** → Products data
7. **UI Update** → Display products list

## 🛠️ **Dependency Injection**

```dart
void setupProductDI() {
  // Data Sources
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: http.Client()),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(repository: getIt()),
  );

  getIt.registerLazySingleton<CreateProductUseCase>(
    () => CreateProductUseCase(repository: getIt()),
  );

  // Cubit
  getIt.registerFactory<ProductCubit>(
    () => ProductCubit(
      getProductsUseCase: getIt(),
      createProductUseCase: getIt(),
    ),
  );
}
```

## 📊 **الميزات المدعومة**

### **✅ تم تنفيذها:**
- [x] **Clean Architecture** - فصل الطبقات
- [x] **SOLID Principles** - مبادئ التصميم
- [x] **Dependency Injection** - حقن التبعيات
- [x] **State Management** - إدارة الحالة
- [x] **API Integration** - ربط مع الباك إند
- [x] **Error Handling** - معالجة الأخطاء
- [x] **Loading States** - حالات التحميل
- [x] **Bilingual Support** - دعم ثنائي اللغة
- [x] **Form Validation** - التحقق من صحة البيانات
- [x] **Product Management** - إدارة المنتجات

### **🔄 قيد التطوير:**
- [ ] **Authentication** - نظام المصادقة
- [ ] **Image Upload** - رفع الصور
- [ ] **Offline Support** - الدعم بدون إنترنت
- [ ] **Caching** - التخزين المؤقت
- [ ] **Real-time Updates** - التحديثات المباشرة

## 🚀 **كيفية الاستخدام**

### **1. تشغيل الباك إند:**
```bash
cd restaurant_system_laravel
php artisan serve
```

### **2. تشغيل Flutter:**
```bash
cd restaurant_system_flutter
flutter run
```

### **3. إضافة منتج جديد:**
1. انتقل إلى Admin Add Item Page
2. املأ البيانات المطلوبة
3. اضغط "Save Changes"
4. سيتم إرسال البيانات للباك إند

### **4. عرض المنتجات:**
1. انتقل إلى My Food List Page
2. ستظهر قائمة المنتجات تلقائياً
3. يمكن إعادة المحاولة في حالة الخطأ

## 🔧 **التكوين**

### **API Base URL:**
```dart
// في lib/core/network/endpoints.dart
static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
```

### **Dependencies:**
```yaml
dependencies:
  flutter_bloc: ^8.1.3
  get_it: ^7.6.4
  equatable: ^2.0.5
  http: ^1.1.0
```

## 📝 **ملاحظات مهمة**

1. **تأكد من تشغيل Laravel server** قبل استخدام التطبيق
2. **تحقق من IP Address** في endpoints.dart
3. **أضف Authorization headers** عند الحاجة
4. **اختبر API endpoints** قبل استخدام التطبيق
5. **راجع error handling** للتأكد من معالجة الأخطاء

## 🎯 **النتائج**

✅ **تم ربط Flutter مع Laravel بنجاح**
✅ **تم تطبيق Clean Architecture**
✅ **تم دعم ثنائي اللغة**
✅ **تم إنشاء واجهات مستخدم متكاملة**
✅ **تم إدارة الحالة بشكل صحيح**
✅ **تم معالجة الأخطاء والتحميل**

---

**🎉 النظام جاهز للاستخدام مع الباك إند!** 