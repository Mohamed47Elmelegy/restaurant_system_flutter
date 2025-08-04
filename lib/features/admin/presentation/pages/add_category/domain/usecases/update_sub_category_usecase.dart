import 'package:dartz/dartz.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/sub_category.dart';
import '../../data/repositories/category_repository.dart';

/// 🟦 UpdateSubCategoryUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحديث الفئات الفرعية فقط
class UpdateSubCategoryUseCase {
  final CategoryRepository repository;

  UpdateSubCategoryUseCase(this.repository);

  Future<Either<Failure, SubCategory>> call({
    required int categoryId,
    required int subCategoryId,
    required SubCategory subCategory,
  }) async {
    return await repository.updateSubCategory(
      categoryId,
      subCategoryId,
      subCategory,
    );
  }
}
