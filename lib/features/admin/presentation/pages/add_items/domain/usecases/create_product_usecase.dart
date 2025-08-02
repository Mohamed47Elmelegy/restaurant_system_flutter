import '../entities/product.dart';
import '../repositories/product_repository.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

/// 🟦 CreateProductUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إنشاء المنتج فقط - لا يتحكم في البيانات
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstractions وليس implementations
class CreateProductUseCase extends BaseUseCase<Product, Product> {
  final ProductRepository repository;

  CreateProductUseCase({required this.repository});

  @override
  Future<Either<Failure, Product>> call(Product product) async {
    try {
      // ✅ 1. Business validation only
      final validationResult = _validateProduct(product);
      return validationResult.fold((failure) => Left(failure), (_) async {
        // ✅ 2. Save product directly - no data transformation
        return await repository.createProduct(product);
      });
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create product: $e'));
    }
  }

  // ✅ Business validation في UseCase فقط
  Either<Failure, void> _validateProduct(Product product) {
    final errors = <String>[];

    if (product.name.isEmpty) {
      errors.add('اسم المنتج مطلوب');
    }

    if (product.nameAr.isEmpty) {
      errors.add('اسم المنتج بالعربية مطلوب');
    }

    if (product.price <= 0) {
      errors.add('السعر يجب أن يكون أكبر من صفر');
    }

    if (product.mainCategoryId <= 0) {
      errors.add('يجب اختيار فئة رئيسية');
    }

    // ✅ Additional business validations
    if (product.name.length < 2) {
      errors.add('اسم المنتج يجب أن يكون أكثر من حرفين');
    }

    if (product.nameAr.length < 2) {
      errors.add('اسم المنتج بالعربية يجب أن يكون أكثر من حرفين');
    }

    if (product.price > 1000) {
      errors.add('السعر يجب أن يكون أقل من 1000');
    }

    if (product.preparationTime != null && product.preparationTime! < 0) {
      errors.add('وقت التحضير يجب أن يكون موجب');
    }

    if (product.sortOrder != null && product.sortOrder! < 0) {
      errors.add('ترتيب المنتج يجب أن يكون موجب');
    }

    if (errors.isNotEmpty) {
      return Left(ServerFailure(message: errors.join(', ')));
    }

    return const Right(null);
  }
}
