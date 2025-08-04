import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import '../models/menu_item_model.dart';
import '../datasources/menu_remote_data_source.dart';
import '../datasources/menu_local_data_source.dart';
import '../../../../../../../core/error/failures.dart';
import '../../../../../../../core/error/simple_error.dart';
import 'package:dartz/dartz.dart';
import 'dart:developer';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;
  final MenuLocalDataSource localDataSource;

  MenuRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<MenuItem>>> getMenuItems() async {
    try {
      // 1. محاولة جلب البيانات من الـ local أولاً
      final localMenuItems = await localDataSource.getMenuItems();
      if (localMenuItems.isNotEmpty) {
        print(
          '📱 MenuRepository: Using local data - ${localMenuItems.length} menu items',
        );
        final menuItems = localMenuItems
            .map((model) => model.toEntity())
            .toList();
        return Right(menuItems);
      }

      // 2. جلب البيانات من الـ API
      print('🌐 MenuRepository: Fetching from API...');
      final menuItemModels = await remoteDataSource.getMenuItems();
      final menuItems = menuItemModels
          .map((model) => model.toEntity())
          .toList();

      // 3. حفظ البيانات محلياً
      if (menuItems.isNotEmpty) {
        final menuItemModelsForLocal = menuItems
            .map((entity) => MenuItemModel.fromEntity(entity))
            .toList();
        await localDataSource.saveMenuItems(menuItemModelsForLocal);
        print(
          '💾 MenuRepository: Saved ${menuItems.length} menu items to local storage',
        );
      }

      return Right(menuItems);
    } catch (e) {
      print('❌ MenuRepository: Error getting menu items - $e');
      return Left(ServerFailure(message: 'Failed to get menu items: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MenuItem>>> getMenuItemsByCategory(
    String category,
  ) async {
    try {
      // 1. محاولة جلب البيانات من الـ local أولاً
      final localMenuItems = await localDataSource.getMenuItemsByCategory(
        category,
      );
      if (localMenuItems.isNotEmpty) {
        print(
          '📱 MenuRepository: Using local data for category "$category" - ${localMenuItems.length} menu items',
        );
        final menuItems = localMenuItems
            .map((model) => model.toEntity())
            .toList();
        return Right(menuItems);
      }

      // 2. جلب البيانات من الـ API
      print('🌐 MenuRepository: Fetching menu items by category from API...');
      final menuItemModels = await remoteDataSource.getMenuItemsByCategory(
        category,
      );
      final menuItems = menuItemModels
          .map((model) => model.toEntity())
          .toList();

      // 3. حفظ البيانات محلياً
      if (menuItems.isNotEmpty) {
        final menuItemModelsForLocal = menuItems
            .map((entity) => MenuItemModel.fromEntity(entity))
            .toList();
        await localDataSource.saveMenuItems(menuItemModelsForLocal);
        print(
          '💾 MenuRepository: Saved menu items by category to local storage',
        );
      }

      return Right(menuItems);
    } catch (e) {
      print('❌ MenuRepository: Error getting menu items by category - $e');
      return Left(
        ServerFailure(message: 'Failed to get menu items by category: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, MenuItem?>> getMenuItemById(String id) async {
    try {
      // 1. محاولة جلب البيانات من الـ local أولاً
      final localMenuItem = await localDataSource.getMenuItemById(id);
      if (localMenuItem != null) {
        print(
          '📱 MenuRepository: Using local menu item - ${localMenuItem.name}',
        );
        return Right(localMenuItem.toEntity());
      }

      // 2. جلب البيانات من الـ API
      print('🌐 MenuRepository: Fetching menu item from API...');
      final menuItemModel = await remoteDataSource.getMenuItemById(id);
      if (menuItemModel != null) {
        final menuItem = menuItemModel.toEntity();

        // 3. حفظ البيانات محلياً
        await localDataSource.saveMenuItem(menuItemModel);
        print('💾 MenuRepository: Saved menu item to local storage');

        return Right(menuItem);
      }

      return Right(null);
    } catch (e) {
      print('❌ MenuRepository: Error getting menu item by ID - $e');
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
      final createdMenuItem = createdMenuItemModel.toEntity();

      // حفظ العنصر الجديد محلياً
      await localDataSource.saveMenuItem(createdMenuItemModel);
      print('💾 MenuRepository: Saved new menu item to local storage');

      return Right(createdMenuItem);
    } catch (e) {
      print('❌ MenuRepository: Error adding menu item - $e');
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
      final updatedMenuItem = updatedMenuItemModel.toEntity();

      // تحديث العنصر محلياً
      await localDataSource.saveMenuItem(updatedMenuItemModel);
      print('💾 MenuRepository: Updated menu item in local storage');

      return Right(updatedMenuItem);
    } catch (e) {
      print('❌ MenuRepository: Error updating menu item - $e');
      return Left(ServerFailure(message: 'Failed to update menu item: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMenuItem(String id) async {
    try {
      final result = await remoteDataSource.deleteMenuItem(id);
      if (result) {
        // حذف العنصر من التخزين المحلي
        await localDataSource.deleteMenuItem(id);
        print('🗑️ MenuRepository: Deleted menu item from local storage');
      }

      return Right(result);
    } catch (e) {
      print('❌ MenuRepository: Error deleting menu item - $e');
      return Left(ServerFailure(message: 'Failed to delete menu item: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MenuItem>>> searchMenuItems(String query) async {
    try {
      // 1. محاولة البحث في البيانات المحلية أولاً
      final localSearchResults = await localDataSource.searchMenuItems(query);
      if (localSearchResults.isNotEmpty) {
        print(
          '📱 MenuRepository: Using local search results - ${localSearchResults.length} menu items',
        );
        final menuItems = localSearchResults
            .map((model) => model.toEntity())
            .toList();
        return Right(menuItems);
      }

      // 2. البحث في الـ API
      print('🌐 MenuRepository: Searching in API...');
      final menuItemModels = await remoteDataSource.searchMenuItems(query);
      final menuItems = menuItemModels
          .map((model) => model.toEntity())
          .toList();

      // 3. حفظ نتائج البحث محلياً
      if (menuItems.isNotEmpty) {
        final menuItemModelsForLocal = menuItems
            .map((entity) => MenuItemModel.fromEntity(entity))
            .toList();
        await localDataSource.saveMenuItems(menuItemModelsForLocal);
        print('💾 MenuRepository: Saved search results to local storage');
      }

      return Right(menuItems);
    } catch (e) {
      print('❌ MenuRepository: Error searching menu items - $e');
      return Left(ServerFailure(message: 'Failed to search menu items: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      log('🔄 MenuRepository: Starting getCategories process...');

      // 1. محاولة جلب الفئات من الـ local أولاً
      final localCategoriesData = await localDataSource.getCategories();
      if (localCategoriesData.isNotEmpty) {
        log(
          '📱 MenuRepository: Using local categories - ${localCategoriesData.length} categories',
        );
        final localCategories = localCategoriesData
            .map((cat) => cat['name'] as String)
            .toList();
        return Right(localCategories);
      }

      // 2. جلب الفئات من الـ API
      log('🌐 MenuRepository: Fetching categories from API...');
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

      // 3. حفظ الفئات محلياً
      if (categories.isNotEmpty) {
        final categoriesData = categories
            .map((name) => {'name': name})
            .toList();
        await localDataSource.saveCategories(categoriesData);
        log('💾 MenuRepository: Saved categories to local storage');
      }

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
      // 1. محاولة جلب البيانات المحلية أولاً
      final localMenuItems = await localDataSource.getMenuItems();
      if (localMenuItems.isNotEmpty) {
        print(
          '📱 MenuRepository: Using local paginated data - ${localMenuItems.length} menu items',
        );
        final menuItems = localMenuItems
            .map((model) => model.toEntity())
            .toList();

        // تطبيق الـ pagination على البيانات المحلية
        final startIndex = (page - 1) * limit;
        final endIndex = startIndex + limit;
        final paginatedMenuItems = menuItems.length > startIndex
            ? menuItems.sublist(
                startIndex,
                endIndex > menuItems.length ? menuItems.length : endIndex,
              )
            : <MenuItem>[];

        return Right(paginatedMenuItems);
      }

      // 2. جلب البيانات من الـ API
      print('🌐 MenuRepository: Fetching paginated data from API...');
      // TODO: Implement getMenuItemsPaginated method in MenuRemoteDataSource
      return Left(
        ServerFailure(message: 'Paginated menu items not implemented yet'),
      );
    } catch (e) {
      print('❌ MenuRepository: Error getting paginated menu items - $e');
      return Left(
        ServerFailure(message: 'Failed to get paginated menu items: $e'),
      );
    }
  }

  // Additional methods for menu management
  Future<Either<Failure, List<MenuItem>>> getAvailableMenuItems() async {
    try {
      // 1. محاولة جلب البيانات المحلية أولاً
      final localAvailableItems = await localDataSource.getAvailableMenuItems();
      if (localAvailableItems.isNotEmpty) {
        print(
          '📱 MenuRepository: Using local available items - ${localAvailableItems.length} items',
        );
        final menuItems = localAvailableItems
            .map((model) => model.toEntity())
            .toList();
        return Right(menuItems);
      }

      // 2. جلب البيانات من الـ API (إذا كان متاحاً)
      print('🌐 MenuRepository: Fetching available items from API...');
      // TODO: Implement getAvailableMenuItems in MenuRemoteDataSource
      return Left(
        ServerFailure(message: 'Available menu items not implemented yet'),
      );
    } catch (e) {
      print('❌ MenuRepository: Error getting available menu items - $e');
      return Left(
        ServerFailure(message: 'Failed to get available menu items: $e'),
      );
    }
  }

  Future<Either<Failure, List<MenuItem>>> getFeaturedMenuItems() async {
    try {
      // 1. محاولة جلب البيانات المحلية أولاً
      final localFeaturedItems = await localDataSource.getFeaturedMenuItems();
      if (localFeaturedItems.isNotEmpty) {
        print(
          '📱 MenuRepository: Using local featured items - ${localFeaturedItems.length} items',
        );
        final menuItems = localFeaturedItems
            .map((model) => model.toEntity())
            .toList();
        return Right(menuItems);
      }

      // 2. جلب البيانات من الـ API (إذا كان متاحاً)
      print('🌐 MenuRepository: Fetching featured items from API...');
      // TODO: Implement getFeaturedMenuItems in MenuRemoteDataSource
      return Left(
        ServerFailure(message: 'Featured menu items not implemented yet'),
      );
    } catch (e) {
      print('❌ MenuRepository: Error getting featured menu items - $e');
      return Left(
        ServerFailure(message: 'Failed to get featured menu items: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<MenuItem>>> refreshMenuItems() {
    // TODO: implement refreshMenuItems
    throw UnimplementedError();
  }
}
