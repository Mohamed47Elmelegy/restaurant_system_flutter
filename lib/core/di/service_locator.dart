import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/simple_interceptor.dart';
import '../../features/Home/data/datasources/home_datasource.dart';
import '../../features/Home/data/repositories/home_repository_impl.dart';
import '../../features/Home/domain/repositories/home_repository.dart';
import '../../features/Home/domain/usecases/get_categories_usecase.dart';
import '../../features/Home/domain/usecases/get_popular_items_usecase.dart';
import '../../features/Home/domain/usecases/get_recommended_items_usecase.dart';
import '../../features/Home/presentation/bloc/home_bloc.dart';
import '../../features/Home/presentation/cubit/category_items_cubit.dart';
// Address imports
import '../../features/address/data/datasources/address_remote_data_source.dart';
import '../../features/address/data/datasources/address_remote_data_source_impl.dart';
import '../../features/address/data/repositories/address_repository_impl.dart';
import '../../features/address/domain/repositories/address_repository.dart';
import '../../features/address/domain/usecases/add_address_usecase.dart';
import '../../features/address/domain/usecases/delete_address_usecase.dart';
import '../../features/address/domain/usecases/get_addresses_usecase.dart';
import '../../features/address/domain/usecases/set_default_address_usecase.dart';
import '../../features/address/domain/usecases/update_address_usecase.dart';
import '../../features/address/presentation/cubit/address_cubit.dart';
import '../../features/admin/presentation/pages/add_category/data/datasources/category_local_data_source.dart';
import '../../features/admin/presentation/pages/add_category/data/datasources/category_remote_data_source.dart';
import '../../features/admin/presentation/pages/add_category/data/datasources/category_remote_data_source_impl.dart';
import '../../features/admin/presentation/pages/add_category/data/repositories/category_repository_impl.dart';
import '../../features/admin/presentation/pages/add_category/domain/repositories/category_repository.dart';
import '../../features/admin/presentation/pages/add_category/domain/usecases/create_category_usecase.dart';
import '../../features/admin/presentation/pages/add_category/domain/usecases/get_categories_usecase.dart'
    as admin_category;
import '../../features/admin/presentation/pages/add_category/domain/usecases/get_category_by_id_usecase.dart';
import '../../features/admin/presentation/pages/add_category/domain/usecases/update_category_usecase.dart';
import '../../features/admin/presentation/pages/add_category/presentation/cubit/category_cubit.dart';
import '../../features/admin/presentation/pages/add_items/data/datasources/product_local_data_source.dart';
import '../../features/admin/presentation/pages/add_items/data/datasources/remoteDataSource/product_remote_data_source.dart';
import '../../features/admin/presentation/pages/add_items/data/datasources/remoteDataSource/product_remote_data_source_imp.dart';
import '../../features/admin/presentation/pages/add_items/data/repositories/product_repository_impl.dart';
import '../../features/admin/presentation/pages/add_items/domain/repositories/product_repository.dart';
import '../../features/admin/presentation/pages/add_items/domain/usecases/create_product_usecase.dart';
import '../../features/admin/presentation/pages/add_items/domain/usecases/get_products_usecase.dart';
import '../../features/admin/presentation/pages/add_items/presentation/cubit/product_cubit.dart';
import '../../features/admin/presentation/pages/meal_times/data/datasources/meal_time_remote_datasource.dart';
import '../../features/admin/presentation/pages/meal_times/data/datasources/meal_time_remote_datasource_impl.dart';
import '../../features/admin/presentation/pages/meal_times/data/repositories/meal_time_repository_impl.dart';
import '../../features/admin/presentation/pages/meal_times/domain/repositories/meal_time_repository.dart';
import '../../features/admin/presentation/pages/meal_times/domain/usecases/create_meal_time.dart';
import '../../features/admin/presentation/pages/meal_times/domain/usecases/delete_meal_time.dart';
import '../../features/admin/presentation/pages/meal_times/domain/usecases/get_meal_times.dart';
import '../../features/admin/presentation/pages/meal_times/domain/usecases/toggle_meal_time_status.dart';
import '../../features/admin/presentation/pages/meal_times/domain/usecases/update_meal_time.dart';
import '../../features/admin/presentation/pages/meal_times/domain/usecases/update_meal_times_order.dart';
import '../../features/admin/presentation/pages/meal_times/presentation/bloc/meal_time_bloc.dart';
import '../../features/admin/presentation/pages/menu/data/datasources/menu_local_data_source.dart';
// Menu imports
import '../../features/admin/presentation/pages/menu/data/datasources/menu_remote_data_source.dart';
import '../../features/admin/presentation/pages/menu/data/repositories/menu_repository_impl.dart';
import '../../features/admin/presentation/pages/menu/domain/repositories/menu_repository.dart';
import '../../features/admin/presentation/pages/menu/presentation/bloc/menu_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
// Cart imports
import '../../features/cart/data/datasources/cart_remote_data_source.dart';
import '../../features/cart/data/datasources/cart_remote_data_source_impl.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_to_cart_usecase.dart';
import '../../features/cart/domain/usecases/clear_cart_usecase.dart';
import '../../features/cart/domain/usecases/get_cart_usecase.dart';
import '../../features/cart/domain/usecases/remove_cart_item_usecase.dart';
import '../../features/cart/domain/usecases/update_cart_item_usecase.dart';
import '../../features/cart/presentation/bloc/cart_cubit.dart';
import '../../features/checkout/data/datasources/check_out_remote_data_source.dart';
import '../../features/checkout/data/repositories/check_out_repository_impl.dart';
import '../../features/checkout/domain/repositories/check_out_repository.dart';
import '../../features/checkout/domain/usecases/check_out_place_order_usecase.dart';
import '../../features/checkout/domain/usecases/initialize_checkout_usecase.dart';
import '../../features/checkout/domain/usecases/navigate_checkout_usecase.dart';
import '../../features/checkout/domain/usecases/update_checkout_step_usecase.dart';
import '../../features/orders/data/datasources/order_remote_data_source.dart';
import '../../features/orders/data/datasources/order_remote_data_source_implementation.dart';
import '../../features/orders/data/datasources/table_remote_data_source_impl.dart';
import '../../features/orders/data/datasources/table_remote_datasource.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/data/repositories/table_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/orders/domain/repositories/table_repository.dart';
import '../../features/orders/domain/usecases/cancel_order_usecase.dart';
import '../../features/orders/domain/usecases/get_all_orders_usecase.dart';
import '../../features/orders/domain/usecases/get_running_orders_usecase.dart';
import '../../features/orders/domain/usecases/mark_order_done_usecase.dart';
import '../../features/orders/domain/usecases/place_order_usecase.dart';
import '../../features/orders/domain/usecases/update_order_status_usecase.dart';
import '../../features/orders/domain/usecases/update_table_occupancy_usecase.dart';
import '../../features/orders/presentation/bloc/order_bloc.dart';
import '../../features/orders/presentation/cubit/order_cubit.dart';
import '../../features/orders/presentation/cubit/table_cubit.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // External
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
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
  // Use configured DioClient so SimpleInterceptor adds auth token automatically
  getIt.registerLazySingleton<HomeDataSource>(
    () => HomeDataSourceImpl(getIt<DioClient>().dio),
  );
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
  // Cart data source
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(getIt<DioClient>().dio),
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
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: getIt<OrderRemoteDataSource>()),
  );
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
  // Cart repository
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: getIt<CartRemoteDataSource>()),
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

  getIt.registerLazySingleton<GetAllOrdersUseCase>(
    () => GetAllOrdersUseCase(getIt<OrderRepository>()),
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
  getIt.registerLazySingleton<UpdateOrderStatusUseCase>(
    () => UpdateOrderStatusUseCase(getIt<OrderRepository>()),
  );
  getIt.registerLazySingleton<UpdateTableOccupancyUseCase>(
    () => UpdateTableOccupancyUseCase(getIt<TableRepository>()),
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

  // Cart use cases
  getIt.registerLazySingleton<GetCartUseCase>(
    () => GetCartUseCase(repository: getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(repository: getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<UpdateCartItemUseCase>(
    () => UpdateCartItemUseCase(repository: getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<RemoveCartItemUseCase>(
    () => RemoveCartItemUseCase(repository: getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<ClearCartUseCase>(
    () => ClearCartUseCase(repository: getIt<CartRepository>()),
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
    ),
  );
  getIt.registerFactory<CategoryItemsCubit>(
    () => CategoryItemsCubit(homeRepository: getIt<HomeRepository>()),
  );
  getIt.registerFactory<OrderBloc>(
    () => OrderBloc(
      getAllOrdersUseCase: getIt<GetAllOrdersUseCase>(),
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

  // Cart cubit - Singleton to maintain cart state across pages
  getIt.registerLazySingleton<CartCubit>(
    () => CartCubit(
      getCartUseCase: getIt<GetCartUseCase>(),
      addToCartUseCase: getIt<AddToCartUseCase>(),
      updateCartItemUseCase: getIt<UpdateCartItemUseCase>(),
      removeCartItemUseCase: getIt<RemoveCartItemUseCase>(),
      clearCartUseCase: getIt<ClearCartUseCase>(),
    ),
  );

  // ==================== ADDRESS FEATURE ====================

  // Address data sources
  getIt.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // Address repository
  getIt.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(
      remoteDataSource: getIt<AddressRemoteDataSource>(),
    ),
  );

  // Address use cases
  getIt.registerLazySingleton<GetAddressesUseCase>(
    () => GetAddressesUseCase(repository: getIt<AddressRepository>()),
  );
  getIt.registerLazySingleton<AddAddressUseCase>(
    () => AddAddressUseCase(repository: getIt<AddressRepository>()),
  );
  getIt.registerLazySingleton<UpdateAddressUseCase>(
    () => UpdateAddressUseCase(repository: getIt<AddressRepository>()),
  );
  getIt.registerLazySingleton<DeleteAddressUseCase>(
    () => DeleteAddressUseCase(repository: getIt<AddressRepository>()),
  );
  getIt.registerLazySingleton<SetDefaultAddressUseCase>(
    () => SetDefaultAddressUseCase(repository: getIt<AddressRepository>()),
  );

  // Address cubit - Singleton to maintain address state across pages
  getIt.registerLazySingleton<AddressCubit>(
    () => AddressCubit(
      getAddressesUseCase: getIt<GetAddressesUseCase>(),
      addAddressUseCase: getIt<AddAddressUseCase>(),
      updateAddressUseCase: getIt<UpdateAddressUseCase>(),
      deleteAddressUseCase: getIt<DeleteAddressUseCase>(),
      setDefaultAddressUseCase: getIt<SetDefaultAddressUseCase>(),
    ),
  );

  // ==================== CHECKOUT FEATURE ====================
  getIt.registerLazySingleton<CheckOutRemoteDataSource>(
    () => CheckOutRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CheckOutRepository>(
    () => CheckOutRepositoryImpl(getIt<CheckOutRemoteDataSource>()),
  );
  getIt.registerLazySingleton<CheckOutPlaceOrderUseCase>(
    () => CheckOutPlaceOrderUseCase(getIt<CheckOutRepository>()),
  );

  // Modern checkout use cases
  getIt.registerLazySingleton<InitializeCheckoutUseCase>(
    () => InitializeCheckoutUseCase(),
  );
  getIt.registerLazySingleton<UpdateCheckoutStepUseCase>(
    () => UpdateCheckoutStepUseCase(),
  );
  getIt.registerLazySingleton<NavigateCheckoutUseCase>(
    () => NavigateCheckoutUseCase(),
  );

  // ==================== ORDERS FEATURE ====================
  // Data Source
  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(getIt<DioClient>().dio),
  );

  // Repository
  // getIt.registerLazySingleton<OrderRepository>(
  //   () => OrderRepositoryImpl(getIt<OrderRemoteDataSource>()),
  // );

  // UseCase
  getIt.registerLazySingleton<PlaceOrderUseCase>(
    () => PlaceOrderUseCase(getIt<OrderRepository>()),
  );

  // Cubit
  getIt.registerFactory<OrderCubit>(
    () => OrderCubit(getIt<PlaceOrderUseCase>()),
  );

  // ==================== TABLE FEATURE ====================
  // Table Data Source
  getIt.registerLazySingleton<TableRemoteDataSource>(
    () => TableRemoteDataSourceImpl(getIt<Dio>()),
  );

  // Table Repository
  getIt.registerLazySingleton<TableRepository>(
    () => TableRepositoryImpl(getIt<TableRemoteDataSource>()),
  );

  // Table Cubit
  getIt.registerFactory<TableCubit>(() => TableCubit(getIt<TableRepository>()));
}
