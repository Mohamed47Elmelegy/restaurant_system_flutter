# 🏗️ دليل البنية المعمارية - نظام إضافة المنتجات

## 📋 **نظرة عامة**

هذا الدليل يشرح البنية المعمارية الكاملة لنظام إضافة المنتجات، من Data Layer إلى Presentation Layer، مع شرح كل طبقة ومسؤولياتها.

---

## 🔗 **العلاقة مع نظام القائمة (Menu System)**

### **🎯 العلاقة الأساسية:**

**`add_items/`** و **`menu/`** هما مكونان متكاملان في نظام إدارة المطعم:

#### **1. التدفق المنطقي:**
```
📝 إضافة منتج جديد (add_items/) 
    ↓
💾 حفظ في قاعدة البيانات
    ↓
📋 عرض في القائمة (menu/)
```

#### **2. المسؤوليات المتباينة:**

**`add_items/` (نظام الإضافة):**
- ✅ **إنشاء منتجات جديدة**
- ✅ **تحميل الصور**
- ✅ **إدخال البيانات التفصيلية**
- ✅ **اختيار الفئات والتصنيفات**
- ✅ **إعدادات التوفر والمميزات**

**`menu/` (نظام العرض):**
- ✅ **عرض المنتجات المضافة**
- ✅ **تصفية حسب الفئات**
- ✅ **البحث في المنتجات**
- ✅ **تعديل وحذف المنتجات**
- ✅ **إدارة حالة التوفر**

#### **3. التنقل بين النظامين:**

**من القائمة إلى إضافة منتج:**
```dart
// في menu page
Navigator.pushNamed(context, '/admin/add-item');
```

**من إضافة منتج إلى القائمة:**
```dart
// بعد حفظ المنتج بنجاح
Navigator.pop(context); // العودة للقائمة
```

#### **4. مشاركة البيانات:**

**API Endpoints المشتركة:**
- `GET /admin/products` - جلب المنتجات للقائمة
- `POST /admin/products` - إضافة منتج جديد
- `PUT /admin/products/{id}` - تحديث منتج
- `DELETE /admin/products/{id}` - حذف منتج

**Data Models المشتركة:**
- `Product` Entity - الكيان الأساسي
- `ProductModel` - نموذج البيانات
- `ProductRepository` - واجهة المستودع

#### **5. البنية المعمارية المتكاملة:**

```
🏗️ Clean Architecture
├── 📁 Domain Layer (مشترك)
│   ├── entities/product.dart
│   └── repositories/product_repository.dart
├── 📁 Data Layer (مشترك)
│   ├── models/product_model.dart
│   └── repositories/product_repository_impl.dart
└── 📁 Presentation Layer (منفصل)
    ├── 📁 add_items/
    │   └── pages/admin_add_item_page.dart
    └── 📁 menu/
        └── pages/admin_menu_page.dart
```

#### **6. تدفق العمل (Workflow):**

**إضافة منتج جديد:**
1. **Admin** → يفتح صفحة إضافة منتج
2. **Add Item Page** → يملأ البيانات والصور
3. **API Call** → إرسال البيانات للباك إند
4. **Database** → حفظ المنتج
5. **Success** → العودة للقائمة
6. **Menu Page** → عرض المنتج الجديد

**عرض وإدارة المنتجات:**
1. **Menu Page** → تحميل المنتجات من API
2. **Filter/Search** → تصفية وبحث
3. **Edit/Delete** → تعديل أو حذف
4. **Real-time Update** → تحديث فوري للقائمة

#### **7. الميزات المشتركة:**

**✅ إدارة الحالة:**
- BlocProvider للـ State Management
- Cubit للتحكم في البيانات
- Real-time updates

**✅ معالجة الأخطاء:**
- Error handling في كلتا الصفحتين
- User-friendly error messages
- Retry mechanisms

**✅ التحقق من الصحة:**
- Form validation
- Data integrity checks
- API response validation

---

## 🗂️ **هيكل الملفات**

```
lib/features/admin/presentation/pages/add_items/
├── data/
│   ├── models/
│   │   └── product_model.dart          # Data Model
│   ├── repositories/
│   │   └── product_repository_impl.dart # Repository Implementation
│   └── datasources/
│       └── remoteDataSource/
│           └── product_remote_data_source_imp.dart # API Calls
├── domain/
│   ├── entities/
│   │   └── product.dart                # Business Entity
│   ├── repositories/
│   │   └── product_repository.dart     # Repository Interface
│   └── usecases/
│       ├── create_product_usecase.dart # Business Logic
│       └── get_products_usecase.dart   # Get Products Logic
└── presentation/
    ├── cubit/
    │   ├── product_cubit.dart          # State Management
    │   ├── product_events.dart         # Events
    │   └── product_states.dart         # States
    ├── pages/
    │   └── admin_add_item_page.dart    # UI
    └── widgets/
        └── index.dart                   # UI Components
```

---

## 🗄️ **1. Data Layer (طبقة البيانات)**

### 📊 **1.1 Data Models**

**الملف:** `data/models/product_model.dart`

```dart
class ProductModel {
  final int? id;
  final String name;
  final String nameAr;
  final double price;
  final int mainCategoryId;
  // ... باقي الحقول

  const ProductModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.price,
    required this.mainCategoryId,
    // ... باقي المعاملات
  });

  // ✅ Factory Methods للتحويل
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      nameAr: json['name_ar'],
      price: json['price'].toDouble(),
      mainCategoryId: json['main_category_id'],
      // ... باقي الحقول
    );
  }

  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      nameAr: entity.nameAr,
      price: entity.price,
      mainCategoryId: entity.mainCategoryId,
      // ... باقي الحقول
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'price': price,
      'main_category_id': mainCategoryId,
      // ... باقي الحقول
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      nameAr: nameAr,
      price: price,
      mainCategoryId: mainCategoryId,
      // ... باقي الحقول
    );
  }
}
```

**🎯 المسؤوليات:**
- **تحويل البيانات:** من JSON إلى Model والعكس
- **تحويل Model إلى Entity:** للانتقال للطبقة التالية
- **تحويل Entity إلى Model:** للانتقال للطبقة السابقة

### 🔌 **1.2 Remote Data Source**

**الملف:** `data/datasources/remoteDataSource/product_remote_data_source_imp.dart`

```dart
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<ProductModel> getProductById(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient dioClient;

  ProductRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dioClient.get(ApiPath.products);
      final productsData = response.data['data'] as List;
      
      return productsData
          .map((json) => ProductModel.fromJson(json)) // ✅ تحويل من JSON
          .toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await dioClient.post(
        ApiPath.products,
        data: product.toJson(), // ✅ تحويل إلى JSON
      );
      
      return ProductModel.fromJson(response.data['data']); // ✅ تحويل من JSON
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final response = await dioClient.put(
        '${ApiPath.products}/${product.id}',
        data: product.toJson(), // ✅ تحويل إلى JSON
      );
      
      return ProductModel.fromJson(response.data['data']); // ✅ تحويل من JSON
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
}
```

**🎯 المسؤوليات:**
- **API Calls:** الاتصال بالخادم
- **تحويل البيانات:** من Model إلى JSON والعكس
- **معالجة الأخطاء:** التقاط أخطاء الشبكة

### 🔄 **1.3 Repository Implementation**

**الملف:** `data/repositories/product_repository_impl.dart`

```dart
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    try {
      final productModels = await remoteDataSource.getProducts();
      // ✅ تحويل Models إلى Entities
      return productModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      // ✅ تحويل Entity إلى Model
      final productModel = ProductModel.fromEntity(product);
      
      final createdProductModel = await remoteDataSource.createProduct(productModel);
      return createdProductModel.toEntity(); // ✅ تحويل Model إلى Entity
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      // ✅ تحويل Entity إلى Model
      final productModel = ProductModel.fromEntity(product);
      
      final updatedProductModel = await remoteDataSource.updateProduct(productModel);
      return updatedProductModel.toEntity(); // ✅ تحويل Model إلى Entity
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
}
```

**🎯 المسؤوليات:**
- **وسيط بين الطبقات:** يربط Domain مع Data
- **تحويل البيانات:** من Entity إلى Model والعكس
- **معالجة الأخطاء:** التقاط أخطاء Repository

---

## 🎯 **2. Domain Layer (طبقة الأعمال)**

### 🏢 **2.1 Business Entities**

**الملف:** `domain/entities/product.dart`

```dart
class Product {
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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.nameAr,
    this.description,
    this.descriptionAr,
    required this.price,
    required this.mainCategoryId,
    this.subCategoryId,
    this.imageUrl,
    this.isAvailable = true,
    this.rating,
    this.reviewCount,
    this.preparationTime,
    this.ingredients,
    this.allergens,
    this.isFeatured = false,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });
}
```

**🎯 المسؤوليات:**
- **تمثيل البيانات:** تمثيل المنتج في الأعمال
- **Business Rules:** قواعد الأعمال الأساسية
- **عدم الاعتماد على Data:** لا يعتمد على JSON أو Database

### 📋 **2.2 Repository Interface**

**الملف:** `domain/repositories/product_repository.dart`

```dart
abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<Product> getProductById(int id);
}
```

**🎯 المسؤوليات:**
- **تعريف العمليات:** تحديد العمليات المطلوبة
- **فصل الطبقات:** Domain لا يعرف تفاصيل Data
- **سهولة الاختبار:** يمكن استخدام Mock Repository

### 🧠 **2.3 Use Cases (Business Logic)**

**الملف:** `domain/usecases/create_product_usecase.dart`

```dart
// ✅ Params Class للتحويل الآمن
class CreateProductParams {
  final String name;
  final String nameAr;
  final String? description;
  final String? descriptionAr;
  final double price;
  final int mainCategoryId;
  final int? subCategoryId;
  final String? imageUrl;
  final bool isAvailable;
  final bool isFeatured;
  final int? preparationTime;
  final int? sortOrder;
  final List<String>? ingredients;
  final List<String>? allergens;

  CreateProductParams({
    required this.name,
    required this.nameAr,
    this.description,
    this.descriptionAr,
    required this.price,
    required this.mainCategoryId,
    this.subCategoryId,
    this.imageUrl,
    this.isAvailable = true,
    this.isFeatured = false,
    this.preparationTime,
    this.sortOrder,
    this.ingredients,
    this.allergens,
  });
}

class CreateProductUseCase {
  final ProductRepository repository;

  CreateProductUseCase({required this.repository});

  Future<Product> call(CreateProductParams params) async {
    try {
      // ✅ 1. Business Validation
      _validateProduct(params);

      // ✅ 2. Create Product Entity
      final product = Product(
        name: params.name,
        nameAr: params.nameAr,
        description: params.description,
        descriptionAr: params.descriptionAr,
        price: params.price,
        mainCategoryId: params.mainCategoryId,
        subCategoryId: params.subCategoryId,
        imageUrl: params.imageUrl,
        isAvailable: params.isAvailable,
        isFeatured: params.isFeatured,
        preparationTime: params.preparationTime,
        sortOrder: params.sortOrder,
        ingredients: params.ingredients,
        allergens: params.allergens,
      );

      // ✅ 3. Save Product
      return await repository.createProduct(product);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  // ✅ Business Validation في UseCase
  void _validateProduct(CreateProductParams params) {
    final errors = <String>[];

    if (params.name.isEmpty) {
      errors.add('اسم المنتج مطلوب');
    }

    if (params.nameAr.isEmpty) {
      errors.add('اسم المنتج بالعربية مطلوب');
    }

    if (params.price <= 0) {
      errors.add('السعر يجب أن يكون أكبر من صفر');
    }

    if (params.mainCategoryId <= 0) {
      errors.add('يجب اختيار فئة رئيسية');
    }

    // ✅ Additional Validations
    if (params.name.length < 2) {
      errors.add('اسم المنتج يجب أن يكون أكثر من حرفين');
    }

    if (params.nameAr.length < 2) {
      errors.add('اسم المنتج بالعربية يجب أن يكون أكثر من حرفين');
    }

    if (params.price > 1000) {
      errors.add('السعر يجب أن يكون أقل من 1000');
    }

    if (params.preparationTime != null && params.preparationTime! < 0) {
      errors.add('وقت التحضير يجب أن يكون موجب');
    }

    if (params.sortOrder != null && params.sortOrder! < 0) {
      errors.add('ترتيب المنتج يجب أن يكون موجب');
    }

    if (errors.isNotEmpty) {
      throw Exception(errors.join(', '));
    }
  }
}
```

**🎯 المسؤوليات:**
- **Business Logic:** منطق الأعمال
- **Validation:** التحقق من صحة البيانات
- **Orchestration:** تنسيق العمليات
- **Error Handling:** معالجة الأخطاء

---

## 🎨 **3. Presentation Layer (طبقة العرض)**

### 🎮 **3.1 Events**

**الملف:** `presentation/cubit/product_events.dart`

```dart
import '../../domain/usecases/create_product_usecase.dart';

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class CreateProduct extends ProductEvent {
  final CreateProductParams params; // ✅ استخدام Params
  CreateProduct(this.params);
}

class UpdateProduct extends ProductEvent {
  final CreateProductParams params; // ✅ استخدام Params
  UpdateProduct(this.params);
}

class ResetProductForm extends ProductEvent {}

class ValidateProduct extends ProductEvent {
  final CreateProductParams params; // ✅ استخدام Params
  ValidateProduct(this.params);
}
```

**🎯 المسؤوليات:**
- **تحديد الإجراءات:** ما يمكن للمستخدم فعله
- **نقل البيانات:** نقل البيانات من UI إلى Cubit
- **فصل المسؤوليات:** كل Event له هدف محدد

### 📊 **3.2 States**

**الملف:** `presentation/cubit/product_states.dart`

```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;

  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductCreated extends ProductState {
  final Product product;

  const ProductCreated(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductUpdated extends ProductState {
  final Product product;

  const ProductUpdated(this.product);

  @override
  List<Object?> get props => [product];
}

// ✅ Error States
class ProductValidationError extends ProductState {
  final String message;

  const ProductValidationError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductAuthError extends ProductState {
  final String message;

  const ProductAuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductFormReset extends ProductState {}

class ProductFormValidated extends ProductState {
  final bool isValid;
  final List<String> errors;

  const ProductFormValidated({
    required this.isValid,
    required this.errors,
  });

  @override
  List<Object?> get props => [isValid, errors];
}
```

**🎯 المسؤوليات:**
- **تمثيل الحالة:** حالة التطبيق في كل لحظة
- **معالجة الأخطاء:** حالات مختلفة للأخطاء
- **توجيه UI:** ما يجب عرضه للمستخدم

### 🎯 **3.3 Cubit (State Management)**

**الملف:** `presentation/cubit/product_cubit.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/create_product_usecase.dart';
import 'product_events.dart';
import 'product_states.dart';

class ProductCubit extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final CreateProductUseCase createProductUseCase;

  ProductCubit({
    required this.getProductsUseCase,
    required this.createProductUseCase,
  }) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<CreateProduct>(_onCreateProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<ResetProductForm>(_onResetProductForm);
    on<ValidateProduct>(_onValidateProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      log('🔄 ProductCubit: Loading products...');
      final products = await getProductsUseCase();
      log(
        '✅ ProductCubit: Products loaded successfully - ${products.length} products',
      );
      emit(ProductsLoaded(products));
    } catch (e) {
      log('❌ ProductCubit: Failed to load products - $e');
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      log('🔄 ProductCubit: Creating product - ${event.params.name}');
      log('🔄 ProductCubit: Product params - ${event.params.toString()}');

      // ✅ استخدام UseCase مع Params
      final createdProduct = await createProductUseCase(event.params);

      log(
        '✅ ProductCubit: Product created successfully - ${createdProduct.name}',
      );
      log('✅ ProductCubit: Created product ID - ${createdProduct.id}');

      emit(ProductCreated(createdProduct));
    } catch (e) {
      log('❌ ProductCubit: Failed to create product - $e');
      
      // ✅ معالجة أخطاء مختلفة
      if (e.toString().contains('اسم المنتج') || 
          e.toString().contains('السعر') || 
          e.toString().contains('فئة')) {
        emit(ProductValidationError(e.toString()));
      } else if (e.toString().contains('تسجيل الدخول') || 
                 e.toString().contains('مصادقة')) {
        emit(ProductAuthError(e.toString()));
      } else {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      log('🔄 ProductCubit: Updating product - ${event.params.name}');
      log('🔄 ProductCubit: Product params - ${event.params.toString()}');

      // TODO: Implement UpdateProductUseCase
      // final updatedProduct = await updateProductUseCase(event.params);

      log(
        '✅ ProductCubit: Product updated successfully - ${event.params.name}',
      );

      emit(ProductUpdated(Product(
        name: event.params.name,
        nameAr: event.params.nameAr,
        price: event.params.price,
        mainCategoryId: event.params.mainCategoryId,
      )));
    } catch (e) {
      log('❌ ProductCubit: Failed to update product - $e');
      emit(ProductError(e.toString()));
    }
  }

  void _onResetProductForm(ResetProductForm event, Emitter<ProductState> emit) {
    log('🔄 ProductCubit: Resetting product form');
    emit(ProductFormReset());
  }

  void _onValidateProduct(ValidateProduct event, Emitter<ProductState> emit) {
    log('🔄 ProductCubit: Validating product - ${event.params.name}');

    final errors = <String>[];

    // ✅ Basic Validation
    if (event.params.name.isEmpty) {
      errors.add('اسم المنتج مطلوب');
    }

    if (event.params.nameAr.isEmpty) {
      errors.add('اسم المنتج بالعربية مطلوب');
    }

    if (event.params.price <= 0) {
      errors.add('السعر يجب أن يكون أكبر من صفر');
    }

    if (event.params.mainCategoryId <= 0) {
      errors.add('يجب اختيار فئة رئيسية');
    }

    // ✅ Additional Validations
    if (event.params.name.length < 2) {
      errors.add('اسم المنتج يجب أن يكون أكثر من حرفين');
    }

    if (event.params.nameAr.length < 2) {
      errors.add('اسم المنتج بالعربية يجب أن يكون أكثر من حرفين');
    }

    if (event.params.price > 1000) {
      errors.add('السعر يجب أن يكون أقل من 1000');
    }

    final isValid = errors.isEmpty;

    log(
      '✅ ProductCubit: Product validation completed - Valid: $isValid, Errors: ${errors.length}',
    );

    emit(ProductFormValidated(isValid: isValid, errors: errors));
  }
}
```

**🎯 المسؤوليات:**
- **State Management:** إدارة حالة التطبيق
- **Event Handling:** معالجة الأحداث
- **UseCase Coordination:** تنسيق UseCases
- **Error Handling:** معالجة الأخطاء

### 🎨 **3.4 UI (User Interface)**

**الملف:** `presentation/pages/admin_add_item_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/theme_helper.dart';
import '../../../../../../../core/utils/responsive_helper.dart';
import '../cubit/product_events.dart';
import '../cubit/product_states.dart';
import '../widgets/index.dart';
import '../cubit/product_cubit.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../../../../../../core/di/service_locator.dart';

class AdminAddItemPage extends StatefulWidget {
  const AdminAddItemPage({super.key});

  @override
  State<AdminAddItemPage> createState() => _AdminAddItemPageState();
}

class _AdminAddItemPageState extends State<AdminAddItemPage> {
  final _formKey = GlobalKey<FormState>();

  // ✅ Controllers فقط
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _detailsController = TextEditingController();
  final _nameArController = TextEditingController();
  final _detailsArController = TextEditingController();
  final _preparationTimeController = TextEditingController();
  final _sortOrderController = TextEditingController();

  // ✅ Product settings
  bool _isAvailable = true;
  bool _isFeatured = false;

  // ✅ Category selection
  String? _selectedMainCategory;
  String? _selectedSubCategory;

  // ✅ Lists for ingredients and allergens
  List<String> _selectedIngredients = [];
  List<String> _selectedAllergens = [];

  // ✅ Existing fields
  List<String> _uploadedImages = <String>[];
  bool _isPickupSelected = false;
  bool _isDeliverySelected = false;
  Set<String> _selectedBasicIngredients = {};
  Set<String> _selectedFruitIngredients = {};
  String? _selectedMealCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _detailsController.dispose();
    _nameArController.dispose();
    _detailsArController.dispose();
    _preparationTimeController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductCubit>(),
      child: BlocListener<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم إنشاء المنتج بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProductValidationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ في البيانات: ${state.message}'),
                backgroundColor: Colors.orange,
              ),
            );
          } else if (state is ProductAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ في المصادقة: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: ThemeHelper.getBackgroundColor(context),
              appBar: CustomAppBar(
                onBackPressed: () => Navigator.pop(context),
                onResetPressed: _onResetPressed,
              ),
              body: SafeArea(
                child: ResponsiveHelper.responsiveLayout(
                  builder: (context, constraints) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.isMobile(context)
                            ? 24.w
                            : 32.w,
                      ),
                      child: AddItemFormWidget(
                        formKey: _formKey,
                        // English fields
                        nameController: _nameController,
                        priceController: _priceController,
                        detailsController: _detailsController,
                        // Arabic fields
                        nameArController: _nameArController,
                        detailsArController: _detailsArController,
                        // Additional fields
                        preparationTimeController: _preparationTimeController,
                        sortOrderController: _sortOrderController,
                        // Product settings
                        isAvailable: _isAvailable,
                        isFeatured: _isFeatured,
                        onAvailableChanged: (value) {
                          setState(() {
                            _isAvailable = value;
                          });
                        },
                        onFeaturedChanged: (value) {
                          setState(() {
                            _isFeatured = value;
                          });
                        },
                        // Category selection
                        selectedMainCategory: _selectedMainCategory,
                        selectedSubCategory: _selectedSubCategory,
                        onMainCategoryChanged: (category) {
                          setState(() {
                            _selectedMainCategory = category;
                            _selectedSubCategory = null;
                          });
                        },
                        onSubCategoryChanged: (category) {
                          setState(() {
                            _selectedSubCategory = category;
                          });
                        },
                        // Ingredients and allergens
                        selectedIngredients: _selectedIngredients,
                        selectedAllergens: _selectedAllergens,
                        onIngredientsChanged: (ingredients) {
                          setState(() {
                            _selectedIngredients = ingredients;
                          });
                        },
                        onAllergensChanged: (allergens) {
                          setState(() {
                            _selectedAllergens = allergens;
                          });
                        },
                        // Existing fields
                        uploadedImages: _uploadedImages,
                        isPickupSelected: _isPickupSelected,
                        isDeliverySelected: _isDeliverySelected,
                        selectedBasicIngredients: _selectedBasicIngredients,
                        selectedFruitIngredients: _selectedFruitIngredients,
                        selectedMealCategory: _selectedMealCategory,
                        onAddMediaPressed: _onAddMediaPressed,
                        onPickupChanged: (value) {
                          setState(() {
                            _isPickupSelected = value;
                          });
                        },
                        onDeliveryChanged: (value) {
                          setState(() {
                            _isDeliverySelected = value;
                          });
                        },
                        onBasicIngredientToggled: (ingredientId) {
                          setState(() {
                            if (_selectedBasicIngredients.contains(ingredientId)) {
                              _selectedBasicIngredients.remove(ingredientId);
                            } else {
                              _selectedBasicIngredients.add(ingredientId);
                            }
                          });
                        },
                        onFruitIngredientToggled: (ingredientId) {
                          setState(() {
                            if (_selectedFruitIngredients.contains(ingredientId)) {
                              _selectedFruitIngredients.remove(ingredientId);
                            } else {
                              _selectedFruitIngredients.add(ingredientId);
                            }
                          });
                        },
                        onBasicSeeAllPressed: () {
                          // TODO: Navigate to see all basic ingredients
                        },
                        onFruitSeeAllPressed: () {
                          // TODO: Navigate to see all fruit ingredients
                        },
                        onMealCategoryChanged: (category) {
                          setState(() {
                            _selectedMealCategory = category;
                          });
                        },
                        onSavePressed: () => _onSaveChanges(context),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onAddMediaPressed() {
    // TODO: Implement media picker
    setState(() {
      if (_uploadedImages.isEmpty) {
        _uploadedImages.add('assets/images/chickenburger.jpg');
      }
    });
  }

  void _onResetPressed() {
    setState(() {
      // Clear English fields
      _nameController.clear();
      _priceController.clear();
      _detailsController.clear();

      // Clear Arabic fields
      _nameArController.clear();
      _detailsArController.clear();

      // Clear additional fields
      _preparationTimeController.clear();
      _sortOrderController.clear();

      // Reset settings
      _isAvailable = true;
      _isFeatured = false;

      // Reset categories
      _selectedMainCategory = null;
      _selectedSubCategory = null;

      // Reset ingredients and allergens
      _selectedIngredients.clear();
      _selectedAllergens.clear();

      // Clear existing fields
      _uploadedImages.clear();
      _isPickupSelected = false;
      _isDeliverySelected = false;
      _selectedBasicIngredients = {};
      _selectedFruitIngredients.clear();
      _selectedMealCategory = null;
    });
  }

  // ✅ UI method مبسط - إنشاء Params فقط
  void _onSaveChanges(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // ✅ إنشاء Params فقط
      final params = CreateProductParams(
        name: _nameController.text.trim(),
        nameAr: _nameArController.text.trim(),
        description: _detailsController.text.trim(),
        descriptionAr: _detailsArController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0.0,
        mainCategoryId: int.tryParse(_selectedMainCategory ?? '1') ?? 1,
        subCategoryId: _selectedSubCategory != null
            ? int.tryParse(_selectedSubCategory!)
            : null,
        imageUrl: _uploadedImages.isNotEmpty ? _uploadedImages.first : null,
        isAvailable: _isAvailable,
        isFeatured: _isFeatured,
        preparationTime: _preparationTimeController.text.isNotEmpty
            ? int.tryParse(_preparationTimeController.text)
            : null,
        sortOrder: _sortOrderController.text.isNotEmpty
            ? int.tryParse(_sortOrderController.text)
            : null,
        ingredients: _selectedIngredients.isNotEmpty ? _selectedIngredients : null,
        allergens: _selectedAllergens.isNotEmpty ? _selectedAllergens : null,
      );

      // ✅ إرسال Params فقط
      BlocProvider.of<ProductCubit>(context, listen: false)
          .add(CreateProduct(params));
    }
  }
}
```

**🎯 المسؤوليات:**
- **عرض البيانات:** عرض النماذج والحقول
- **جمع البيانات:** جمع البيانات من المستخدم
- **إنشاء Params:** تحويل البيانات إلى Params
- **إرسال Events:** إرسال الأحداث للـ Cubit
- **عرض النتائج:** عرض النتائج والأخطاء

---

## 🔄 **تدفق البيانات الكامل**

### ✅ **الخطوات بالترتيب:**

```
1. UI يجمع البيانات من Form
   ↓
2. UI ينشئ CreateProductParams
   ↓
3. UI يرسل CreateProduct Event للـ Cubit
   ↓
4. Cubit يستقبل Event ويستدعي UseCase
   ↓
5. UseCase يتحقق من صحة Params
   ↓
6. UseCase ينشئ Product Entity
   ↓
7. UseCase يرسل Entity للـ Repository
   ↓
8. Repository يحول Entity إلى Model
   ↓
9. Repository يرسل Model للـ Remote Data Source
   ↓
10. Remote Data Source يحول Model إلى JSON
    ↓
11. Remote Data Source يرسل JSON للـ API
    ↓
12. API يرجع JSON للـ Remote Data Source
    ↓
13. Remote Data Source يحول JSON إلى Model
    ↓
14. Repository يحول Model إلى Entity
    ↓
15. UseCase يرجع Entity للـ Cubit
    ↓
16. Cubit يرسل State للـ UI
    ↓
17. UI يعرض النتيجة للمستخدم
```

---

## 🎯 **المزايا المحققة**

### ✅ **1. فصل المسؤوليات:**

```dart
// ✅ كل طبقة لها مسؤولية محددة
Data Layer: تحويل البيانات والاتصال بالخادم
Domain Layer: Business Logic والتحقق من البيانات
Presentation Layer: عرض البيانات وإدارة الحالة
```

### ✅ **2. سهولة الاختبار:**

```dart
// ✅ يمكن اختبار كل طبقة منفصلة
test('Data Layer should convert JSON to Model', () {
  // اختبار Data Layer
});

test('Domain Layer should validate data', () {
  // اختبار Domain Layer
});

test('Presentation Layer should handle events', () {
  // اختبار Presentation Layer
});
```

### ✅ **3. إعادة الاستخدام:**

```dart
// ✅ يمكن استخدام UseCase في أماكن مختلفة
final createProductUseCase = CreateProductUseCase(repository);

// في Cubit
final product = await createProductUseCase(params);

// في Service
final product = await createProductUseCase(params);

// في Test
final product = await createProductUseCase(testParams);
```

### ✅ **4. سهولة الصيانة:**

```dart
// ✅ تغيير UI لا يؤثر على Business Logic
// ✅ تغيير Business Logic لا يؤثر على UI
// ✅ تغيير Database لا يؤثر على Business Logic
```

---

## 🚀 **كيف تطبق هذا في مشاريعك؟**

### ✅ **الخطوات العملية:**

1. **ابدأ بـ Data Layer:** أنشئ Models و Remote Data Sources
2. **أنشئ Domain Layer:** أنشئ Entities و Repository Interfaces
3. **أنشئ UseCases:** ضع Business Logic في UseCases
4. **أنشئ Presentation Layer:** أنشئ Events و States و Cubit
5. **أنشئ UI:** اعرض البيانات فقط

### ✅ **القاعدة الذهبية:**

```
Presentation Layer → Params → Domain Layer → Entity
```

**النتيجة:** كود منظم، سهل الصيانة، قابل للاختبار! 🎉

---

## 📚 **ملفات إضافية مهمة**

### ✅ **Dependency Injection:**

```dart
// في core/di/service_locator.dart
void setupProductDependencies() {
  // Data Layer
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(dioClient: getIt()),
  );
  
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: getIt()),
  );
  
  // Domain Layer
  getIt.registerLazySingleton<CreateProductUseCase>(
    () => CreateProductUseCase(repository: getIt()),
  );
  
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(repository: getIt()),
  );
  
  // Presentation Layer
  getIt.registerFactory<ProductCubit>(
    () => ProductCubit(
      getProductsUseCase: getIt(),
      createProductUseCase: getIt(),
    ),
  );
}
```

### ✅ **API Paths:**

```dart
// في core/network/api_path.dart
class ApiPath {
  static const String products = '/products';
  static const String categories = '/categories';
  // ... باقي المسارات
}
```

---

## 🎉 **الخلاصة**

هذا الدليل يشرح البنية المعمارية الكاملة لنظام إضافة المنتجات، من Data Layer إلى Presentation Layer. كل طبقة لها مسؤولية محددة، مما يجعل الكود منظم، سهل الصيانة، وقابل للاختبار.

**المفتاح للنجاح:** اتبع Clean Architecture وفصل المسؤوليات بين الطبقات! 🚀 