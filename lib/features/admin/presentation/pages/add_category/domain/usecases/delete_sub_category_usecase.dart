import 'package:dartz/dartz.dart';
import '../../../../../../../core/error/failures.dart';
import '../../data/repositories/category_repository.dart';

/// 🟦 DeleteSubCategoryUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن حذف الفئات الفرعية فقط
class DeleteSubCategoryUseCase {
  final CategoryRepository repository;

  DeleteSubCategoryUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required int categoryId,
    required int subCategoryId,
  }) async {
    return await repository.deleteSubCategory(categoryId, subCategoryId);
  }
}
