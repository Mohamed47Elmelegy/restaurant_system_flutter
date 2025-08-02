import 'package:dartz/dartz.dart';
import 'dart:developer';
import '../../../../../../../core/error/failures.dart';
import '../../../add_category/data/datasources/category_remote_data_source.dart';
import '../../domain/entities/category/main_category.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MainCategory>>> getCategories({
    int? mealTimeId,
  }) async {
    try {
      log('🔄 Repository: Starting getCategories process');

      final response = await remoteDataSource.getCategories(
        mealTimeId: mealTimeId,
      );

      if (response.isSuccess && response.data != null) {
        log('📦 Repository: ${response.data!.length} categories received');

        final categories = response.data!
            .map((model) => model.toEntity())
            .toList();

        log('✅ Repository: Categories converted to entities successfully');
        return Right(categories);
      } else {
        log('❌ Repository: getCategories failed - ${response.message}');
        return Left(
          NetworkFailure(message: response.message, code: 'CATEGORIES_ERROR'),
        );
      }
    } catch (e) {
      log('💥 Repository: getCategories error caught: $e');
      return Left(
        NetworkFailure(message: e.toString(), code: 'CATEGORIES_ERROR'),
      );
    }
  }
}
