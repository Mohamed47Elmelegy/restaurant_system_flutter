import 'package:dartz/dartz.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import '../../domain/entities/main_category.dart';
import '../../data/repositories/category_repository.dart';

/// 🟦 GetCategoryByIdUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن جلب فئة بواسطة المعرف فقط
class GetCategoryByIdUseCase extends BaseUseCase<MainCategory?, int> {
  final CategoryRepository repository;

  GetCategoryByIdUseCase({required this.repository});

  @override
  Future<Either<Failure, MainCategory?>> call(int id) async {
    try {
      return await repository.getById(id.toString());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get category by ID: $e'));
    }
  }
}
