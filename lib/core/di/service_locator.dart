import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/admin/presentation/pages/add_items/data/datasources/remoteDataSource/product_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/Home/data/datasources/home_datasource.dart';
import '../../features/Home/data/repositories/home_repository_impl.dart';
import '../../features/Home/domain/repositories/home_repository.dart';
import '../../features/Home/domain/usecases/get_categories_usecase.dart';
import '../../features/Home/domain/usecases/get_popular_items_usecase.dart';
import '../../features/Home/domain/usecases/get_recommended_items_usecase.dart';
import '../../features/Home/domain/usecases/get_banners_usecase.dart';
import '../../features/Home/presentation/bloc/home_bloc.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/orders/domain/usecases/get_running_orders_usecase.dart';
import '../../features/orders/domain/usecases/mark_order_done_usecase.dart';
import '../../features/orders/domain/usecases/cancel_order_usecase.dart';
import '../../features/orders/presentation/bloc/order_bloc.dart';
import '../../features/admin/presentation/pages/meal_times/data/datasources/meal_time_remote_datasource.dart';
import '../../features/admin/presentation/pages/meal_times/data/datasources/meal_time_remote_datasource_impl.dart';
import '../../features/admin/presentation/pages/meal_times/data/repositories/meal_time_repository_impl.dart';
import '../../features/admin/presentation/pages/meal_times/domain/repositories/meal_time_repository.dart';
import '../../features/admin/presentation/pages/meal_times/domain/usecases/get_meal_times.dart';
import '../../features/admin/presentation/pages/meal_times/domain/usecases/create_meal_time.dart';
import '../../features/admin/presentation/pages/meal_times/domain/usecases/update_meal_time.dart';
import '../../features/admin/presentation/pages/meal_times/domain/usecases/delete_meal_time.dart';
import '../../features/admin/presentation/pages/meal_times/domain/usecases/toggle_meal_time_status.dart';
import '../../features/admin/presentation/pages/meal_times/domain/usecases/update_meal_times_order.dart';
import '../../features/admin/presentation/pages/meal_times/presentation/bloc/meal_time_bloc.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/simple_interceptor.dart';
import '../../features/admin/presentation/pages/add_items/data/datasources/remoteDataSource/product_remote_data_source_imp.dart';
import '../../features/admin/presentation/pages/add_items/data/repositories/product_repository_impl.dart';
import '../../features/admin/presentation/pages/add_items/domain/repositories/product_repository.dart';
import '../../features/admin/presentation/pages/add_items/domain/usecases/get_products_usecase.dart';
import '../../features/admin/presentation/pages/add_items/domain/usecases/create_product_usecase.dart';
import '../../features/admin/presentation/pages/add_items/presentation/cubit/product_cubit.dart';
// Menu imports
import '../../features/admin/presentation/pages/menu/data/datasources/menu_remote_data_source.dart';
import '../../features/admin/presentation/pages/menu/data/repositories/menu_repository_impl.dart';
import '../../features/admin/presentation/pages/menu/domain/repositories/menu_repository.dart';
import '../../features/admin/presentation/pages/menu/presentation/bloc/menu_cubit.dart';
import '../../features/admin/presentation/pages/add_category/data/datasources/category_remote_data_source.dart';
import '../../features/admin/presentation/pages/add_category/data/datasources/category_remote_data_source_impl.dart';
import '../../features/admin/presentation/pages/add_category/data/repositories/category_repository.dart';
import '../../features/admin/presentation/pages/add_category/data/repositories/category_repository_impl.dart';
import '../../features/admin/presentation/pages/add_category/presentation/cubit/category_cubit.dart';
import '../../features/admin/presentation/pages/add_category/domain/usecases/create_category_usecase.dart';
import '../../features/admin/presentation/pages/add_category/domain/usecases/update_category_usecase.dart';
import '../../features/admin/presentation/pages/add_category/domain/usecases/get_category_by_id_usecase.dart';
import '../../features/admin/presentation/pages/add_category/domain/usecases/get_categories_usecase.dart'
    as admin_category;
import '../../features/admin/presentation/pages/add_category/data/datasources/category_local_data_source.dart';
import '../../features/admin/presentation/pages/menu/data/datasources/menu_local_data_source.dart';
import '../../features/admin/presentation/pages/add_items/data/datasources/product_local_data_source.dart';
import '../../features/admin/presentation/pages/add_items/domain/usecases/get_products_usecase.dart';
import '../../features/admin/presentation/pages/add_items/domain/usecases/create_product_usecase.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // External
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );

  // Core
  getIt.registerLazySingleton<SimpleInterceptor>(
    () => SimpleInterceptor(getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(getIt<Dio>(), getIt<SimpleInterceptor>()),
  );

  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<HomeDataSource>(() => HomeDataSourceImpl());
  getIt.registerLazySingleton<MealTimeRemoteDataSource>(
    () => MealTimeRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(getIt<DioClient>().dio),
  );
  // Menu data sources
  getIt.registerLazySingleton<MenuRemoteDataSource>(
    () => MenuRemoteDataSourceImpl(dio: getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(getIt<DioClient>().dio),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<FlutterSecureStorage>(),
    ),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeDataSource>()),
  );
  getIt.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl());
  getIt.registerLazySingleton<MealTimeRepository>(
    () => MealTimeRepositoryImpl(
      remoteDataSource: getIt<MealTimeRemoteDataSource>(),
    ),
  );

  // Local Data Sources
  getIt.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<MenuLocalDataSource>(
    () => MenuLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: getIt<ProductRemoteDataSource>(),
      localDataSource: getIt<ProductLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl( 
      remoteDataSource: getIt<CategoryRemoteDataSource>(),
      localDataSource: getIt<CategoryLocalDataSource>(),
    ),
  );
  // Menu repository
  getIt.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(
      remoteDataSource: getIt<MenuRemoteDataSource>(),
      localDataSource: getIt<MenuLocalDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetPopularItemsUseCase>(
    () => GetPopularItemsUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetRecommendedItemsUseCase>(
    () => GetRecommendedItemsUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetBannersUseCase>(
    () => GetBannersUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetRunningOrdersUseCase>(
    () => GetRunningOrdersUseCase(getIt<OrderRepository>()),
  );
  getIt.registerLazySingleton<MarkOrderDoneUseCase>(
    () => MarkOrderDoneUseCase(getIt<OrderRepository>()),
  );
  getIt.registerLazySingleton<CancelOrderUseCase>(
    () => CancelOrderUseCase(getIt<OrderRepository>()),
  );

  // MealTime use cases
  getIt.registerLazySingleton<GetMealTimes>(
    () => GetMealTimes(repository: getIt<MealTimeRepository>()),
  );
  getIt.registerLazySingleton<CreateMealTime>(
    () => CreateMealTime(repository: getIt<MealTimeRepository>()),
  );
  getIt.registerLazySingleton<UpdateMealTime>(
    () => UpdateMealTime(repository: getIt<MealTimeRepository>()),
  );
  getIt.registerLazySingleton<DeleteMealTime>(
    () => DeleteMealTime(repository: getIt<MealTimeRepository>()),
  );
  getIt.registerLazySingleton<ToggleMealTimeStatus>(
    () => ToggleMealTimeStatus(repository: getIt<MealTimeRepository>()),
  );
  getIt.registerLazySingleton<UpdateMealTimesOrder>(
    () => UpdateMealTimesOrder(repository: getIt<MealTimeRepository>()),
  );

  // Product use cases
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(repository: getIt<ProductRepository>()),
  );
  getIt.registerLazySingleton<CreateProductUseCase>(
    () => CreateProductUseCase(repository: getIt<ProductRepository>()),
  );

  // Category use cases
  getIt.registerLazySingleton<CreateCategoryUseCase>(
    () => CreateCategoryUseCase(repository: getIt<CategoryRepository>()),
  );
  getIt.registerLazySingleton<admin_category.GetCategoriesUseCase>(
    () => admin_category.GetCategoriesUseCase(
      repository: getIt<CategoryRepository>(),
    ),
  );
  getIt.registerLazySingleton<UpdateCategoryUseCase>(
    () => UpdateCategoryUseCase(repository: getIt<CategoryRepository>()),
  );
  getIt.registerLazySingleton<GetCategoryByIdUseCase>(
    () => GetCategoryByIdUseCase(repository: getIt<CategoryRepository>()),
  );

  // Bloc
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getCategoriesUseCase: getIt<GetCategoriesUseCase>(),
      getPopularItemsUseCase: getIt<GetPopularItemsUseCase>(),
      getRecommendedItemsUseCase: getIt<GetRecommendedItemsUseCase>(),
      getBannersUseCase: getIt<GetBannersUseCase>(),
    ),
  );
  getIt.registerFactory<OrderBloc>(
    () => OrderBloc(
      getRunningOrdersUseCase: getIt<GetRunningOrdersUseCase>(),
      markOrderDoneUseCase: getIt<MarkOrderDoneUseCase>(),
      cancelOrderUseCase: getIt<CancelOrderUseCase>(),
    ),
  );
  getIt.registerFactory<MealTimeBloc>(
    () => MealTimeBloc(
      getMealTimes: getIt<GetMealTimes>(),
      createMealTime: getIt<CreateMealTime>(),
      updateMealTime: getIt<UpdateMealTime>(),
      deleteMealTime: getIt<DeleteMealTime>(),
      toggleMealTimeStatus: getIt<ToggleMealTimeStatus>(),
      updateMealTimesOrder: getIt<UpdateMealTimesOrder>(),
    ),
  );
  getIt.registerFactory<ProductCubit>(
    () => ProductCubit(
      getProductsUseCase: getIt<GetProductsUseCase>(),
      createProductUseCase: getIt<CreateProductUseCase>(),
    ),
  );
  // Menu cubit
  getIt.registerFactory<MenuCubit>(
    () => MenuCubit(menuRepository: getIt<MenuRepository>()),
  );

  // Category cubit
  getIt.registerFactory<CategoryCubit>(
    () => CategoryCubit(
      createCategoryUseCase: getIt<CreateCategoryUseCase>(),
      getCategoriesUseCase: getIt<admin_category.GetCategoriesUseCase>(),
      updateCategoryUseCase: getIt<UpdateCategoryUseCase>(),
      getCategoryByIdUseCase: getIt<GetCategoryByIdUseCase>(),
      categoryRepository: getIt<CategoryRepository>(),
    ),
  );
}
