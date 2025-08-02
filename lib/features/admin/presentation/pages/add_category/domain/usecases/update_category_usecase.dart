import 'package:dartz/dartz.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import '../../domain/entities/main_category.dart';
import '../../data/repositories/category_repository.dart';

/// 🟦 UpdateCategoryUseCase - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تحديث فئة موجودة فقط
class UpdateCategoryUseCase extends BaseUseCase<MainCategory, MainCategory> {
  final CategoryRepository repository;

  UpdateCategoryUseCase({required this.repository});

  @override
  Future<Either<Failure, MainCategory>> call(MainCategory category) async {
    try {
      final validationResult = _validateCategory(category);
      return validationResult.fold((failure) => Left(failure), (_) async {
        return await repository.update(category.id, category);
      });
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update category: $e'));
    }
  }

  /// Validate category data
  Either<Failure, void> _validateCategory(MainCategory category) {
    final errors = <String>[];

    if (category.id.isEmpty) {
      errors.add('معرف الفئة مطلوب');
    }

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
