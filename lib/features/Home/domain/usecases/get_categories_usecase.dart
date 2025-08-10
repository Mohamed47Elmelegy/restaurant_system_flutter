import 'package:dartz/dartz.dart';

import '../../../../core/entities/main_category.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';

class GetCategoriesUseCase {
  final HomeRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await _repository.getCategories();
  }
}
