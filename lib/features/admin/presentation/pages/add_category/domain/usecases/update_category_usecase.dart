import 'package:dartz/dartz.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import '../../../../../../../core/entities/main_category.dart';
import '../repositories/category_repository.dart';

/// 🟦 UpdateCategoryUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحديث فئة موجودة فقط
class UpdateCategoryUseCase
    extends BaseUseCase<CategoryEntity, CategoryEntity> {
  final CategoryRepository repository;

  UpdateCategoryUseCase({required this.repository});

  @override
  Future<Either<Failure, CategoryEntity>> call(CategoryEntity category) async {
    try {
      return await repository.update(category.id, category);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update category: $e'));
    }
  }
}
