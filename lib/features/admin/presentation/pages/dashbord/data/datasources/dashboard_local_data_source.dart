import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:developer';
import 'dart:convert';

/// 🟦 DashboardLocalDataSource - للتخزين المحلي لبيانات الـ dashboard باستخدام Hive
///
/// يوفر وظائف التخزين المحلي لبيانات الـ dashboard:
/// - حفظ إحصائيات الـ dashboard محلياً
/// - جلب البيانات من التخزين المحلي
/// - مسح البيانات المحلية
/// - إدارة الـ cache
abstract class DashboardLocalDataSource {
  /// حفظ إحصائيات المبيعات محلياً
  Future<void> saveSalesStats(Map<String, dynamic> salesStats);

  /// جلب إحصائيات المبيعات من التخزين المحلي
  Future<Map<String, dynamic>?> getSalesStats();

  /// حفظ بيانات الطلبات محلياً
  Future<void> saveOrdersData(Map<String, dynamic> ordersData);

  /// جلب بيانات الطلبات من التخزين المحلي
  Future<Map<String, dynamic>?> getOrdersData();

  /// حفظ بيانات المنتجات محلياً
  Future<void> saveProductsData(Map<String, dynamic> productsData);

  /// جلب بيانات المنتجات من التخزين المحلي
  Future<Map<String, dynamic>?> getProductsData();

  /// حفظ بيانات الإيرادات محلياً
  Future<void> saveRevenueData(Map<String, dynamic> revenueData);

  /// جلب بيانات الإيرادات من التخزين المحلي
  Future<Map<String, dynamic>?> getRevenueData();

  /// حفظ بيانات العملاء محلياً
  Future<void> saveCustomersData(Map<String, dynamic> customersData);

  /// جلب بيانات العملاء من التخزين المحلي
  Future<Map<String, dynamic>?> getCustomersData();

  /// مسح جميع بيانات الـ dashboard
  Future<void> clearAllDashboardData();

  /// التحقق من وجود بيانات dashboard محلية
  Future<bool> hasDashboardData();

  /// جلب آخر وقت تحديث للبيانات
  Future<DateTime?> getLastUpdateTime(String dataType);

  /// التحقق من صلاحية الـ cache
  bool isCacheValid(DateTime? lastUpdate);
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  static const String _boxName = 'admin_cache';
  static const String _salesStatsKey = 'dashboard_sales_stats';
  static const String _ordersDataKey = 'dashboard_orders_data';
  static const String _productsDataKey = 'dashboard_products_data';
  static const String _revenueDataKey = 'dashboard_revenue_data';
  static const String _customersDataKey = 'dashboard_customers_data';
  static const Duration _cacheDuration = const Duration(
    minutes: 30,
  ); // dashboard يحتاج cache قصير

  @override
  Future<void> saveSalesStats(Map<String, dynamic> salesStats) async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = {
        'data': salesStats,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await box.put(_salesStatsKey, jsonEncode(data));
      log('💾 DashboardLocalDataSource: Saved sales stats locally');
    } catch (e) {
      log('❌ DashboardLocalDataSource: Error saving sales stats: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getSalesStats() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_salesStatsKey);

      if (data == null) {
        log(
          '📭 DashboardLocalDataSource: No sales stats found in local storage',
        );
        return null;
      }

      final jsonData = jsonDecode(data);
      final stats = Map<String, dynamic>.from(jsonData['data']);

      log(
        '📥 DashboardLocalDataSource: Retrieved sales stats from local storage',
      );
      return stats;
    } catch (e) {
      log('❌ DashboardLocalDataSource: Error retrieving sales stats: $e');
      return null;
    }
  }

  @override
  Future<void> saveOrdersData(Map<String, dynamic> ordersData) async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = {
        'data': ordersData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await box.put(_ordersDataKey, jsonEncode(data));
      log('💾 DashboardLocalDataSource: Saved orders data locally');
    } catch (e) {
      log('❌ DashboardLocalDataSource: Error saving orders data: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getOrdersData() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_ordersDataKey);

      if (data == null) {
        log(
          '📭 DashboardLocalDataSource: No orders data found in local storage',
        );
        return null;
      }

      final jsonData = jsonDecode(data);
      final orders = Map<String, dynamic>.from(jsonData['data']);

      log(
        '📥 DashboardLocalDataSource: Retrieved orders data from local storage',
      );
      return orders;
    } catch (e) {
      log('❌ DashboardLocalDataSource: Error retrieving orders data: $e');
      return null;
    }
  }

  @override
  Future<void> saveProductsData(Map<String, dynamic> productsData) async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = {
        'data': productsData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await box.put(_productsDataKey, jsonEncode(data));
      log('💾 DashboardLocalDataSource: Saved products data locally');
    } catch (e) {
      log('❌ DashboardLocalDataSource: Error saving products data: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getProductsData() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_productsDataKey);

      if (data == null) {
        log(
          '📭 DashboardLocalDataSource: No products data found in local storage',
        );
        return null;
      }

      final jsonData = jsonDecode(data);
      final products = Map<String, dynamic>.from(jsonData['data']);

      log(
        '📥 DashboardLocalDataSource: Retrieved products data from local storage',
      );
      return products;
    } catch (e) {
      log('❌ DashboardLocalDataSource: Error retrieving products data: $e');
      return null;
    }
  }

  @override
  Future<void> saveRevenueData(Map<String, dynamic> revenueData) async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = {
        'data': revenueData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await box.put(_revenueDataKey, jsonEncode(data));
      log('💾 DashboardLocalDataSource: Saved revenue data locally');
    } catch (e) {
      log('❌ DashboardLocalDataSource: Error saving revenue data: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getRevenueData() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_revenueDataKey);

      if (data == null) {
        log(
          '📭 DashboardLocalDataSource: No revenue data found in local storage',
        );
        return null;
      }

      final jsonData = jsonDecode(data);
      final revenue = Map<String, dynamic>.from(jsonData['data']);

      log(
        '📥 DashboardLocalDataSource: Retrieved revenue data from local storage',
      );
      return revenue;
    } catch (e) {
      log('❌ DashboardLocalDataSource: Error retrieving revenue data: $e');
      return null;
    }
  }

  @override
  Future<void> saveCustomersData(Map<String, dynamic> customersData) async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = {
        'data': customersData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await box.put(_customersDataKey, jsonEncode(data));
      log('💾 DashboardLocalDataSource: Saved customers data locally');
    } catch (e) {
      log('❌ DashboardLocalDataSource: Error saving customers data: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getCustomersData() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_customersDataKey);

      if (data == null) {
        log(
          '📭 DashboardLocalDataSource: No customers data found in local storage',
        );
        return null;
      }

      final jsonData = jsonDecode(data);
      final customers = Map<String, dynamic>.from(jsonData['data']);

      log(
        '📥 DashboardLocalDataSource: Retrieved customers data from local storage',
      );
      return customers;
    } catch (e) {
      log('❌ DashboardLocalDataSource: Error retrieving customers data: $e');
      return null;
    }
  }

  @override
  Future<void> clearAllDashboardData() async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.delete(_salesStatsKey);
      await box.delete(_ordersDataKey);
      await box.delete(_productsDataKey);
      await box.delete(_revenueDataKey);
      await box.delete(_customersDataKey);
      log(
        '🗑️ DashboardLocalDataSource: Cleared all dashboard data from local storage',
      );
    } catch (e) {
      log('❌ DashboardLocalDataSource: Error clearing dashboard data: $e');
      rethrow;
    }
  }

  @override
  Future<bool> hasDashboardData() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_salesStatsKey);

      if (data == null) return false;

      final jsonData = jsonDecode(data);
      final timestamp = jsonData['timestamp'] as int;
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      final isValid = now.difference(cacheTime) < _cacheDuration;

      log(
        '🔍 DashboardLocalDataSource: Has dashboard data in local storage: $isValid',
      );
      return isValid;
    } catch (e) {
      log(
        '❌ DashboardLocalDataSource: Error checking if dashboard data exists: $e',
      );
      return false;
    }
  }

  @override
  Future<DateTime?> getLastUpdateTime(String dataType) async {
    try {
      final box = await Hive.openBox(_boxName);
      String key;

      switch (dataType) {
        case 'sales':
          key = _salesStatsKey;
          break;
        case 'orders':
          key = _ordersDataKey;
          break;
        case 'products':
          key = _productsDataKey;
          break;
        case 'revenue':
          key = _revenueDataKey;
          break;
        case 'customers':
          key = _customersDataKey;
          break;
        default:
          return null;
      }

      final data = box.get(key);
      if (data == null) return null;

      final jsonData = jsonDecode(data);
      final timestamp = jsonData['timestamp'] as int;
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      log('❌ DashboardLocalDataSource: Error getting last update time: $e');
      return null;
    }
  }

  @override
  bool isCacheValid(DateTime? lastUpdate) {
    if (lastUpdate == null) return false;
    final now = DateTime.now();
    return now.difference(lastUpdate) < _cacheDuration;
  }
}
