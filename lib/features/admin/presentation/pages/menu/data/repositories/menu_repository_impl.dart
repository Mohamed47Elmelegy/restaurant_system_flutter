import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import '../models/menu_item_model.dart';
import '../datasources/menu_remote_data_source.dart';
import '../../../../../../../core/error/failures.dart';
import '../../../../../../../core/error/simple_error.dart';
import 'package:dartz/dartz.dart';
import 'dart:developer';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MenuItem>>> getMenuItems() async {
    try {
      final menuItemModels = await remoteDataSource.getMenuItems();
      final menuItems = menuItemModels
          .map((model) => model.toEntity())
          .toList();
      return Right(menuItems);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get menu items: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MenuItem>>> getMenuItemsByCategory(
    String category,
  ) async {
    try {
      final menuItemModels = await remoteDataSource.getMenuItemsByCategory(
        category,
      );
      final menuItems = menuItemModels
          .map((model) => model.toEntity())
          .toList();
      return Right(menuItems);
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get menu items by category: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, MenuItem?>> getMenuItemById(String id) async {
    try {
      final menuItemModel = await remoteDataSource.getMenuItemById(id);
      return Right(menuItemModel?.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get menu item: $e'));
    }
  }

  @override
  Future<Either<Failure, MenuItem>> addMenuItem(MenuItem menuItem) async {
    try {
      final menuItemModel = MenuItemModel.fromEntity(menuItem);
      final createdMenuItemModel = await remoteDataSource.addMenuItem(
        menuItemModel,
      );
      return Right(createdMenuItemModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to add menu item: $e'));
    }
  }

  @override
  Future<Either<Failure, MenuItem>> updateMenuItem(MenuItem menuItem) async {
    try {
      final menuItemModel = MenuItemModel.fromEntity(menuItem);
      final updatedMenuItemModel = await remoteDataSource.updateMenuItem(
        menuItemModel,
      );
      return Right(updatedMenuItemModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update menu item: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMenuItem(String id) async {
    try {
      final result = await remoteDataSource.deleteMenuItem(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete menu item: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MenuItem>>> searchMenuItems(String query) async {
    try {
      final menuItemModels = await remoteDataSource.searchMenuItems(query);
      final menuItems = menuItemModels
          .map((model) => model.toEntity())
          .toList();
      return Right(menuItems);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to search menu items: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      log('🔄 MenuRepository: Starting getCategories process...');

      final categoriesData = await remoteDataSource.getCategories();

      if (categoriesData.isEmpty) {
        log(
          '⚠️ MenuRepository: No categories received from backend, using fallback',
        );
        return Right([
          'Fast Food',
          'Pizza',
          'Beverages',
          'Desserts',
          'Salads',
          'Drinks',
          'Appetizers',
          'Main Course',
        ]);
      }

      final categories = categoriesData
          .map((cat) => cat['name'] as String)
          .where((name) => name.isNotEmpty)
          .toList();

      log(
        '✅ MenuRepository: Successfully loaded ${categories.length} categories from backend',
      );
      log('📋 MenuRepository: Categories: $categories');

      return Right(categories);
    } catch (e) {
      log('❌ MenuRepository: Failed to get categories from backend - $e');
      log('🔄 MenuRepository: Using fallback categories');

      return Right([
        'Fast Food',
        'Pizza',
        'Beverages',
        'Desserts',
        'Salads',
        'Drinks',
        'Appetizers',
        'Main Course',
      ]);
    }
  }

  // BaseRepository implementations
  @override
  Future<Either<Failure, List<MenuItem>>> getAll() async {
    return getMenuItems();
  }

  @override
  Future<Either<Failure, MenuItem?>> getById(String id) async {
    return getMenuItemById(id);
  }

  @override
  Future<Either<Failure, MenuItem>> add(MenuItem item) async {
    return addMenuItem(item);
  }

  @override
  Future<Either<Failure, MenuItem>> update(String id, MenuItem item) async {
    final updatedMenuItem = item.copyWith(id: id);
    return updateMenuItem(updatedMenuItem);
  }

  @override
  Future<Either<Failure, bool>> delete(String id) async {
    return deleteMenuItem(id);
  }

  @override
  Future<Either<Failure, List<MenuItem>>> search(String query) async {
    return searchMenuItems(query);
  }

  @override
  Future<Either<Failure, List<MenuItem>>> getPaginated({
    int page = 1,
    int limit = 10,
    String? sortBy,
    bool ascending = true,
  }) async {
    try {
      // TODO: Implement getMenuItemsPaginated method in MenuRemoteDataSource
      return Left(
        ServerFailure(message: 'Paginated menu items not implemented yet'),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get paginated menu items: $e'),
      );
    }
  }
}
