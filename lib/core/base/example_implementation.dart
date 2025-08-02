// import 'package:equatable/equatable.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../error/failures.dart';
// import 'base_entity.dart';
// import 'base_model.dart';
// import 'base_repository.dart';
// import 'base_usecase.dart';
// import 'base_cubit.dart';
// import 'base_datasource.dart';
// import 'base_response.dart';

// /// 🟦 1. Product Entity - مبدأ المسؤولية الواحدة (SRP)
// /// مسؤول عن تمثيل منتج في الأعمال فقط
// class Product extends BaseEntity {
//   final String name;
//   final String nameAr;
//   final String? description;
//   final String? descriptionAr;
//   final double price;
//   final int mainCategoryId;
//   final int? subCategoryId;
//   final String? imageUrl;
//   final bool isAvailable;
//   final double? rating;
//   final int? reviewCount;
//   final int? preparationTime;
//   final List<String>? ingredients;
//   final List<String>? allergens;
//   final bool isFeatured;
//   final int? sortOrder;

//   const Product({
//     required super.id,
//     required this.name,
//     required this.nameAr,
//     this.description,
//     this.descriptionAr,
//     required this.price,
//     required this.mainCategoryId,
//     this.subCategoryId,
//     this.imageUrl,
//     this.isAvailable = true,
//     this.rating,
//     this.reviewCount,
//     this.preparationTime,
//     this.ingredients,
//     this.allergens,
//     this.isFeatured = false,
//     this.sortOrder,
//     super.createdAt,
//     super.updatedAt,
//   });

//   @override
//   Product copyWith({
//     String? id,
//     String? name,
//     String? nameAr,
//     String? description,
//     String? descriptionAr,
//     double? price,
//     int? mainCategoryId,
//     int? subCategoryId,
//     String? imageUrl,
//     bool? isAvailable,
//     double? rating,
//     int? reviewCount,
//     int? preparationTime,
//     List<String>? ingredients,
//     List<String>? allergens,
//     bool? isFeatured,
//     int? sortOrder,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return Product(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       nameAr: nameAr ?? this.nameAr,
//       description: description ?? this.description,
//       descriptionAr: descriptionAr ?? this.descriptionAr,
//       price: price ?? this.price,
//       mainCategoryId: mainCategoryId ?? this.mainCategoryId,
//       subCategoryId: subCategoryId ?? this.subCategoryId,
//       imageUrl: imageUrl ?? this.imageUrl,
//       isAvailable: isAvailable ?? this.isAvailable,
//       rating: rating ?? this.rating,
//       reviewCount: reviewCount ?? this.reviewCount,
//       preparationTime: preparationTime ?? this.preparationTime,
//       ingredients: ingredients ?? this.ingredients,
//       allergens: allergens ?? this.allergens,
//       isFeatured: isFeatured ?? this.isFeatured,
//       sortOrder: sortOrder ?? this.sortOrder,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }

//   @override
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'name_ar': nameAr,
//       'description': description,
//       'description_ar': descriptionAr,
//       'price': price,
//       'main_category_id': mainCategoryId,
//       'sub_category_id': subCategoryId,
//       'image_url': imageUrl,
//       'is_available': isAvailable,
//       'rating': rating,
//       'review_count': reviewCount,
//       'preparation_time': preparationTime,
//       'ingredients': ingredients,
//       'allergens': allergens,
//       'is_featured': isFeatured,
//       'sort_order': sortOrder,
//       'created_at': createdAt?.toIso8601String(),
//       'updated_at': updatedAt?.toIso8601String(),
//     };
//   }

//   @override
//   bool get isValid {
//     return name.isNotEmpty &&
//         nameAr.isNotEmpty &&
//         price > 0 &&
//         mainCategoryId > 0;
//   }

//   @override
//   List<Object?> get props => [
//     id,
//     name,
//     nameAr,
//     description,
//     descriptionAr,
//     price,
//     mainCategoryId,
//     subCategoryId,
//     imageUrl,
//     isAvailable,
//     rating,
//     reviewCount,
//     preparationTime,
//     ingredients,
//     allergens,
//     isFeatured,
//     sortOrder,
//     createdAt,
//     updatedAt,
//   ];
// }

// /// 🟦 2. Product Model - مبدأ المسؤولية الواحدة (SRP)
// /// مسؤول عن تحويل البيانات فقط
// class ProductModel extends BaseModel<Product> {
//   final String id;
//   final String name;
//   final String nameAr;
//   final String? description;
//   final String? descriptionAr;
//   final double price;
//   final int mainCategoryId;
//   final int? subCategoryId;
//   final String? imageUrl;
//   final bool isAvailable;
//   final double? rating;
//   final int? reviewCount;
//   final int? preparationTime;
//   final List<String>? ingredients;
//   final List<String>? allergens;
//   final bool isFeatured;
//   final int? sortOrder;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   const ProductModel({
//     required this.id,
//     required this.name,
//     required this.nameAr,
//     this.description,
//     this.descriptionAr,
//     required this.price,
//     required this.mainCategoryId,
//     this.subCategoryId,
//     this.imageUrl,
//     this.isAvailable = true,
//     this.rating,
//     this.reviewCount,
//     this.preparationTime,
//     this.ingredients,
//     this.allergens,
//     this.isFeatured = false,
//     this.sortOrder,
//     this.createdAt,
//     this.updatedAt,
//   });

//   /// تحويل JSON إلى ProductModel
//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       id: json['id']?.toString() ?? '',
//       name: json['name'] ?? '',
//       nameAr: json['name_ar'] ?? '',
//       description: json['description'],
//       descriptionAr: json['description_ar'],
//       price: (json['price'] ?? 0.0).toDouble(),
//       mainCategoryId: json['main_category_id'] ?? 0,
//       subCategoryId: json['sub_category_id'],
//       imageUrl: json['image_url'],
//       isAvailable: json['is_available'] ?? true,
//       rating: json['rating']?.toDouble(),
//       reviewCount: json['review_count'],
//       preparationTime: json['preparation_time'],
//       ingredients: json['ingredients'] != null
//           ? List<String>.from(json['ingredients'])
//           : null,
//       allergens: json['allergens'] != null
//           ? List<String>.from(json['allergens'])
//           : null,
//       isFeatured: json['is_featured'] ?? false,
//       sortOrder: json['sort_order'],
//       createdAt: json['created_at'] != null
//           ? DateTime.parse(json['created_at'])
//           : null,
//       updatedAt: json['updated_at'] != null
//           ? DateTime.parse(json['updated_at'])
//           : null,
//     );
//   }

//   /// تحويل Entity إلى Model
//   factory ProductModel.fromEntity(Product entity) {
//     return ProductModel(
//       id: entity.id,
//       name: entity.name,
//       nameAr: entity.nameAr,
//       description: entity.description,
//       descriptionAr: entity.descriptionAr,
//       price: entity.price,
//       mainCategoryId: entity.mainCategoryId,
//       subCategoryId: entity.subCategoryId,
//       imageUrl: entity.imageUrl,
//       isAvailable: entity.isAvailable,
//       rating: entity.rating,
//       reviewCount: entity.reviewCount,
//       preparationTime: entity.preparationTime,
//       ingredients: entity.ingredients,
//       allergens: entity.allergens,
//       isFeatured: entity.isFeatured,
//       sortOrder: entity.sortOrder,
//       createdAt: entity.createdAt,
//       updatedAt: entity.updatedAt,
//     );
//   }

//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'name_ar': nameAr,
//       'description': description,
//       'description_ar': descriptionAr,
//       'price': price,
//       'main_category_id': mainCategoryId,
//       'sub_category_id': subCategoryId,
//       'image_url': imageUrl,
//       'is_available': isAvailable,
//       'rating': rating,
//       'review_count': reviewCount,
//       'preparation_time': preparationTime,
//       'ingredients': ingredients,
//       'allergens': allergens,
//       'is_featured': isFeatured,
//       'sort_order': sortOrder,
//       'created_at': createdAt?.toIso8601String(),
//       'updated_at': updatedAt?.toIso8601String(),
//     };
//   }

//   @override
//   Product toEntity() {
//     return Product(
//       id: id,
//       name: name,
//       nameAr: nameAr,
//       description: description,
//       descriptionAr: descriptionAr,
//       price: price,
//       mainCategoryId: mainCategoryId,
//       subCategoryId: subCategoryId,
//       imageUrl: imageUrl,
//       isAvailable: isAvailable,
//       rating: rating,
//       reviewCount: reviewCount,
//       preparationTime: preparationTime,
//       ingredients: ingredients,
//       allergens: allergens,
//       isFeatured: isFeatured,
//       sortOrder: sortOrder,
//       createdAt: createdAt,
//       updatedAt: updatedAt,
//     );
//   }

//   @override
//   BaseModel<Product> copyWith(Map<String, dynamic> changes) {
//     return ProductModel(
//       id: changes['id'] ?? id,
//       name: changes['name'] ?? name,
//       nameAr: changes['name_ar'] ?? nameAr,
//       description: changes['description'] ?? description,
//       descriptionAr: changes['description_ar'] ?? descriptionAr,
//       price: changes['price'] ?? price,
//       mainCategoryId: changes['main_category_id'] ?? mainCategoryId,
//       subCategoryId: changes['sub_category_id'] ?? subCategoryId,
//       imageUrl: changes['image_url'] ?? imageUrl,
//       isAvailable: changes['is_available'] ?? isAvailable,
//       rating: changes['rating'] ?? rating,
//       reviewCount: changes['review_count'] ?? reviewCount,
//       preparationTime: changes['preparation_time'] ?? preparationTime,
//       ingredients: changes['ingredients'] ?? ingredients,
//       allergens: changes['allergens'] ?? allergens,
//       isFeatured: changes['is_featured'] ?? isFeatured,
//       sortOrder: changes['sort_order'] ?? sortOrder,
//       createdAt: changes['created_at'] ?? createdAt,
//       updatedAt: changes['updated_at'] ?? updatedAt,
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is ProductModel &&
//         other.id == id &&
//         other.name == name &&
//         other.nameAr == nameAr &&
//         other.price == price &&
//         other.mainCategoryId == mainCategoryId;
//   }

//   @override
//   int get hashCode {
//     return Object.hash(id, name, nameAr, price, mainCategoryId);
//   }

//   @override
//   String toString() {
//     return 'ProductModel(id: $id, name: $name, price: $price)';
//   }
// }

// /// 🟦 3. Product Repository - مبدأ المسؤولية الواحدة (SRP)
// /// مسؤول عن إدارة بيانات المنتجات فقط
// abstract class ProductRepository extends BaseRepository<Product> {
//   /// جلب المنتجات حسب الفئة
//   Future<Either<Failure, List<Product>>> getProductsByCategory(String category);

//   /// جلب المنتجات المميزة
//   Future<Either<Failure, List<Product>>> getFeaturedProducts();

//   /// البحث في المنتجات
//   Future<Either<Failure, List<Product>>> searchProducts(String query);
// }

// /// 🟦 4. Product Use Cases - مبدأ المسؤولية الواحدة (SRP)
// /// كل use case مسؤول عن عملية واحدة فقط

// /// جلب جميع المنتجات
// class GetProductsUseCase extends BaseUseCaseNoParams<List<Product>> {
//   final ProductRepository repository;

//   GetProductsUseCase(this.repository);

//   @override
//   Future<Either<Failure, List<Product>>> call() {
//     return repository.getAll();
//   }
// }

// /// جلب منتج بواسطة المعرف
// class GetProductByIdUseCase extends BaseUseCase<Product, String> {
//   final ProductRepository repository;

//   GetProductByIdUseCase(this.repository);

//   @override
//   Future<Either<Failure, Product>> call(String id) async {
//     final result = await repository.getById(id);
//     return result.fold(
//       (failure) => Left(failure),
//       (product) => product != null
//           ? Right(product)
//           : Left(ServerFailure(message: 'Product not found')),
//     );
//   }
// }

// /// إنشاء منتج جديد
// class CreateProductUseCase extends BaseUseCase<Product, Product> {
//   final ProductRepository repository;

//   CreateProductUseCase(this.repository);

//   @override
//   Future<Either<Failure, Product>> call(Product product) {
//     return repository.add(product);
//   }
// }

// /// 🟦 5. Product Cubit - مبدأ المسؤولية الواحدة (SRP)
// /// مسؤول عن إدارة حالة المنتجات فقط

// /// Product Events
// abstract class ProductEvent extends BaseEvent {}

// class LoadProducts extends ProductEvent {}

// class LoadProductById extends ProductEvent {
//   final String id;
//   LoadProductById(this.id);
// }

// class CreateProduct extends ProductEvent {
//   final Product product;
//   CreateProduct(this.product);
// }

// class UpdateProduct extends ProductEvent {
//   final String id;
//   final Product product;
//   UpdateProduct(this.id, this.product);
// }

// class DeleteProduct extends ProductEvent {
//   final String id;
//   DeleteProduct(this.id);
// }

// /// Product States
// abstract class ProductState extends BaseState {}

// class ProductInitial extends ProductState {}

// class ProductLoading extends ProductState {}

// class ProductsLoaded extends ProductState {
//   final List<Product> products;
//   ProductsLoaded(this.products);
// }

// class ProductLoaded extends ProductState {
//   final Product product;
//   ProductLoaded(this.product);
// }

// class ProductCreated extends ProductState {
//   final Product product;
//   ProductCreated(this.product);
// }

// class ProductUpdated extends ProductState {
//   final Product product;
//   ProductUpdated(this.product);
// }

// class ProductDeleted extends ProductState {
//   final String id;
//   ProductDeleted(this.id);
// }

// class ProductError extends ProductState {
//   final String message;
//   ProductError(this.message);
// }

// /// Product Cubit
// class ProductCubit extends BaseCubit<ProductEvent, ProductState> {
//   final GetProductsUseCase getProductsUseCase;
//   final GetProductByIdUseCase getProductByIdUseCase;
//   final CreateProductUseCase createProductUseCase;

//   ProductCubit({
//     required this.getProductsUseCase,
//     required this.getProductByIdUseCase,
//     required this.createProductUseCase,
//   }) : super(ProductInitial()) {
//     on<LoadProducts>(_onLoadProducts);
//     on<LoadProductById>(_onLoadProductById);
//     on<CreateProduct>(_onCreateProduct);
//     on<UpdateProduct>(_onUpdateProduct);
//     on<DeleteProduct>(_onDeleteProduct);
//   }

//   Future<void> _onLoadProducts(
//     LoadProducts event,
//     Emitter<ProductState> emit,
//   ) async {
//     emit(ProductLoading());

//     final result = await getProductsUseCase();
//     result.fold(
//       (failure) => emit(ProductError(failure.toString())),
//       (products) => emit(ProductsLoaded(products)),
//     );
//   }

//   Future<void> _onLoadProductById(
//     LoadProductById event,
//     Emitter<ProductState> emit,
//   ) async {
//     emit(ProductLoading());

//     final result = await getProductByIdUseCase(event.id);
//     result.fold(
//       (failure) => emit(ProductError(failure.toString())),
//       (product) => emit(ProductLoaded(product)),
//     );
//   }

//   Future<void> _onCreateProduct(
//     CreateProduct event,
//     Emitter<ProductState> emit,
//   ) async {
//     emit(ProductLoading());

//     final result = await createProductUseCase(event.product);
//     result.fold(
//       (failure) => emit(ProductError(failure.toString())),
//       (product) => emit(ProductCreated(product)),
//     );
//   }

//   Future<void> _onUpdateProduct(
//     UpdateProduct event,
//     Emitter<ProductState> emit,
//   ) async {
//     // Implementation for update
//   }

//   Future<void> _onDeleteProduct(
//     DeleteProduct event,
//     Emitter<ProductState> emit,
//   ) async {
//     // Implementation for delete
//   }

//   @override
//   void emitError(String message) {
//     emit(ProductError(message));
//   }

//   @override
//   void emitLoading() {
//     emit(ProductLoading());
//   }

//   @override
//   void emitSuccess() {
//     // Implementation for success
//   }

//   @override
//   String? get errorMessage {
//     if (state is ProductError) {
//       return (state as ProductError).message;
//     }
//     return null;
//   }

//   @override
//   void reset() {
//     emit(ProductInitial());
//   }
// }

// /// 🟦 6. Product Data Source - مبدأ المسؤولية الواحدة (SRP)
// /// مسؤول عن الوصول للبيانات فقط
// abstract class ProductDataSource extends BaseRemoteDataSource<ProductModel> {
//   @override
//   String get baseUrl => 'https://api.restaurant.com';

//   @override
//   String get endpoint => '/products';

//   @override
//   Map<String, String> get headers => {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//   };
// }

// /// 🟦 7. Product Repository Implementation - مبدأ المسؤولية الواحدة (SRP)
// /// مسؤول عن تنفيذ منطق Repository فقط
// class ProductRepositoryImpl implements ProductRepository {
//   final ProductDataSource dataSource;

//   ProductRepositoryImpl(this.dataSource);

//   @override
//   Future<Either<Failure, List<Product>>> getAll() async {
//     try {
//       final response = await dataSource.getAll();
//       if (response.isSuccess) {
//         final products =
//             response.data?.map((model) => model.toEntity()).toList() ?? [];
//         return Right(products);
//       } else {
//         return Left(
//           ServerFailure(message: response.message ?? 'Failed to get products'),
//         );
//       }
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, Product?>> getById(String id) async {
//     try {
//       final response = await dataSource.getById(id);
//       if (response.isSuccess) {
//         final product = response.data?.toEntity();
//         return Right(product);
//       } else {
//         return Left(
//           ServerFailure(message: response.message ?? 'Failed to get product'),
//         );
//       }
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, Product>> add(Product item) async {
//     try {
//       final model = ProductModel.fromEntity(item);
//       final response = await dataSource.add(model);
//       if (response.isSuccess) {
//         final product = response.data?.toEntity();
//         return Right(product!);
//       } else {
//         return Left(
//           ServerFailure(
//             message: response.message ?? 'Failed to create product',
//           ),
//         );
//       }
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, Product>> update(String id, Product item) async {
//     try {
//       final model = ProductModel.fromEntity(item);
//       final response = await dataSource.update(id, model);
//       if (response.isSuccess) {
//         final product = response.data?.toEntity();
//         return Right(product!);
//       } else {
//         return Left(
//           ServerFailure(
//             message: response.message ?? 'Failed to update product',
//           ),
//         );
//       }
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, bool>> delete(String id) async {
//     try {
//       final response = await dataSource.delete(id);
//       if (response.isSuccess) {
//         return Right(response.data ?? false);
//       } else {
//         return Left(
//           ServerFailure(
//             message: response.message ?? 'Failed to delete product',
//           ),
//         );
//       }
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, List<Product>>> search(String query) async {
//     try {
//       final response = await dataSource.search(query);
//       if (response.isSuccess) {
//         final products =
//             response.data?.map((model) => model.toEntity()).toList() ?? [];
//         return Right(products);
//       } else {
//         return Left(
//           ServerFailure(
//             message: response.message ?? 'Failed to search products',
//           ),
//         );
//       }
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, List<Product>>> getPaginated({
//     int page = 1,
//     int limit = 10,
//     String? sortBy,
//     bool ascending = true,
//   }) async {
//     try {
//       final response = await dataSource.getPaginated(
//         page: page,
//         limit: limit,
//         sortBy: sortBy,
//         ascending: ascending,
//       );
//       if (response.isSuccess) {
//         final products =
//             response.data?.map((model) => model.toEntity()).toList() ?? [];
//         return Right(products);
//       } else {
//         return Left(
//           ServerFailure(
//             message: response.message ?? 'Failed to get paginated products',
//           ),
//         );
//       }
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, List<Product>>> getProductsByCategory(
//     String category,
//   ) async {
//     // Implementation for getting products by category
//     return Left(ServerFailure(message: 'Not implemented'));
//   }

//   @override
//   Future<Either<Failure, List<Product>>> getFeaturedProducts() async {
//     // Implementation for getting featured products
//     return Left(ServerFailure(message: 'Not implemented'));
//   }

//   @override
//   Future<Either<Failure, List<Product>>> searchProducts(String query) async {
//     return search(query);
//   }
// }
