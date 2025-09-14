import 'package:dartz/dartz.dart';

import '../../../../../../../core/base/base_usecase.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';

class ToggleMenuItemAvailabilityParams {
  final String id;
  final bool isAvailable;

  const ToggleMenuItemAvailabilityParams({
    required this.id,
    required this.isAvailable,
  });

  @override
  String toString() =>
      'ToggleMenuItemAvailabilityParams(id: $id, isAvailable: $isAvailable)';
}

class ToggleMenuItemAvailabilityUseCase
    extends BaseUseCase<MenuItem, ToggleMenuItemAvailabilityParams> {
  final MenuRepository repository;

  ToggleMenuItemAvailabilityUseCase({required this.repository});

  @override
  Future<Either<Failure, MenuItem>> call(
    ToggleMenuItemAvailabilityParams params,
  ) async {
    try {
      if (params.id.isEmpty) {
        return const Left(ServerFailure(message: 'معرف المنتج مطلوب'));
      }

      // First get the current menu item
      final currentItemResult = await repository.getMenuItemById(params.id);

      return currentItemResult.fold((failure) => Left(failure), (
        currentItem,
      ) async {
        if (currentItem == null) {
          return const Left(ServerFailure(message: 'المنتج غير موجود'));
        }

        // Create updated menu item with new availability
        final updatedItem = currentItem.copyWith(
          isAvailable: params.isAvailable,
        );

        // Update the menu item
        return repository.updateMenuItem(updatedItem);
      });
    } catch (e) {
      return Left(ServerFailure(message: 'فشل في تغيير حالة التوفر: $e'));
    }
  }
}
