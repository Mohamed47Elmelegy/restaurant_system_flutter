import 'package:dartz/dartz.dart';

import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/entities/main_category.dart';
import '../../../../../../../core/error/failures.dart';
import '../repositories/category_repository.dart';

/// 🟦 CreateCategoryUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إنشاء فئة جديدة فقط
class CreateCategoryUseCase
    extends BaseUseCase<CategoryEntity, CategoryEntity> {
  final CategoryRepository repository;

  CreateCategoryUseCase({required this.repository});

  @override
  Future<Either<Failure, CategoryEntity>> call(CategoryEntity category) async {
    try {
      return await repository.add(category);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create category: $e'));
    }
  }
}
