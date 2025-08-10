import 'endpoints.dart';

class ApiPath {
  // ==================== AUTHENTICATION PATHS ====================
  static String login() => Endpoints.getUrl(Endpoints.login);
  static String register() => Endpoints.getUrl(Endpoints.register);
  static String user() => Endpoints.getUrl(Endpoints.user);

  // ==================== PUBLIC MENU PATHS (بدون توكن) ====================
  static String menuMealTimes() => Endpoints.getUrl(Endpoints.menuMealTimes);
  static String menuCategories({int? mealTimeId}) {
    if (mealTimeId != null) {
      return '${Endpoints.getUrl(Endpoints.menuCategories)}?meal_time_id=$mealTimeId';
    }
    return Endpoints.getUrl(Endpoints.menuCategories);
  }

  static String menuProducts({
    int? mainCategoryId,
    int? subCategoryId,
    String? search,
    int? perPage,
  }) {
    final queryParams = <String>[];
    if (mainCategoryId != null)
      queryParams.add('main_category_id=$mainCategoryId');
    if (subCategoryId != null)
      queryParams.add('sub_category_id=$subCategoryId');
    if (search != null && search.isNotEmpty) queryParams.add('search=$search');
    if (perPage != null) queryParams.add('per_page=$perPage');

    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.join('&')}'
        : '';
    return '${Endpoints.getUrl(Endpoints.menuProducts)}$queryString';
  }

  // ==================== PUBLIC BROWSING PATHS (بدون توكن) ====================
  static String publicMealTimes() =>
      Endpoints.getUrl(Endpoints.publicMealTimes);
  static String publicCurrentMealTime() =>
      Endpoints.getUrl(Endpoints.publicCurrentMealTime);
  static String publicMealTimeCategories(int mealTimeId) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.publicMealTimeCategories,
        mealTimeId,
        'categories',
      );
  static String publicCategories() =>
      Endpoints.getUrl(Endpoints.publicCategories);
  static String publicCategory(int categoryId) =>
      Endpoints.getUrlWithId(Endpoints.publicCategory, categoryId);
  static String publicCategorySubCategories(int categoryId) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.publicCategorySubCategories,
        categoryId,
        'sub-categories',
      );
  static String publicProducts() => Endpoints.getUrl(Endpoints.publicProducts);
  static String publicProduct(int productId) =>
      Endpoints.getUrlWithId(Endpoints.publicProduct, productId);
  static String publicCategoryProducts(int categoryId) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.publicCategoryProducts,
        categoryId,
        'products',
      );
  static String publicProductsRecommended() =>
      Endpoints.getUrl(Endpoints.publicProductsRecommended);
  static String publicProductsPopular() =>
      Endpoints.getUrl(Endpoints.publicProductsPopular);
  static String publicProductsNew() =>
      Endpoints.getUrl(Endpoints.publicProductsNew);

  // ==================== CART PATHS (يتطلب توكن) ====================
  static String cart() => Endpoints.getUrl(Endpoints.cart);
  static String cartItems(int cartItemId) =>
      Endpoints.getUrlWithId(Endpoints.cartItems, cartItemId);
  static String cartClear() => Endpoints.getUrl(Endpoints.cartClear);

  // ==================== ORDERS PATHS (يتطلب توكن) ====================
  static String orders() => Endpoints.getUrl(Endpoints.orders);
  static String order(int orderId) =>
      Endpoints.getUrlWithId(Endpoints.order, orderId);
  static String placeOrder() => Endpoints.getUrl(Endpoints.placeOrder);

  // ==================== FAVORITES PATHS (يتطلب توكن) ====================
  static String favorites() => Endpoints.getUrl(Endpoints.favorites);
  static String toggleFavorite() => Endpoints.getUrl(Endpoints.toggleFavorite);

  // ==================== ADDRESSES PATHS (يتطلب توكن) ====================
  static String addresses() => Endpoints.getUrl(Endpoints.addresses);
  static String address(int addressId) =>
      Endpoints.getUrlWithId(Endpoints.address, addressId);

  // ==================== ADMIN CATEGORIES PATHS (يتطلب role:admin) ====================
  static String adminCategories() =>
      Endpoints.getUrl(Endpoints.adminCategories);
  static String adminCategory(int categoryId) =>
      Endpoints.getUrlWithId(Endpoints.adminCategory, categoryId);
  static String adminCategorySubCategories(int categoryId) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.adminCategorySubCategories,
        categoryId,
        'sub-categories',
      );

  // ==================== ADMIN MEAL TIMES PATHS (يتطلب role:admin) ====================
  static String adminMealTimes() => Endpoints.getUrl(Endpoints.adminMealTimes);
  static String adminMealTime(int mealTimeId) =>
      Endpoints.getUrlWithId(Endpoints.adminMealTime, mealTimeId);
  static String adminMealTimeToggle(int mealTimeId) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.adminMealTimeToggle,
        mealTimeId,
        'toggle',
      );
  static String adminMealTimesReorder() =>
      Endpoints.getUrl(Endpoints.adminMealTimesReorder);

  // ==================== ADMIN PRODUCTS PATHS (يتطلب role:admin) ====================
  static String adminProducts() => Endpoints.getUrl(Endpoints.adminProducts);
  static String adminProduct(int productId) =>
      Endpoints.getUrlWithId(Endpoints.adminProduct, productId);
  static String adminProductToggleAvailability(int productId) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.adminProductToggleAvailability,
        productId,
        'toggle-availability',
      );
  static String adminProductToggleFeatured(int productId) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.adminProductToggleFeatured,
        productId,
        'toggle-featured',
      );
  static String adminProductsBulkAvailability() =>
      Endpoints.getUrl(Endpoints.adminProductsBulkAvailability);
  static String adminProductsStatistics() =>
      Endpoints.getUrl(Endpoints.adminProductsStatistics);

  // ==================== ADMIN ORDERS PATHS (يتطلب role:admin) ====================
  static String adminOrders() => Endpoints.getUrl(Endpoints.adminOrders);
  static String adminOrder(int orderId) =>
      Endpoints.getUrlWithId(Endpoints.adminOrder, orderId);
  static String adminOrderStatus(int orderId) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.adminOrderStatus,
        orderId,
        'status',
      );
  static String adminOrdersStatistics() =>
      Endpoints.getUrl(Endpoints.adminOrdersStatistics);

  // ==================== ADMIN DASHBOARD PATHS (يتطلب role:admin) ====================
  static String adminDashboardStatistics() =>
      Endpoints.getUrl(Endpoints.adminDashboardStatistics);

  // ==================== ADMIN NOTIFICATIONS PATHS (يتطلب role:admin) ====================
  static String adminNotifications() =>
      Endpoints.getUrl(Endpoints.adminNotifications);
  static String adminNotification(int notificationId) =>
      Endpoints.getUrlWithId(Endpoints.adminNotification, notificationId);
  static String adminNotificationRead(int notificationId) =>
      Endpoints.getUrlWithIdAndAction(
        Endpoints.adminNotificationRead,
        notificationId,
        'read',
      );

  // ==================== HEALTH CHECK PATH ====================
  static String healthCheck() => Endpoints.getHealthCheckUrl();
}
