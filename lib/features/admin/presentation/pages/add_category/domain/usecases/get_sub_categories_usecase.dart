import 'package:dartz/dartz.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/sub_category.dart';
import '../../data/repositories/category_repository.dart';

/// 🟦 GetSubCategoriesUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن جلب الفئات الفرعية فقط
class GetSubCategoriesUseCase {
  final CategoryRepository repository;

  GetSubCategoriesUseCase(this.repository);

  Future<Either<Failure, List<SubCategory>>> call(int categoryId) async {
    return await repository.getSubCategories(categoryId);
  }
}
