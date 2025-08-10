import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/service_locator.dart';
import '../../features/admin/presentation/pages/add_category/presentation/pages/admin_add_category_page.dart';
import '../../features/admin/presentation/pages/add_category/presentation/cubit/category_cubit.dart';
import '../../features/admin/presentation/pages/dashbord/presentation/pages/seller_dashboard_home.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/OnBoarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/Home/presentation/pages/home_page.dart';
import '../../features/admin/presentation/pages/admin.dart';
import '../../features/admin/presentation/pages/add_items/presentation/pages/admin_add_item_page.dart';
import '../../features/admin/presentation/pages/meal_times/presentation/pages/meal_time_management_page.dart';
import '../../features/menu/presentation/pages/product_details_page.dart';
import '../../features/Home/presentation/pages/category_items_page.dart';
import 'app_routes.dart';

Route<dynamic>? appRouter(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.splash:
      return MaterialPageRoute(builder: (_) => const SplashPage());
    case AppRoutes.onboarding:
      return MaterialPageRoute(builder: (_) => const OnboardingPage());
    case AppRoutes.login:
      return MaterialPageRoute(builder: (_) => const LoginPage());
    case AppRoutes.signup:
      return MaterialPageRoute(builder: (_) => const SignupPage());
    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => const HomePage());
    case AppRoutes.sellerDashboard:
      return MaterialPageRoute(builder: (_) => const SellerDashboardHome());
    case AppRoutes.admin:
      return MaterialPageRoute(builder: (_) => const AdminMainView());
    case AppRoutes.adminAddItem:
      return MaterialPageRoute(builder: (_) => const AdminAddItemPage());
    case AppRoutes.adminCategories:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<CategoryCubit>(),
          child: const AdminAddCategoryPage(),
        ),
      );
    case AppRoutes.adminMealTimes:
      return MaterialPageRoute(builder: (_) => const MealTimeManagementPage());
    case AppRoutes.productDetails:
      final product = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => ProductDetailsPage(product: product['product']),
      );
    case AppRoutes.categoryItems:
      final args = settings.arguments as Map<String, dynamic>;
      final int categoryId = args['categoryId'] as int;
      final String? categoryName = args['categoryName'] as String?;
      return MaterialPageRoute(
        builder: (_) => CategoryItemsPage(
          categoryId: categoryId,
          categoryName: categoryName,
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Page not  found'))),
      );
  }
}
