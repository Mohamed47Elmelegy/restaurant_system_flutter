import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
import '../network/dio_client.dart';
import '../network/simple_interceptor.dart';

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

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeDataSource>()),
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

  // Bloc
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
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
}
