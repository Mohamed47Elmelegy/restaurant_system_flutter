import 'package:dartz/dartz.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/sub_category.dart';
import '../../data/repositories/category_repository.dart';

/// 🟦 CreateSubCategoryUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إنشاء الفئات الفرعية فقط
class CreateSubCategoryUseCase {
  final CategoryRepository repository;

  CreateSubCategoryUseCase(this.repository);

  Future<Either<Failure, SubCategory>> call({
    required int categoryId,
    required SubCategory subCategory,
  }) async {
    return await repository.createSubCategory(categoryId, subCategory);
  }
}
