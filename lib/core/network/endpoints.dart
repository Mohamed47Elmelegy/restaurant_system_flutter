class Endpoints {
  // ==================== SERVER CONFIGURATION ====================
  // Choose the appropriate baseUrl for your testing environment:

  // ✅ CURRENT: Android Emulator (recommended for emulator testing)
  //  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // 📱 OTHER OPTIONS (uncomment as needed):
  // static const String baseUrl = 'http://127.0.0.1:8000/api/v1'; // For iOS Simulator
  // static const String baseUrl = 'http://localhost:8000/api/v1'; // For Web/Desktop

  // 🌐 REAL DEVICE TESTING (when Laravel server is running on network):
  static const String baseUrl =
      'http://192.168.1.59:8000/api/v1'; // Previous IP
  // static const String baseUrl = 'http://192.168.1.31:8000/api/v1'; // Alternative IP

  // ==================== NOTES ====================
  // - 10.0.2.2 maps to localhost on Android Emulator
  // - 127.0.0.1 works for iOS Simulator
  // - For real devices, use your computer's network IP address

  // ==================== AUTHENTICATION ENDPOINTS ====================
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String user = '/user';

  // ==================== PUBLIC MENU ENDPOINTS (بدون توكن) ====================
  static const String menuMealTimes = '/menu/meal-times';
  static const String menuCategories = '/menu/categories';
  static const String menuProducts = '/menu/products';

  // ==================== PUBLIC BROWSING ENDPOINTS (بدون توكن) ====================
  static const String publicMealTimes = '/public/meal-times';
  static const String publicCurrentMealTime = '/public/meal-times/current';
  static const String publicMealTimeCategories =
      '/public/meal-times'; // + /{mealTime}/categories
  static const String publicCategories = '/public/categories';
  static const String publicCategory = '/public/categories'; // + /{category}
  static const String publicCategorySubCategories =
      '/public/categories'; // + /{category}/sub-categories
  static const String publicProducts = '/public/products';
  static const String publicProduct = '/public/products'; // + /{product}
  static const String publicCategoryProducts =
      '/public/categories'; // + /{category}/products
  static const String publicProductsRecommended =
      '/public/products/recommended';
  static const String publicProductsPopular = '/public/products/popular';
  static const String publicProductsNew = '/public/products/new';

  // ==================== CART ENDPOINTS (يتطلب توكن) ====================
  static const String cart = '/cart';
  static const String cartItems = '/cart/items'; // + /{cartItem}
  static const String cartClear = '/cart/clear';

  // ==================== ORDERS ENDPOINTS (يتطلب توكن) ====================
  static const String orders = '/orders';
  static const String order = '/orders'; // + /{order}
  static const String placeOrder = '/orders/place';
  static const String orderStatusHistory =
      '/orders'; // + /{order}/status-history
  static const String cancelOrder = '/orders'; // + /{order}/cancel
  static const String markOrderPaid = '/orders'; // + /{order}/mark-paid

  // ==================== FAVORITES ENDPOINTS (يتطلب توكن) ====================
  static const String favorites = '/favorites';
  static const String toggleFavorite = '/favorites/toggle';

  // ==================== ADDRESSES ENDPOINTS (يتطلب توكن) ====================
  static const String addresses = '/addresses';
  static const String addressUD = '/addresses'; // + /{address}
  static const String addressSetDefault =
      '/addresses'; // + /{address}/set-default

  // ==================== ADMIN CATEGORIES ENDPOINTS (يتطلب role:admin) ====================
  static const String adminCategories = '/admin/categories';
  static const String adminCategory = '/admin/categories'; // + /{category}
  static const String adminCategorySubCategories =
      '/admin/categories'; // + /{category}/sub-categories

  // ==================== ADMIN MEAL TIMES ENDPOINTS (يتطلب role:admin) ====================
  static const String adminMealTimes = '/admin/meal-times';
  static const String adminMealTime = '/admin/meal-times'; // + /{mealTime}
  static const String adminMealTimeToggle =
      '/admin/meal-times'; // + /{mealTime}/toggle
  static const String adminMealTimesReorder = '/admin/meal-times/reorder';

  // ==================== ADMIN PRODUCTS ENDPOINTS (يتطلب role:admin) ====================
  static const String adminProducts = '/admin/products';
  static const String adminProduct = '/admin/products'; // + /{product}
  static const String adminProductToggleAvailability =
      '/admin/products'; // + /{product}/toggle-availability
  static const String adminProductToggleFeatured =
      '/admin/products'; // + /{product}/toggle-featured
  static const String adminProductsBulkAvailability =
      '/admin/products/bulk-availability';
  static const String adminProductsStatistics = '/admin/products/statistics';

  // ==================== ADMIN ORDERS ENDPOINTS (يتطلب role:admin) ====================
  static const String adminOrders = '/admin/orders';
  static const String adminOrder = '/admin/orders'; // + /{order}
  static const String adminOrderStatus = '/admin/orders'; // + /{order}/status
  static const String adminOrderNextStatuses =
      '/admin/orders'; // + /{order}/next-statuses
  static const String adminOrdersStatistics = '/admin/orders/statistics';

  // ==================== ADMIN DASHBOARD ENDPOINTS (يتطلب role:admin) ====================
  static const String adminDashboardStatistics = '/admin/dashboard/statistics';

  // ==================== ADMIN NOTIFICATIONS ENDPOINTS (يتطلب role:admin) ====================
  static const String adminNotifications = '/admin/notifications';
  static const String adminNotification =
      '/admin/notifications'; // + /{notification}
  static const String adminNotificationRead =
      '/admin/notifications'; // + /{notification}/read

  // ==================== HEALTH CHECK ENDPOINT ====================
  static const String healthCheck = '/test';

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

  /// Get full URL for health check (matches current baseUrl configuration)
  static String getHealthCheckUrl() => 'http://10.0.2.2:8000/api/test';

  static const String tables = '/tables'; // + /{table}
  static const String tableByQr = '/tables/qr'; // + /{qrCode}
  static const String occupyTable = '/tables'; // + /{table}/occupy
}
