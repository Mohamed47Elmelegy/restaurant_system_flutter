import 'package:dartz/dartz.dart';

import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/entities/main_category.dart';
import '../../../../../../../core/error/failures.dart';
import '../repositories/category_repository.dart';

/// 🟦 GetCategoriesUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن جلب جميع الفئات فقط
class GetCategoriesUseCase extends BaseUseCaseNoParams<List<CategoryEntity>> {
  final CategoryRepository repository;

  GetCategoriesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() async {
    try {
      return await repository.getCategories();
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get categories: $e'));
    }
  }
}
