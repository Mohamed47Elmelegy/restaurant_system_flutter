import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// 🗂️ CustomCacheManager - مدير تخزين مؤقت مخصص مع معالجة الأخطاء
///
/// يوفر:
/// - معالجة أخطاء قاعدة البيانات SQLite
/// - مسار تخزين آمن ومضمون
/// - إعدادات تحسين للأداء
/// - معالجة أخطاء الشبكة
class CustomCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'customCacheManager';

  static CustomCacheManager? _instance;

  factory CustomCacheManager() {
    _instance ??= CustomCacheManager._();
    return _instance!;
  }

  CustomCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 200,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ),
      );

  /// الحصول على مسار التخزين المؤقت مع معالجة الأخطاء
  static Future<String> getCachePath() async {
    try {
      Directory? directory;

      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
        directory ??= await getApplicationDocumentsDirectory();
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final cachePath = path.join(directory.path, 'custom_cache');
      final cacheDir = Directory(cachePath);

      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      return cachePath;
    } catch (e) {
      // في حالة فشل الحصول على مسار مخصص، استخدم المسار الافتراضي
      final directory = await getTemporaryDirectory();
      return path.join(directory.path, 'custom_cache');
    }
  }

  /// تنظيف التخزين المؤقت
  static Future<void> clearCache() async {
    try {
      final cachePath = await getCachePath();
      final cacheDir = Directory(cachePath);

      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (e) {
      // تجاهل الأخطاء في التنظيف
    }
  }

  /// الحصول على حجم التخزين المؤقت
  static Future<int> getCacheSize() async {
    try {
      final cachePath = await getCachePath();
      final cacheDir = Directory(cachePath);

      if (!await cacheDir.exists()) {
        return 0;
      }

      int totalSize = 0;
      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }
}

/// 🖼️ CustomImageCacheManager - مدير تخزين الصور مع معالجة الأخطاء
class CustomImageCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'customImageCacheManager';

  static CustomImageCacheManager? _instance;

  factory CustomImageCacheManager() {
    _instance ??= CustomImageCacheManager._();
    return _instance!;
  }

  CustomImageCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 30),
          maxNrOfCacheObjects: 500,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ),
      );

  /// تحميل صورة مع معالجة الأخطاء
  Future<File?> getImageFileSafe(String url, {String? key}) async {
    try {
      return await getSingleFile(url, key: key);
    } catch (e) {
      // في حالة فشل التحميل، حاول إعادة المحاولة مرة واحدة
      try {
        await Future.delayed(const Duration(seconds: 1));
        return await getSingleFile(url, key: key);
      } catch (e) {
        return null;
      }
    }
  }
}
