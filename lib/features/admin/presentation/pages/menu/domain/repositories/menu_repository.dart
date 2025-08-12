import 'package:dartz/dartz.dart';

import '../../../../../../../core/base/base_repository.dart';
import '../../../../../../../core/error/failures.dart';
import '../entities/menu_item.dart';

abstract class MenuRepository extends BaseRepository<MenuItem> {
  /// Get menu items with backward compatibility
  Future<Either<Failure, List<MenuItem>>> getMenuItems();

  /// Get menu items by category with backward compatibility
  Future<Either<Failure, List<MenuItem>>> getMenuItemsByCategory(
    String category,
  );

  /// Get menu item by string id for backward compatibility
  Future<Either<Failure, MenuItem?>> getMenuItemById(String id);

  /// Add menu item with backward compatibility
  Future<Either<Failure, MenuItem>> addMenuItem(MenuItem menuItem);

  /// Update menu item with backward compatibility
  Future<Either<Failure, MenuItem>> updateMenuItem(MenuItem menuItem);

  /// Delete menu item with backward compatibility
  Future<Either<Failure, bool>> deleteMenuItem(String id);

  /// Search menu items with backward compatibility
  Future<Either<Failure, List<MenuItem>>> searchMenuItems(String query);

  /// Get available categories
  Future<Either<Failure, List<String>>> getCategories();

  /// Refresh menu items from API and save to local storage
  Future<Either<Failure, List<MenuItem>>> refreshMenuItems();
}
