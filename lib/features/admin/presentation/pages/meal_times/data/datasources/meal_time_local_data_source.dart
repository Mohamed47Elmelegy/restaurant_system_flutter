import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/meal_time_model.dart';
import 'dart:developer';
import 'dart:convert';

/// 🟦 MealTimeLocalDataSource - للتخزين المحلي لأوقات الوجبات باستخدام Hive
///
/// يوفر وظائف التخزين المحلي لأوقات الوجبات:
/// - حفظ أوقات الوجبات محلياً
/// - جلب أوقات الوجبات من التخزين المحلي
/// - مسح البيانات المحلية
/// - إدارة الـ cache
abstract class MealTimeLocalDataSource {
  /// حفظ أوقات الوجبات محلياً
  Future<void> saveMealTimes(List<MealTimeModel> mealTimes);

  /// جلب أوقات الوجبات من التخزين المحلي
  Future<List<MealTimeModel>> getMealTimes();

  /// جلب وقت وجبة بواسطة المعرف
  Future<MealTimeModel?> getMealTimeById(String id);

  /// البحث في أوقات الوجبات المحلية
  Future<List<MealTimeModel>> searchMealTimes(String query);

  /// جلب أوقات الوجبات النشطة فقط
  Future<List<MealTimeModel>> getActiveMealTimes();

  /// جلب أوقات الوجبات حسب الفئة
  Future<List<MealTimeModel>> getMealTimesByCategory(String categoryId);

  /// مسح جميع أوقات الوجبات
  Future<void> clearAllMealTimes();

  /// التحقق من وجود أوقات وجبات محلية
  Future<bool> hasMealTimes();

  /// حفظ وقت وجبة واحد
  Future<void> saveMealTime(MealTimeModel mealTime);

  /// حذف وقت وجبة واحد
  Future<void> deleteMealTime(String id);

  /// تحديث حالة نشاط وقت الوجبة
  Future<void> updateMealTimeActivity(String id, bool isActive);

  /// جلب أوقات الوجبات مرتبة حسب الترتيب
  Future<List<MealTimeModel>> getSortedMealTimes();
}

class MealTimeLocalDataSourceImpl implements MealTimeLocalDataSource {
  static const String _boxName = 'admin_cache';
  static const String _storageKey = 'meal_times';
  static const Duration _cacheDuration = const Duration(
    hours: 4,
  ); // أوقات الوجبات تحتاج cache أطول

  @override
  Future<void> saveMealTimes(List<MealTimeModel> mealTimes) async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = {
        'items': mealTimes.map((item) => item.toJson()).toList(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await box.put(_storageKey, jsonEncode(data));
      log(
        '💾 MealTimeLocalDataSource: Saved ${mealTimes.length} meal times locally',
      );
    } catch (e) {
      log('❌ MealTimeLocalDataSource: Error saving meal times: $e');
      rethrow;
    }
  }

  @override
  Future<List<MealTimeModel>> getMealTimes() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_storageKey);

      if (data == null) {
        log('📭 MealTimeLocalDataSource: No meal times found in local storage');
        return [];
      }

      final jsonData = jsonDecode(data);
      final items = (jsonData['items'] as List)
          .map((item) => MealTimeModel.fromJson(item))
          .toList();

      log(
        '📥 MealTimeLocalDataSource: Retrieved ${items.length} meal times from local storage',
      );
      return items;
    } catch (e) {
      log('❌ MealTimeLocalDataSource: Error retrieving meal times: $e');
      return [];
    }
  }

  @override
  Future<MealTimeModel?> getMealTimeById(String id) async {
    try {
      final mealTimes = await getMealTimes();
      final mealTime = mealTimes.firstWhere(
        (mealTime) => mealTime.id == id,
        orElse: () => throw Exception('Meal time not found'),
      );
      log('📥 MealTimeLocalDataSource: Retrieved meal time with ID: $id');
      return mealTime;
    } catch (e) {
      log(
        '❌ MealTimeLocalDataSource: Error retrieving meal time by ID $id: $e',
      );
      return null;
    }
  }

  @override
  Future<List<MealTimeModel>> searchMealTimes(String query) async {
    try {
      final mealTimes = await getMealTimes();
      final filteredMealTimes = mealTimes.where((mealTime) {
        final searchQuery = query.toLowerCase();
        return mealTime.name.toLowerCase().contains(searchQuery) ||
            mealTime.nameAr.toLowerCase().contains(searchQuery);
      }).toList();

      log(
        '🔍 MealTimeLocalDataSource: Found ${filteredMealTimes.length} meal times matching "$query"',
      );
      return filteredMealTimes;
    } catch (e) {
      log('❌ MealTimeLocalDataSource: Error searching meal times: $e');
      return [];
    }
  }

  @override
  Future<List<MealTimeModel>> getActiveMealTimes() async {
    try {
      final mealTimes = await getMealTimes();
      final activeMealTimes = mealTimes
          .where((mealTime) => mealTime.isActive)
          .toList();

      log(
        '✅ MealTimeLocalDataSource: Found ${activeMealTimes.length} active meal times',
      );
      return activeMealTimes;
    } catch (e) {
      log('❌ MealTimeLocalDataSource: Error getting active meal times: $e');
      return [];
    }
  }

  @override
  Future<List<MealTimeModel>> getMealTimesByCategory(String categoryId) async {
    try {
      final mealTimes = await getMealTimes();
      final categoryMealTimes = mealTimes.where((mealTime) {
        return mealTime.categoryIds.contains(categoryId);
      }).toList();

      log(
        '📂 MealTimeLocalDataSource: Found ${categoryMealTimes.length} meal times for category $categoryId',
      );
      return categoryMealTimes;
    } catch (e) {
      log(
        '❌ MealTimeLocalDataSource: Error getting meal times by category: $e',
      );
      return [];
    }
  }

  @override
  Future<void> clearAllMealTimes() async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.delete(_storageKey);
      log(
        '🗑️ MealTimeLocalDataSource: Cleared all meal times from local storage',
      );
    } catch (e) {
      log('❌ MealTimeLocalDataSource: Error clearing meal times: $e');
      rethrow;
    }
  }

  @override
  Future<bool> hasMealTimes() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_storageKey);

      if (data == null) return false;

      final jsonData = jsonDecode(data);
      final timestamp = jsonData['timestamp'] as int;
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      final isValid = now.difference(cacheTime) < _cacheDuration;

      log(
        '🔍 MealTimeLocalDataSource: Has meal times in local storage: $isValid',
      );
      return isValid;
    } catch (e) {
      log('❌ MealTimeLocalDataSource: Error checking if meal times exist: $e');
      return false;
    }
  }

  @override
  Future<void> saveMealTime(MealTimeModel mealTime) async {
    try {
      final mealTimes = await getMealTimes();
      final existingIndex = mealTimes.indexWhere((mt) => mt.id == mealTime.id);

      if (existingIndex != -1) {
        mealTimes[existingIndex] = mealTime;
      } else {
        mealTimes.add(mealTime);
      }

      await saveMealTimes(mealTimes);
      log(
        '💾 MealTimeLocalDataSource: Saved/Updated meal time with ID: ${mealTime.id}',
      );
    } catch (e) {
      log('❌ MealTimeLocalDataSource: Error saving single meal time: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMealTime(String id) async {
    try {
      final mealTimes = await getMealTimes();
      mealTimes.removeWhere((mealTime) => mealTime.id == id);
      await saveMealTimes(mealTimes);
      log('🗑️ MealTimeLocalDataSource: Deleted meal time with ID: $id');
    } catch (e) {
      log('❌ MealTimeLocalDataSource: Error deleting meal time: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateMealTimeActivity(String id, bool isActive) async {
    try {
      final mealTimes = await getMealTimes();
      final mealTimeIndex = mealTimes.indexWhere(
        (mealTime) => mealTime.id == id,
      );

      if (mealTimeIndex != -1) {
        final updatedMealTime = mealTimes[mealTimeIndex].copyWith(
          isActive: isActive,
        );
        mealTimes[mealTimeIndex] = updatedMealTime;
        await saveMealTimes(mealTimes);
        log(
          '🔄 MealTimeLocalDataSource: Updated activity for meal time $id to $isActive',
        );
      }
    } catch (e) {
      log('❌ MealTimeLocalDataSource: Error updating meal time activity: $e');
      rethrow;
    }
  }

  @override
  Future<List<MealTimeModel>> getSortedMealTimes() async {
    try {
      final mealTimes = await getMealTimes();
      mealTimes.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      log(
        '📊 MealTimeLocalDataSource: Retrieved ${mealTimes.length} sorted meal times',
      );
      return mealTimes;
    } catch (e) {
      log('❌ MealTimeLocalDataSource: Error getting sorted meal times: $e');
      return [];
    }
  }
}
