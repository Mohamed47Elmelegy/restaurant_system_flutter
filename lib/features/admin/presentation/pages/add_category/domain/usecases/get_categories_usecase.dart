import 'package:dartz/dartz.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import '../../domain/entities/main_category.dart';
import '../../data/repositories/category_repository.dart';

/// 🟦 GetCategoriesUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن جلب جميع الفئات فقط
class GetCategoriesUseCase extends BaseUseCaseNoParams<List<MainCategory>> {
  final CategoryRepository repository;

  GetCategoriesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MainCategory>>> call() async {
    try {
      return await repository.getCategories();
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get categories: $e'));
    }
  }
}
