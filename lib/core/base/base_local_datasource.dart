import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
/// 🟦 BaseLocalDataSource - للتخزين المحلي باستخدام Hive
///
/// يوفر وظائف أساسية للتخزين المحلي:
/// - حفظ البيانات
/// - جلب البيانات
/// - مسح البيانات
/// - التحقق من وجود البيانات
/// - إدارة الـ cache
abstract class BaseLocalDataSource<T> {
  /// اسم الـ box في Hive
  String get boxName;

  /// مفتاح التخزين
  String get storageKey;

  /// مدة صلاحية الـ cache (افتراضي: ساعة واحدة)
  Duration get cacheDuration => const Duration(hours: 1);

  /// تحويل البيانات إلى JSON
  Map<String, dynamic> toJson(T item);

  /// تحويل JSON إلى بيانات
  T fromJson(Map<String, dynamic> json);

  /// حفظ البيانات محلياً
  Future<void> saveLocally(List<T> items) async {
    try {
      final box = await Hive.openBox(boxName);
      final data = {
        'items': items.map((item) => toJson(item)).toList(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await box.put(storageKey, jsonEncode(data));
      log(
        '💾 BaseLocalDataSource: Saved ${items.length} items to $boxName/$storageKey',
      );
    } catch (e) {
      log(
        '❌ BaseLocalDataSource: Error saving data to $boxName/$storageKey: $e',
      );
      rethrow;
    }
  }

  /// جلب البيانات المحلية
  Future<List<T>> getLocalData() async {
    try {
      final box = await Hive.openBox(boxName);
      final data = box.get(storageKey);

      if (data == null) {
        log('📭 BaseLocalDataSource: No data found in $boxName/$storageKey');
        return [];
      }

      final jsonData = jsonDecode(data);
      final items = (jsonData['items'] as List)
          .map((item) => fromJson(item))
          .toList();

      log(
        '📥 BaseLocalDataSource: Retrieved ${items.length} items from $boxName/$storageKey',
      );
      return items;
    } catch (e) {
      log(
        '❌ BaseLocalDataSource: Error retrieving data from $boxName/$storageKey: $e',
      );
      return [];
    }
  }

  /// مسح البيانات المحلية
  Future<void> clearLocalData() async {
    try {
      final box = await Hive.openBox(boxName);
      await box.delete(storageKey);
      log('🗑️ BaseLocalDataSource: Cleared data from $boxName/$storageKey');
    } catch (e) {
      log(
        '❌ BaseLocalDataSource: Error clearing data from $boxName/$storageKey: $e',
      );
      rethrow;
    }
  }

  /// التحقق من وجود بيانات محلية
  Future<bool> hasLocalData() async {
    try {
      final box = await Hive.openBox(boxName);
      final data = box.get(storageKey);

      if (data == null) return false;

      final jsonData = jsonDecode(data);
      final timestamp = jsonData['timestamp'] as int;
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      // التحقق من صلاحية الـ cache
      final isValid = now.difference(cacheTime) < cacheDuration;

      log(
        '🔍 BaseLocalDataSource: Cache validity for $boxName/$storageKey: $isValid',
      );
      return isValid;
    } catch (e) {
      log('❌ BaseLocalDataSource: Error checking cache validity: $e');
      return false;
    }
  }

  /// جلب آخر timestamp للبيانات
  Future<DateTime?> getLastUpdateTime() async {
    try {
      final box = await Hive.openBox(boxName);
      final data = box.get(storageKey);

      if (data == null) return null;

      final jsonData = jsonDecode(data);
      final timestamp = jsonData['timestamp'] as int;
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      log('❌ BaseLocalDataSource: Error getting last update time: $e');
      return null;
    }
  }

  /// التحقق من صلاحية الـ cache
  bool isCacheValid(DateTime? lastUpdate) {
    if (lastUpdate == null) return false;
    final now = DateTime.now();
    return now.difference(lastUpdate) < cacheDuration;
  }
}

/// 🟦 AdminLocalDataSource - للتخزين المحلي في صفحات الإدارة
abstract class AdminLocalDataSource<T> extends BaseLocalDataSource<T> {
  @override
  String get boxName => 'admin_cache';

  /// حفظ فئة محددة
  Future<void> saveCategory(String categoryKey, List<T> items) async {
    try {
      final box = await Hive.openBox(boxName);
      final data = {
        'items': items.map((item) => toJson(item)).toList(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await box.put(categoryKey, jsonEncode(data));
      log(
        '💾 AdminLocalDataSource: Saved ${items.length} items to $boxName/$categoryKey',
      );
    } catch (e) {
      log(
        '❌ AdminLocalDataSource: Error saving data to $boxName/$categoryKey: $e',
      );
      rethrow;
    }
  }

  /// جلب فئة محددة
  Future<List<T>> getCategoryData(String categoryKey) async {
    try {
      final box = await Hive.openBox(boxName);
      final data = box.get(categoryKey);

      if (data == null) {
        log('📭 AdminLocalDataSource: No data found in $boxName/$categoryKey');
        return [];
      }

      final jsonData = jsonDecode(data);
      final items = (jsonData['items'] as List)
          .map((item) => fromJson(item))
          .toList();

      log(
        '📥 AdminLocalDataSource: Retrieved ${items.length} items from $boxName/$categoryKey',
      );
      return items;
    } catch (e) {
      log(
        '❌ AdminLocalDataSource: Error retrieving data from $boxName/$categoryKey: $e',
      );
      return [];
    }
  }

  /// مسح فئة محددة
  Future<void> clearCategoryData(String categoryKey) async {
    try {
      final box = await Hive.openBox(boxName);
      await box.delete(categoryKey);
      log('🗑️ AdminLocalDataSource: Cleared data from $boxName/$categoryKey');
    } catch (e) {
      log(
        '❌ AdminLocalDataSource: Error clearing data from $boxName/$categoryKey: $e',
      );
      rethrow;
    }
  }

  /// التحقق من وجود بيانات لفئة محددة
  Future<bool> hasCategoryData(String categoryKey) async {
    try {
      final box = await Hive.openBox(boxName);
      final data = box.get(categoryKey);

      if (data == null) return false;

      final jsonData = jsonDecode(data);
      final timestamp = jsonData['timestamp'] as int;
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      final isValid = now.difference(cacheTime) < cacheDuration;

      log(
        '🔍 AdminLocalDataSource: Cache validity for $boxName/$categoryKey: $isValid',
      );
      return isValid;
    } catch (e) {
      log('❌ AdminLocalDataSource: Error checking cache validity: $e');
      return false;
    }
  }
}
