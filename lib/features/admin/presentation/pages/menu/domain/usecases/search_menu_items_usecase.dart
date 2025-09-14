import 'package:dartz/dartz.dart';

import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';

class SearchMenuItemsParams {
  final String query;

  const SearchMenuItemsParams({required this.query});

  @override
  String toString() => 'SearchMenuItemsParams(query: $query)';
}

class SearchMenuItemsUseCase
    extends BaseUseCase<List<MenuItem>, SearchMenuItemsParams> {
  final MenuRepository repository;

  SearchMenuItemsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MenuItem>>> call(
    SearchMenuItemsParams params,
  ) async {
    try {
      if (params.query.isEmpty) {
        return const Left(ServerFailure(message: 'نص البحث مطلوب'));
      }

      if (params.query.length < 2) {
        return const Left(
          ServerFailure(message: 'نص البحث يجب أن يكون أكثر من حرفين'),
        );
      }

      return await repository.searchMenuItems(params.query);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل في البحث عن المنتجات: $e'));
    }
  }
}
