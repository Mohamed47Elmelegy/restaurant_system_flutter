import 'endpoints.dart';

class ApiPath {
  // ==================== AUTHENTICATION PATHS ====================
  static String login() => Endpoints.getUrl(Endpoints.login);
  static String register() => Endpoints.getUrl(Endpoints.register);
  static String user() => Endpoints.getUrl(Endpoints.user);

  // ==================== MEAL TIMES PATHS ====================
  static String mealTimes() => Endpoints.getUrl(Endpoints.mealTimes);
  static String currentMealTime() =>
      Endpoints.getUrl(Endpoints.currentMealTime);
  static String adminMealTimes() => Endpoints.getUrl(Endpoints.adminMealTimes);

  // Meal time management
  static String createMealTime() => Endpoints.getUrl(Endpoints.createMealTime);
  static String updateMealTime(int id) =>
      Endpoints.getUrlWithId(Endpoints.updateMealTime, id);
  static String deleteMealTime(int id) =>
      Endpoints.getUrlWithId(Endpoints.deleteMealTime, id);
  static String toggleMealTimeStatus(int id) => Endpoints.getUrlWithIdAndAction(
    Endpoints.toggleMealTimeStatus,
    id,
    'toggle',
  );
  static String reorderMealTimes() =>
      Endpoints.getUrl(Endpoints.reorderMealTimes);
  static String mealTimeCategories(int mealTimeId) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.mealTimeCategories,
        mealTimeId,
        'categories',
      );

  // ==================== CATEGORIES PATHS ====================
  static String categories() => Endpoints.getUrl(Endpoints.categories);
  static String category(int id) =>
      Endpoints.getUrlWithId(Endpoints.category, id);
  static String categorySubCategories(int id) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.categorySubCategories,
        id,
        'sub-categories',
      );

  // Admin categories
  static String adminCategories() =>
      Endpoints.getUrl(Endpoints.adminCategories);
  static String adminCategory(int id) =>
      Endpoints.getUrlWithId(Endpoints.adminCategory, id);
  static String adminCategorySubCategories(int id) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.adminCategorySubCategories,
        id,
        'sub-categories',
      );

  // ==================== PRODUCTS PATHS ====================
  static String products() => Endpoints.getUrl(Endpoints.products);
  static String product(int id) =>
      Endpoints.getUrlWithId(Endpoints.product, id);
  static String categoryProducts(int categoryId) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.categoryProducts,
        categoryId,
        'products',
      );

  // Admin products
  static String adminProducts() => Endpoints.getUrl(Endpoints.adminProducts);
  static String adminProduct(int id) =>
      Endpoints.getUrlWithId(Endpoints.adminProduct, id);
  static String adminProductToggleAvailability(int id) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.adminProductToggleAvailability,
        id,
        'toggle-availability',
      );
  static String adminProductToggleFeatured(int id) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.adminProductToggleFeatured,
        id,
        'toggle-featured',
      );
  static String adminProductsBulkAvailability() =>
      Endpoints.getUrl(Endpoints.adminProductsBulkAvailability);
  static String adminProductsStatistics() =>
      Endpoints.getUrl(Endpoints.adminProductsStatistics);
  static String adminCategoryProducts(int categoryId) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.adminCategoryProducts,
        categoryId,
        'products',
      );

  // ==================== DASHBOARD PATHS ====================
  static String adminDashboardStatistics() =>
      Endpoints.getUrl(Endpoints.adminDashboardStatistics);

  // ==================== ORDERS PATHS ====================
  static String adminOrders() => Endpoints.getUrl(Endpoints.adminOrders);
  static String adminOrder(int id) =>
      Endpoints.getUrlWithId(Endpoints.adminOrder, id);
  static String adminOrderStatus(int id) =>
      Endpoints.getUrlWithIdAndAction(Endpoints.adminOrderStatus, id, 'status');
  static String adminOrdersStatistics() =>
      Endpoints.getUrl(Endpoints.adminOrdersStatistics);

  // ==================== NOTIFICATIONS PATHS ====================
  static String adminNotifications() =>
      Endpoints.getUrl(Endpoints.adminNotifications);
  static String adminNotification(int id) =>
      Endpoints.getUrlWithId(Endpoints.adminNotification, id);
  static String adminNotificationRead(int id) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.adminNotificationRead,
        id,
        'read',
      );
}
