import 'package:dartz/dartz.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import '../../domain/entities/main_category.dart';
import '../../data/repositories/category_repository.dart';

/// 🟦 CreateCategoryUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن إنشاء فئة جديدة فقط
class CreateCategoryUseCase extends BaseUseCase<MainCategory, MainCategory> {
  final CategoryRepository repository;

  CreateCategoryUseCase({required this.repository});

  @override
  Future<Either<Failure, MainCategory>> call(MainCategory category) async {
    try {
      final validationResult = _validateCategory(category);
      return validationResult.fold((failure) => Left(failure), (_) async {
        return await repository.add(category);
      });
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create category: $e'));
    }
  }

  /// Validate category data
  Either<Failure, void> _validateCategory(MainCategory category) {
    final errors = <String>[];

    if (category.name.isEmpty) {
      errors.add('اسم الفئة مطلوب');
    }

    if (category.nameAr.isEmpty) {
      errors.add('اسم الفئة بالعربية مطلوب');
    }

    if (category.sortOrder < 0) {
      errors.add('ترتيب الفئة يجب أن يكون أكبر من أو يساوي صفر');
    }

    if (errors.isNotEmpty) {
      return Left(ServerFailure(message: errors.join(', ')));
    }

    return const Right(null);
  }
}
