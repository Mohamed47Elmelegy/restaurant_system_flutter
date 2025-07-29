import 'endpoints.dart';

class ApiPath {
  // Auth paths
  static String login() => Endpoints.baseUrl + Endpoints.login;
  static String register() => Endpoints.baseUrl + Endpoints.register;
  static String user() => Endpoints.baseUrl + Endpoints.user;

  // Meal time paths
  static String mealTimes() => '${Endpoints.baseUrl}${Endpoints.mealTimes}';
  static String currentMealTime() =>
      '${Endpoints.baseUrl}${Endpoints.currentMealTime}';
  static String mealTimeCategories(int mealTimeId) =>
      '${Endpoints.baseUrl}/public/meal-times/$mealTimeId/categories';

  // Admin meal time paths
  static String adminMealTimes() =>
      '${Endpoints.baseUrl}${Endpoints.adminMealTimes}';

  // Add more helpers as needed
}
