import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:bot_toast/bot_toast.dart';
import 'core/di/service_locator.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/app_bloc_observer.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/services/snack_bar_service.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive للتخزين المحلي
  await Hive.initFlutter();

  Bloc.observer = AppBlocObserver();
  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ScreenUtilInit(
            designSize: const Size(375, 812), // iPhone X design size
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'Restaurant System',
                builder: EasyLoading.init(builder: BotToastInit()),
                initialRoute: AppRoutes.splash,
                onGenerateRoute: appRouter,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.themeMode,
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
