# 🟦 مبادئ SOLID مع Clean Architecture + BaseRepository

## 📋 **نظرة عامة**

تم تطبيق مبادئ SOLID في نظام المطعم باستخدام Clean Architecture و BaseRepository pattern لضمان:
- **قابلية الصيانة** - سهولة التعديل والتطوير
- **قابلية التوسع** - إضافة ميزات جديدة بسهولة
- **قابلية الاختبار** - اختبار كل مكون بشكل منفصل
- **قابلية إعادة الاستخدام** - استخدام المكونات في أماكن مختلفة

---

## 🟦 **1. S — Single Responsibility Principle (مبدأ المسؤولية الواحدة)**

### 🎯 **المبدأ:**
كل كلاس أو مكون في المشروع يكون مسؤول عن شيء واحد فقط.

### 🧩 **أمثلة من المشروع:**

#### **Product Entity**
```dart
class Product extends BaseEntity {
  // ✅ مسؤول فقط عن تمثيل منتج في الأعمال
  // ✅ لا يعرف تفاصيل JSON أو Database
  // ✅ يحتوي على قواعد الأعمال الأساسية فقط
}
```

#### **ProductRepository**
```dart
abstract class ProductRepository extends BaseRepository<Product> {
  // ✅ مسؤول فقط عن إدارة بيانات المنتجات
  // ✅ لا يعرف تفاصيل UI أو Business Logic
  // ✅ يحدد العمليات المطلوبة فقط
}
```

#### **GetProductsUseCase**
```dart
class GetProductsUseCase extends BaseUseCaseNoParams<List<Product>> {
  // ✅ مسؤول فقط عن جلب المنتجات
  // ✅ لا يعرف تفاصيل Repository أو UI
  // ✅ يحتوي على منطق الأعمال فقط
}
```

#### **ProductCubit**
```dart
class ProductCubit extends BaseCubit<ProductEvent, ProductState> {
  // ✅ مسؤول فقط عن إدارة حالة المنتجات
  // ✅ لا يعرف تفاصيل Data Source أو UI
  // ✅ يربط بين Use Cases و UI
}
```

---

## 🟦 **2. O — Open/Closed Principle (مبدأ الفتح والإغلاق)**

### 🎯 **المبدأ:**
الكلاس مفتوح للتوسيع ولكن مغلق للتعديل.

### 🧩 **أمثلة من المشروع:**

#### **BaseRepository**
```dart
abstract class BaseRepository<T> {
  // ✅ مفتوح للتوسيع - يمكن إضافة repositories جديدة
  // ✅ مغلق للتعديل - لا نحتاج لتعديل BaseRepository
  Future<Either<Failure, List<T>>> getAll();
  Future<Either<Failure, T?>> getById(String id);
  Future<Either<Failure, T>> add(T item);
  // ... المزيد من العمليات
}
```

#### **إضافة Repository جديد**
```dart
// ✅ إضافة UserRepository بدون تعديل BaseRepository
class UserRepository implements BaseRepository<User> {
  @override
  Future<Either<Failure, List<User>>> getAll() => ...
  
  @override
  Future<Either<Failure, User?>> getById(String id) => ...
  
  @override
  Future<Either<Failure, User>> add(User item) => ...
}

// ✅ إضافة OrderRepository بدون تعديل BaseRepository
class OrderRepository implements BaseRepository<Order> {
  @override
  Future<Either<Failure, List<Order>>> getAll() => ...
  
  @override
  Future<Either<Failure, Order?>> getById(String id) => ...
  
  @override
  Future<Either<Failure, Order>> add(Order item) => ...
}
```

#### **BaseUseCase**
```dart
abstract class BaseUseCase<Type, Params> {
  // ✅ مفتوح للتوسيع - يمكن إضافة use cases جديدة
  // ✅ مغلق للتعديل - لا نحتاج لتعديل BaseUseCase
  Future<Either<Failure, Type>> call(Params params);
}
```

---

## 🟦 **3. L — Liskov Substitution Principle (مبدأ الاستبدال)**

### 🎯 **المبدأ:**
أي كلاس يرث من كلاس آخر أو ينفذ Interface لازم يقدر يحل محله بدون ما يكسر التطبيق.

### 🧩 **أمثلة من المشروع:**

#### **استبدال Repositories**
```dart
// ✅ يمكن استخدام أي repository كـ BaseRepository
BaseRepository<Product> productRepo = ProductRepositoryImpl();
BaseRepository<User> userRepo = UserRepositoryImpl();
BaseRepository<Order> orderRepo = OrderRepositoryImpl();

// ✅ جميعهم يعملون بنفس الطريقة
final products = await productRepo.getAll();
final users = await userRepo.getAll();
final orders = await orderRepo.getAll();
```

#### **استبدال Use Cases**
```dart
// ✅ يمكن استخدام أي use case كـ BaseUseCase
BaseUseCase<List<Product>, NoParams> getProducts = GetProductsUseCase();
BaseUseCase<Product, String> getProduct = GetProductByIdUseCase();
BaseUseCase<Product, Product> createProduct = CreateProductUseCase();

// ✅ جميعهم يعملون بنفس الطريقة
final result = await useCase.call(params);
```

#### **استبدال Data Sources**
```dart
// ✅ يمكن استخدام أي data source كـ BaseDataSource
BaseDataSource<ProductModel> remoteDS = ProductRemoteDataSource();
BaseDataSource<ProductModel> localDS = ProductLocalDataSource();
BaseDataSource<ProductModel> cacheDS = ProductCacheDataSource();

// ✅ جميعهم يعملون بنفس الطريقة
final response = await dataSource.getAll();
```

---

## 🟦 **4. I — Interface Segregation Principle (مبدأ فصل الواجهات)**

### 🎯 **المبدأ:**
من الأفضل أن يكون لديك واجهات متعددة ومتخصصة بدلاً من واجهة واحدة كبيرة.

### 🧩 **أمثلة من المشروع:**

#### **فصل واجهات Repository**
```dart
// ✅ واجهة أساسية للعمليات المشتركة
abstract class BaseRepository<T> {
  Future<Either<Failure, List<T>>> getAll();
  Future<Either<Failure, T?>> getById(String id);
  Future<Either<Failure, T>> add(T item);
  Future<Either<Failure, T>> update(String id, T item);
  Future<Either<Failure, bool>> delete(String id);
}

// ✅ واجهة متخصصة للمنتجات
abstract class ProductRepository extends BaseRepository<Product> {
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
  Future<Either<Failure, List<Product>>> getFeaturedProducts();
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}

// ✅ واجهة متخصصة للمستخدمين
abstract class UserRepository extends BaseRepository<User> {
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, void>> logout();
}
```

#### **فصل واجهات Data Source**
```dart
// ✅ واجهة أساسية للبيانات
abstract class BaseDataSource<T> {
  Future<BaseResponse<List<T>>> getAll();
  Future<BaseResponse<T?>> getById(String id);
  Future<BaseResponse<T>> add(T item);
}

// ✅ واجهة متخصصة للبيانات البعيدة
abstract class BaseRemoteDataSource<T> extends BaseDataSource<T> {
  String get baseUrl;
  String get endpoint;
  Map<String, String> get headers;
}

// ✅ واجهة متخصصة للبيانات المحلية
abstract class BaseLocalDataSource<T> extends BaseDataSource<T> {
  String get tableName;
  String get storageKey;
  Future<void> saveLocally(List<T> items);
  Future<List<T>> getLocalData();
}
```

---

## 🟦 **5. D — Dependency Inversion Principle (مبدأ قلب الاعتماديات)**

### 🎯 **المبدأ:**
الاعتماد يكون على Abstraction (واجهة) وليس على كلاس محدد.

### 🧩 **أمثلة من المشروع:**

#### **Use Cases تعتمد على Repository Interface**
```dart
class GetProductsUseCase extends BaseUseCaseNoParams<List<Product>> {
  // ✅ يعتمد على abstraction وليس implementation
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call() {
    return repository.getAll();
  }
}
```

#### **Repository يعتمد على Data Source Interface**
```dart
class ProductRepositoryImpl implements ProductRepository {
  // ✅ يعتمد على abstraction وليس implementation
  final ProductDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Product>>> getAll() async {
    final response = await dataSource.getAll();
    // ... معالجة البيانات
  }
}
```

#### **Cubit يعتمد على Use Cases Interfaces**
```dart
class ProductCubit extends BaseCubit<ProductEvent, ProductState> {
  // ✅ يعتمد على abstraction وليس implementation
  final GetProductsUseCase getProductsUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;
  final CreateProductUseCase createProductUseCase;

  ProductCubit({
    required this.getProductsUseCase,
    required this.getProductByIdUseCase,
    required this.createProductUseCase,
  }) : super(ProductInitial());
}
```

#### **Dependency Injection**
```dart
// ✅ في service_locator.dart
getIt.registerLazySingleton<ProductRepository>(
  () => ProductRepositoryImpl(getIt<ProductDataSource>()),
);

getIt.registerLazySingleton<GetProductsUseCase>(
  () => GetProductsUseCase(getIt<ProductRepository>()),
);

getIt.registerFactory<ProductCubit>(
  () => ProductCubit(
    getProductsUseCase: getIt<GetProductsUseCase>(),
    getProductByIdUseCase: getIt<GetProductByIdUseCase>(),
    createProductUseCase: getIt<CreateProductUseCase>(),
  ),
);
```

---

## 🏗️ **بنية الـ Base Classes**

### 🔸 **base_repository.dart**
```dart
abstract class BaseRepository<T> {
  Future<Either<Failure, List<T>>> getAll();
  Future<Either<Failure, T?>> getById(String id);
  Future<Either<Failure, T>> add(T item);
  Future<Either<Failure, T>> update(String id, T item);
  Future<Either<Failure, bool>> delete(String id);
  Future<Either<Failure, List<T>>> search(String query);
  Future<Either<Failure, List<T>>> getPaginated({
    int page = 1,
    int limit = 10,
    String? sortBy,
    bool ascending = true,
  });
}
```

### 🔸 **base_model.dart**
```dart
abstract class BaseModel<T> {
  Map<String, dynamic> toJson();
  T toEntity();
  BaseModel<T> copyWith(Map<String, dynamic> changes);
  @override bool operator ==(Object other);
  @override int get hashCode;
  @override String toString();
}
```

### 🔸 **base_entity.dart**
```dart
abstract class BaseEntity extends Equatable {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BaseEntity({
    required this.id,
    this.createdAt,
    this.updatedAt,
  });

  BaseEntity copyWith({String? id, DateTime? createdAt, DateTime? updatedAt});
  Map<String, dynamic> toMap();
  bool get isValid;
  int get ageInDays;
  bool get isCreatedToday;
}
```

### 🔸 **base_response.dart**
```dart
class BaseResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final Map<String, List<String>>? errors;
  final int? statusCode;
  final DateTime? timestamp;

  const BaseResponse({
    required this.success,
    this.data,
    this.message,
    this.errors,
    this.statusCode,
    this.timestamp,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT);
  Map<String, dynamic> toJson();
  bool get isSuccess;
  bool get isError;
  String? get firstError;
}
```

### 🔸 **base_usecase.dart**
```dart
abstract class BaseUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class BaseUseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

abstract class BaseUseCaseVoid<Params> {
  Future<Either<Failure, void>> call(Params params);
}
```

### 🔸 **base_cubit.dart**
```dart
abstract class BaseCubit<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  BaseCubit(State initialState) : super(initialState);

  void emitEvent(Event event);
  void emitState(State state);
  void emitError(String message);
  void emitLoading();
  void emitSuccess();
  bool get isLoading;
  bool get isError;
  bool get isSuccess;
  String? get errorMessage;
  void reset();
}
```

### 🔸 **base_datasource.dart**
```dart
abstract class BaseDataSource<T> {
  Future<BaseResponse<List<T>>> getAll();
  Future<BaseResponse<T?>> getById(String id);
  Future<BaseResponse<T>> add(T item);
  Future<BaseResponse<T>> update(String id, T item);
  Future<BaseResponse<bool>> delete(String id);
  Future<BaseResponse<List<T>>> search(String query);
  Future<BaseResponse<List<T>>> getPaginated({
    int page = 1,
    int limit = 10,
    String? sortBy,
    bool ascending = true,
  });
}
```

---

## 🧠 **خلاصة المبادئ**

### ✅ **مبدأ المسؤولية الواحدة (SRP)**
- كل كلاس مسؤول عن شيء واحد فقط
- Product Entity مسؤول عن تمثيل المنتج فقط
- ProductRepository مسؤول عن إدارة بيانات المنتجات فقط
- GetProductsUseCase مسؤول عن جلب المنتجات فقط

### ✅ **مبدأ الفتح والإغلاق (OCP)**
- BaseRepository مفتوح للتوسيع، مغلق للتعديل
- يمكن إضافة repositories جديدة بدون تعديل BaseRepository
- يمكن إضافة use cases جديدة بدون تعديل BaseUseCase

### ✅ **مبدأ الاستبدال (LSP)**
- أي repository يمكن أن يحل محل BaseRepository
- أي use case يمكن أن يحل محل BaseUseCase
- أي data source يمكن أن يحل محل BaseDataSource

### ✅ **مبدأ فصل الواجهات (ISP)**
- واجهات متخصصة لكل نوع من البيانات
- ProductRepository متخصص للمنتجات
- UserRepository متخصص للمستخدمين
- OrderRepository متخصص للطلبات

### ✅ **مبدأ قلب الاعتماديات (DIP)**
- Use Cases تعتمد على Repository Interface
- Repository يعتمد على Data Source Interface
- Cubit يعتمد على Use Cases Interfaces
- Dependency Injection يربط بين المكونات

---

## 🎯 **فوائد التطبيق**

### 🚀 **قابلية الصيانة**
- كل مكون مسؤول عن شيء واحد فقط
- سهولة فهم وتعديل الكود
- تقليل التداخل بين المكونات

### 🔧 **قابلية التوسع**
- إضافة ميزات جديدة بسهولة
- لا نحتاج لتعديل الكود الموجود
- فصل واضح بين الطبقات

### 🧪 **قابلية الاختبار**
- اختبار كل مكون بشكل منفصل
- استخدام Mock Objects بسهولة
- اختبار منطق الأعمال منفصل عن UI

### ♻️ **قابلية إعادة الاستخدام**
- استخدام BaseRepository في أي مكان
- استخدام BaseUseCase في أي feature
- استخدام BaseCubit في أي state management

### 🛡️ **المرونة**
- تغيير Data Source بسهولة
- تغيير Repository Implementation بسهولة
- تغيير UI بسهولة بدون التأثير على Business Logic

---

## 📚 **المراجع**

- [SOLID Principles in Flutter](https://medium.com/flutter-community/solid-principles-in-flutter-1c5f8c8b6c66)
- [Clean Architecture with Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Repository Pattern in Flutter](https://medium.com/flutter-community/repository-pattern-in-flutter-5a849b2d38e2)
- [Dependency Injection in Flutter](https://medium.com/flutter-community/dependency-injection-in-flutter-using-get-it-8b4b4b4b4b4) 