import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'core/di/service_locator.dart';
import 'core/network/custom_cache_manager.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'core/services/app_bloc_observer.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive للتخزين المحلي
  await Hive.initFlutter();

  // تهيئة CacheManager المخصص مع معالجة الأخطاء
  try {
    await CustomCacheManager.getCachePath();
  } catch (e) {
    // تجاهل أخطاء التهيئة - سيتم التعامل معها لاحقاً
  }

  Bloc.observer = AppBlocObserver();
  await setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => getIt<AuthBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'Restaurant System',
                builder: EasyLoading.init(builder: BotToastInit()),
                initialRoute: AppRoutes.splash,
                onGenerateRoute: appRouter,
                theme: AppTheme.lightTheme.copyWith(
                  extensions: const [SkeletonizerConfigData()],
                ),
                darkTheme: AppTheme.darkTheme.copyWith(
                  extensions: const [SkeletonizerConfigData.dark()],
                ),
                themeMode: themeState.themeMode,
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
              );
            },
          );
        },
      ),
    );
  }
}
