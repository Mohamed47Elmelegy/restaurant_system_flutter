# 🎯 دليل استخدام ProductModel

## 📋 **نظرة عامة**

تم تحديث `ProductModel` ليدعم فصل واضح بين Model و Entity مع إضافة factory methods للتحويل في كلا الاتجاهين.

## 🏗️ **البنية الجديدة**

```dart
class ProductModel {
  // ✅ جميع الحقول معرفة بشكل صحيح
  final int? id;
  final String name;
  final String nameAr;
  // ... باقي الحقول

  // ✅ Constructor مع قيم افتراضية
  const ProductModel({...});

  // ✅ Factory من JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {...}

  // ✅ Factory من Entity (جديد)
  factory ProductModel.fromEntity(Product entity) {...}

  // ✅ التحويل إلى JSON
  Map<String, dynamic> toJson() {...}

  // ✅ التحويل إلى Entity
  Product toEntity() {...}

  // ✅ Copy with method (جديد)
  ProductModel copyWith({...}) {...}

  // ✅ Equality methods (جديد)
  @override bool operator ==(Object other) {...}
  @override int get hashCode {...}
  @override String toString() {...}
}
```

## 🔄 **أنماط الاستخدام الصحيحة**

### ✅ **1. Entity → Model (في Repository)**

```dart
// ✅ صحيح - استخدام fromEntity
final productModel = ProductModel.fromEntity(product);

// ❌ خاطئ - إنشاء model يدوياً
final productModel = ProductModel(
  name: product.name,
  nameAr: product.nameAr,
  // ... باقي الحقول
);
```

### ✅ **2. JSON → Model (في Data Source)**

```dart
// ✅ صحيح - استخدام fromJson
return ProductModel.fromJson(jsonData);

// ❌ خاطئ - إنشاء model يدوياً
return ProductModel(
  id: jsonData['id'],
  name: jsonData['name'],
  // ... باقي الحقول
);
```

### ✅ **3. Model → Entity (في Repository)**

```dart
// ✅ صحيح - استخدام toEntity
return productModel.toEntity();

// ❌ خاطئ - إنشاء entity يدوياً
return Product(
  id: productModel.id,
  name: productModel.name,
  // ... باقي الحقول
);
```

### ✅ **4. Model → JSON (في Data Source)**

```dart
// ✅ صحيح - استخدام toJson
data: productModel.toJson(),

// ❌ خاطئ - إنشاء JSON يدوياً
data: {
  'id': productModel.id,
  'name': productModel.name,
  // ... باقي الحقول
},
```

## 📁 **التطبيق في الملفات المختلفة**

### 🗂️ **1. Repository Implementation**

```dart
// restaurant_system_flutter/lib/features/admin/presentation/pages/add_items/data/repositories/product_repository_impl.dart

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<Product> createProduct(Product product) async {
    try {
      // ✅ استخدام fromEntity() بدلاً من إنشاء model يدوياً
      final productModel = ProductModel.fromEntity(product);

      final createdProductModel = await remoteDataSource.createProduct(productModel);
      return createdProductModel.toEntity();
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      // ✅ استخدام fromEntity() بدلاً من إنشاء model يدوياً
      final productModel = ProductModel.fromEntity(product);

      final updatedProductModel = await remoteDataSource.updateProduct(productModel);
      return updatedProductModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
}
```

### 🌐 **2. Remote Data Source**

```dart
// restaurant_system_flutter/lib/features/admin/presentation/pages/add_items/data/datasources/remoteDataSource/product_remote_data_source_imp.dart

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get(ApiPath.adminProducts());
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true) {
          final List<dynamic> productsData = responseData['data'];
          // ✅ استخدام fromJson() للتحويل من JSON
          return productsData
              .map((json) => ProductModel.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await dio.post(
        ApiPath.adminProducts(),
        // ✅ استخدام toJson() للتحويل إلى JSON
        data: product.toJson(),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true) {
          // ✅ استخدام fromJson() للتحويل من JSON
          return ProductModel.fromJson(responseData['data']);
        }
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
```

### 🎮 **3. Cubit/Bloc (State Management)**

```dart
// restaurant_system_flutter/lib/features/admin/presentation/pages/add_items/presentation/cubit/product_cubit.dart

class ProductCubit extends Bloc<ProductEvent, ProductState> {
  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      // ✅ العمل مع Entity في Cubit
      final createdProduct = await createProductUseCase(event.product);
      emit(ProductCreated(createdProduct));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
```

### 🎨 **4. UI Pages (Presentation Layer)**

```dart
// restaurant_system_flutter/lib/features/admin/presentation/pages/add_items/presentation/pages/admin_add_item_page.dart

class AdminAddItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductsLoaded) {
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index]; // ✅ Entity
              return ListTile(
                title: Text(product.getDisplayName()), // ✅ Entity methods
                subtitle: Text(product.getFormattedPrice()),
                trailing: Text(product.getRatingText()),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
```

## 🎯 **المزايا المحققة**

### ✅ **1. فصل واضح بين Model و Entity**
- **Model**: للتعامل مع البيانات (JSON parsing, API calls)
- **Entity**: للعمل في طبقة الأعمال (business logic, UI)

### ✅ **2. سهولة التحويل**
- `ProductModel.fromEntity(Product entity)` - من Entity إلى Model
- `ProductModel.fromJson(Map<String, dynamic> json)` - من JSON إلى Model
- `productModel.toEntity()` - من Model إلى Entity
- `productModel.toJson()` - من Model إلى JSON

### ✅ **3. تقليل الأخطاء**
- لا حاجة لنسخ الحقول يدوياً
- تحويل آلي ومتسق
- قيم افتراضية منطقية

### ✅ **4. اتباع Clean Architecture**
- **Data Layer**: يعمل مع Models
- **Domain Layer**: يعمل مع Entities
- **Presentation Layer**: يعمل مع Entities

### ✅ **5. سهولة الصيانة**
- تغيير واحد في Model يؤثر على جميع التحويلات
- كود أكثر تنظيماً
- أقل تكرار

## 🚀 **أمثلة عملية**

### 📝 **مثال: إنشاء منتج جديد**

```dart
// 1. في UI - إنشاء Entity
final product = Product(
  name: 'Pizza Margherita',
  nameAr: 'بيتزا مارجريتا',
  price: 25.0,
  mainCategoryId: 1,
);

// 2. في Cubit - إرسال Entity
context.read<ProductCubit>().add(CreateProduct(product));

// 3. في Repository - تحويل Entity إلى Model
final productModel = ProductModel.fromEntity(product);

// 4. في Data Source - إرسال Model كـ JSON
final response = await dio.post('/products', data: productModel.toJson());

// 5. في Data Source - تحويل JSON إلى Model
final createdModel = ProductModel.fromJson(response.data['data']);

// 6. في Repository - تحويل Model إلى Entity
return createdModel.toEntity();

// 7. في UI - عرض Entity
Text(createdProduct.getDisplayName())
```

### 📝 **مثال: تحميل المنتجات**

```dart
// 1. في Data Source - تحويل JSON إلى Models
final List<ProductModel> models = jsonData
    .map((json) => ProductModel.fromJson(json))
    .toList();

// 2. في Repository - تحويل Models إلى Entities
final List<Product> entities = models
    .map((model) => model.toEntity())
    .toList();

// 3. في UI - عرض Entities
ListView.builder(
  itemBuilder: (context, index) {
    final product = entities[index];
    return ListTile(
      title: Text(product.getDisplayName()),
      subtitle: Text(product.getFormattedPrice()),
    );
  },
)
```

## 🎉 **الخلاصة**

تم تطبيق جميع التحسينات بنجاح! الآن يمكنك استخدام `ProductModel` بشكل صحيح في جميع أنحاء التطبيق مع:

- ✅ فصل واضح بين Model و Entity
- ✅ تحويل آلي ومتسق
- ✅ تقليل الأخطاء والنسخ المكرر
- ✅ اتباع Clean Architecture
- ✅ سهولة الصيانة والتطوير

🚀 **استمتع بالتطوير!** 