import 'package:dartz/dartz.dart';
import '../error/failures.dart';
import 'base_response.dart';

/// 🟦 BaseDataSource - مبدأ المسؤولية الواحدة (SRP)
/// كل data source مسؤول عن مصدر بيانات واحد فقط
///
/// 🟦 مبدأ الفتح والإغلاق (OCP)
/// يمكن إضافة data sources جديدة بدون تعديل BaseDataSource
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstraction وليس implementation
abstract class BaseDataSource<T> {
  /// جلب جميع العناصر
  Future<BaseResponse<List<T>>> getAll();

  /// جلب عنصر بواسطة المعرف
  Future<BaseResponse<T?>> getById(String id);

  /// إضافة عنصر جديد
  Future<BaseResponse<T>> add(T item);

  /// تحديث عنصر موجود
  Future<BaseResponse<T>> update(String id, T item);

  /// حذف عنصر
  Future<BaseResponse<bool>> delete(String id);

  /// البحث في العناصر
  Future<BaseResponse<List<T>>> search(String query);

  /// جلب العناصر مع pagination
  Future<BaseResponse<List<T>>> getPaginated({
    int page = 1,
    int limit = 10,
    String? sortBy,
    bool ascending = true,
  });
}

/// 🟦 RemoteDataSource - للبيانات من API
abstract class BaseRemoteDataSource<T> extends BaseDataSource<T> {
  /// Base URL للـ API
  String get baseUrl;

  /// Endpoint للـ resource
  String get endpoint;

  /// Headers المطلوبة
  Map<String, String> get headers;

  /// Timeout للـ requests
  Duration get timeout => const Duration(seconds: 30);

  /// Retry attempts
  int get retryAttempts => 3;
}

/// 🟦 LocalDataSource - للبيانات المحلية
abstract class BaseLocalDataSource<T> extends BaseDataSource<T> {
  /// اسم الجدول/المجلد
  String get tableName;

  /// مفتاح التخزين
  String get storageKey;

  /// حفظ البيانات محلياً
  Future<void> saveLocally(List<T> items);

  /// جلب البيانات المحلية
  Future<List<T>> getLocalData();

  /// مسح البيانات المحلية
  Future<void> clearLocalData();

  /// التحقق من وجود بيانات محلية
  Future<bool> hasLocalData();
}

/// 🟦 CacheDataSource - للبيانات المؤقتة
abstract class BaseCacheDataSource<T> extends BaseDataSource<T> {
  /// مدة صلاحية الـ cache
  Duration get cacheDuration => const Duration(hours: 1);

  /// حفظ في الـ cache
  Future<void> cacheData(String key, T data);

  /// جلب من الـ cache
  Future<T?> getCachedData(String key);

  /// مسح الـ cache
  Future<void> clearCache();

  /// التحقق من صلاحية الـ cache
  bool isCacheValid(String key);
}
