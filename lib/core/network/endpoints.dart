class Endpoints {
  // Use localhost for Android emulator and 127.0.0.1 for iOS simulator
  //static const String baseUrl = 'http://192.168.1.31:8000/api/v1';
  // static const String baseUrl =
  //     'http://10.0.2.2:8000/api/v1'; // For Android Emulator
  // static const String baseUrl =
  //     'http://127.0.0.1:8000/api/v1'; // For iOS Simulator
  static const String baseUrl = 'http://localhost:8000/api/v1'; // For Web

  // ==================== AUTHENTICATION ENDPOINTS ====================
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String user = '/user';

  // ==================== MEAL TIMES ENDPOINTS ====================
  static const String mealTimes = '/public/meal-times';
  static const String currentMealTime = '/public/meal-times/current';
  static const String adminMealTimes = '/public/meal-times';

  // Meal time management (admin only)
  static const String createMealTime = '/public/meal-times';
  static const String updateMealTime = '/public/meal-times'; // + /{id}
  static const String deleteMealTime = '/public/meal-times'; // + /{id}
  static const String toggleMealTimeStatus =
      '/public/meal-times'; // + /{id}/toggle
  static const String reorderMealTimes = '/public/meal-times/reorder';
  static const String mealTimeCategories =
      '/public/meal-times'; // + /{id}/categories

  // ==================== CATEGORIES ENDPOINTS ====================
  static const String categories = '/public/categories';
  static const String category = '/public/categories'; // + /{id}
  static const String categorySubCategories =
      '/public/categories'; // + /{id}/sub-categories

  // Admin categories management
  static const String adminCategories = '/admin/categories';
  static const String adminCategory = '/admin/categories'; // + /{id}
  static const String adminCategorySubCategories =
      '/admin/categories'; // + /{id}/sub-categories

  // ==================== PRODUCTS ENDPOINTS ====================
  static const String products = '/public/products';
  static const String product = '/public/products'; // + /{id}
  static const String categoryProducts =
      '/public/categories'; // + /{id}/products

  // Admin products management
  static const String adminProducts = '/admin/products';
  static const String adminProduct = '/admin/products'; // + /{id}
  static const String adminProductToggleAvailability =
      '/admin/products'; // + /{id}/toggle-availability
  static const String adminProductToggleFeatured =
      '/admin/products'; // + /{id}/toggle-featured
  static const String adminProductsBulkAvailability =
      '/admin/products/bulk-availability';
  static const String adminProductsStatistics = '/admin/products/statistics';
  static const String adminCategoryProducts =
      '/admin/categories'; // + /{id}/products

  // ==================== DASHBOARD ENDPOINTS ====================
  static const String adminDashboardStatistics = '/admin/dashboard/statistics';

  // ==================== ORDERS ENDPOINTS ====================
  static const String adminOrders = '/admin/orders';
  static const String adminOrder = '/admin/orders'; // + /{id}
  static const String adminOrderStatus = '/admin/orders'; // + /{id}/status
  static const String adminOrdersStatistics = '/admin/orders/statistics';

  // ==================== NOTIFICATIONS ENDPOINTS ====================
  static const String adminNotifications = '/admin/notifications';
  static const String adminNotification = '/admin/notifications'; // + /{id}
  static const String adminNotificationRead =
      '/admin/notifications'; // + /{id}/read

  // ==================== HELPER METHODS ====================

  /// Get full URL for a specific endpoint
  static String getUrl(String endpoint) => '$baseUrl$endpoint';

  /// Get full URL for a specific endpoint with ID
  static String getUrlWithId(String endpoint, dynamic id) =>
      '$baseUrl$endpoint/$id';

  /// Get full URL for a specific endpoint with ID and action
  static String getUrlWithIdAndAction(
    String endpoint,
    dynamic id,
    String action,
  ) => '$baseUrl$endpoint/$id/$action';
}
