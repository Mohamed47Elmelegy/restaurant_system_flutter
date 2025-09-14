import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:restaurant_system_flutter/core/entities/product.dart';
import 'package:restaurant_system_flutter/core/error/failures.dart';

import '../../../../core/entities/main_category.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      // جلب البيانات من الـ API مباشرةً
      log('🌐 ProductRepository: Fetching from API...');
      final response = await remoteDataSource.getCategories();

      if (response.status) {
        final categories = response.data!
            .map((model) => model.toEntity())
            .toList();
        log(
          '🌐 ProductRepository: Fetched ${categories.length} categories from API',
        );

        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      log('❌ ProductRepository: Error getting products - $e');
      return Left(ServerFailure(message: 'Failed to get products: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getPopularItems() async {
    try {
      final response = await remoteDataSource.getPopularItems();
      if (response.status) {
        final products = response.data!
            .map((model) => model.toEntity())
            .toList();
        return Right(products);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get popular items: $e'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity?>> getCategoryById(String id) async {
    try {
      // 1. محاولة جلب الفئة من الـ local أولاً
      // final localCategory = await localDataSource.getMainCategoryById(id);
      // if (localCategory != null) {
      //   print('📱 CategoryRepository: Found category in local storage');
      //   final category = localCategory.toEntity();
      //   return Right(category);
      // }

      // 2. جلب الفئة من الـ API
      print('🌐 CategoryRepository: Fetching category from API...');
      final categoryId = int.tryParse(id);
      if (categoryId == null) {
        return const Left(ServerFailure(message: 'Invalid category ID'));
      }

      final response = await remoteDataSource.getCategoryById(categoryId);
      if (response.status) {
        final category = response.data?.toEntity();
        return Right(category);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      print('❌ CategoryRepository: Error getting category by ID - $e');
      return Left(ServerFailure(message: 'Failed to get category by ID: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    int categoryId,
  ) async {
    try {
      final response = await remoteDataSource.getProductsByCategory(categoryId);
      if (response.status) {
        final products = response.data!
            .map((model) => model.toEntity())
            .toList();
        return Right(products);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get products by category: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getRecommendedItems() async {
    try {
      final response = await remoteDataSource.getRecommendedItems();
      if (response.status) {
        final products = response.data!
            .map((model) => model.toEntity())
            .toList();
        return Right(products);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get recommended items: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, CategoryEntity?>> getCategoryByName(
    String name,
  ) async {
    try {
      final response = await remoteDataSource.getCategoryByName(name);
      if (response.status) {
        final category = response.data?.toEntity();
        return Right(category);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get category by name: $e'));
    }
  }
}
