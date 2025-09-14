import 'package:dartz/dartz.dart';

import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/menu_item.dart';

class ValidateMenuItemParams {
  final MenuItem item;

  const ValidateMenuItemParams({required this.item});

  @override
  String toString() => 'ValidateMenuItemParams(item: ${item.name})';
}

/// Use case for validating menu item data
class ValidateMenuItemUseCase
    extends BaseUseCase<bool, ValidateMenuItemParams> {
  /// Validate menu item data
  @override
  Future<Either<Failure, bool>> call(ValidateMenuItemParams params) async {
    try {
      final isValid = _isValid(params.item);
      if (isValid) {
        return const Right(true);
      } else {
        return const Left(ServerFailure(message: 'Menu item validation failed'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Validation error: $e'));
    }
  }

  bool _isValid(MenuItem item) {
    return item.id.isNotEmpty &&
        item.name.isNotEmpty &&
        item.category.isNotEmpty &&
        item.price.isNotEmpty &&
        item.rating >= 0 &&
        item.rating <= 5 &&
        item.reviewCount >= 0;
  }

  /// Validate menu item with detailed error messages
  Map<String, String> validateWithErrors(MenuItem item) {
    final errors = <String, String>{};

    if (item.id.isEmpty) {
      errors['id'] = 'ID is required';
    }

    if (item.name.isEmpty) {
      errors['name'] = 'Name is required';
    }

    if (item.category.isEmpty) {
      errors['category'] = 'Category is required';
    }

    if (item.price.isEmpty) {
      errors['price'] = 'Price is required';
    }

    if (item.rating < 0 || item.rating > 5) {
      errors['rating'] = 'Rating must be between 0 and 5';
    }

    if (item.reviewCount < 0) {
      errors['reviewCount'] = 'Review count must be positive';
    }

    return errors;
  }

  /// Check if menu item can be saved
  bool canBeSaved(MenuItem item) {
    return _isValid(item);
  }
}
