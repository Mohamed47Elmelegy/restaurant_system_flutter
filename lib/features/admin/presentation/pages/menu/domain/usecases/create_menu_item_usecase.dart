import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';
import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class CreateMenuItemParams {
  final String name;
  final String category;
  final double rating;
  final int reviewCount;
  final String price;
  final String imagePath;
  final String? description;
  final bool isAvailable;

  CreateMenuItemParams({
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.imagePath,
    this.description,
    this.isAvailable = true,
  });
}

class CreateMenuItemUseCase
    extends BaseUseCase<MenuItem, CreateMenuItemParams> {
  final MenuRepository repository;

  CreateMenuItemUseCase({required this.repository});

  @override
  Future<Either<Failure, MenuItem>> call(CreateMenuItemParams params) async {
    try {
      final validationResult = _validateMenuItem(params);
      return validationResult.fold((failure) => Left(failure), (_) async {
        final menuItem = MenuItem(
          id: '', // Will be set by the server
          name: params.name,
          category: params.category,
          rating: params.rating,
          reviewCount: params.reviewCount,
          price: params.price,
          imagePath: params.imagePath,
          description: params.description,
          isAvailable: params.isAvailable,
        );
        return await repository.addMenuItem(menuItem);
      });
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create menu item: $e'));
    }
  }

  Either<Failure, void> _validateMenuItem(CreateMenuItemParams params) {
    final errors = <String>[];

    if (params.name.isEmpty) {
      errors.add('Menu item name is required');
    }

    if (params.category.isEmpty) {
      errors.add('Menu item category is required');
    }

    if (params.price.isEmpty) {
      errors.add('Menu item price is required');
    }

    if (params.imagePath.isEmpty) {
      errors.add('Menu item image path is required');
    }

    if (params.rating < 0 || params.rating > 5) {
      errors.add('Rating must be between 0 and 5');
    }

    if (params.reviewCount < 0) {
      errors.add('Review count must be non-negative');
    }

    if (errors.isNotEmpty) {
      return Left(ServerFailure(message: errors.join(', ')));
    }

    return const Right(null);
  }
}
