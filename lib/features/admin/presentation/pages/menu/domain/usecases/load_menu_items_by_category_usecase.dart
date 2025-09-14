import 'package:dartz/dartz.dart';

import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';

class LoadMenuItemsByCategoryParams {
  final String category;

  const LoadMenuItemsByCategoryParams({required this.category});

  @override
  String toString() => 'LoadMenuItemsByCategoryParams(category: $category)';
}

class LoadMenuItemsByCategoryUseCase
    extends BaseUseCase<List<MenuItem>, LoadMenuItemsByCategoryParams> {
  final MenuRepository repository;

  LoadMenuItemsByCategoryUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MenuItem>>> call(
    LoadMenuItemsByCategoryParams params,
  ) async {
    try {
      if (params.category.isEmpty) {
        return const Left(ServerFailure(message: 'اسم الفئة مطلوب'));
      }

      return await repository.getMenuItemsByCategory(params.category);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل في تحميل المنتجات للفئة ${params.category}: $e',
        ),
      );
    }
  }
}
