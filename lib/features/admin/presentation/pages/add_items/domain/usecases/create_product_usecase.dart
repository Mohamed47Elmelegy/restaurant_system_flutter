import '../entities/product.dart';
import '../repositories/product_repository.dart';

// ✅ Params class for CreateProduct
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
      // ✅ 1. Business validation
      _validateProduct(params);

      // ✅ 2. Create product entity
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

      // ✅ 3. Save product
      return await repository.createProduct(product);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  // ✅ Business validation في UseCase
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

    // ✅ Additional validations
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
