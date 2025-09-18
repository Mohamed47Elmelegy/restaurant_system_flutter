import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../network/custom_cache_manager.dart';

/// 🖼️ CachedImageWidget - Widget منفصل لتحميل الصور مع التخزين المؤقت
///
/// يوفر:
/// - تحميل الصور من الإنترنت مع التخزين المؤقت
/// - دعم الصور المحلية (assets)
/// - مؤشر تحميل مخصص
/// - صورة بديلة عند الخطأ
/// - تحسين الذاكرة والأداء
class CachedImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;

  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.backgroundColor,
    this.memCacheWidth,
    this.memCacheHeight,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
  });

  /// إنشاء CachedImageWidget مع إعدادات افتراضية للبطاقات
  factory CachedImageWidget.card({
    Key? key,
    required String? imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Color? backgroundColor,
  }) {
    return CachedImageWidget(
      key: key,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      memCacheWidth: 400,
      memCacheHeight: 300,
      maxWidthDiskCache: 800,
      maxHeightDiskCache: 600,
    );
  }

  /// إنشاء CachedImageWidget مع إعدادات افتراضية للتفاصيل
  factory CachedImageWidget.detail({
    Key? key,
    required String? imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Color? backgroundColor,
  }) {
    return CachedImageWidget(
      key: key,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      memCacheWidth: 800,
      memCacheHeight: 600,
      maxWidthDiskCache: 1200,
      maxHeightDiskCache: 900,
    );
  }

  /// إنشاء CachedImageWidget مع إعدادات افتراضية للصور الصغيرة
  factory CachedImageWidget.thumbnail({
    Key? key,
    required String? imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Color? backgroundColor,
  }) {
    return CachedImageWidget(
      key: key,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      memCacheWidth: 200,
      memCacheHeight: 150,
      maxWidthDiskCache: 400,
      maxHeightDiskCache: 300,
    );
  }

  @override
  Widget build(BuildContext context) {
    // إذا لم تكن هناك صورة، اعرض الصورة البديلة
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorWidget();
    }

    // إذا كانت صورة محلية (asset)
    if (!imageUrl!.startsWith('http://') && !imageUrl!.startsWith('https://')) {
      return _buildAssetImage();
    }

    // إذا كانت صورة من الإنترنت
    return _buildNetworkImage();
  }

  /// بناء صورة من الإنترنت مع التخزين المؤقت
  Widget _buildNetworkImage() {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        cacheManager: CustomImageCacheManager(),
        placeholder: (context, url) =>
            placeholder ?? _buildDefaultPlaceholder(),
        errorWidget: (context, url, error) =>
            errorWidget ?? _buildErrorWidget(),
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        maxWidthDiskCache: maxWidthDiskCache,
        maxHeightDiskCache: maxHeightDiskCache,
      ),
    );
  }

  /// بناء صورة محلية (asset)
  Widget _buildAssetImage() {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.asset(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildErrorWidget();
        },
      ),
    );
  }

  /// بناء مؤشر التحميل الافتراضي
  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? const Color(0xFF8DA0B3),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 2.0,
        ),
      ),
    );
  }

  /// بناء الصورة البديلة عند الخطأ
  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? const Color(0xFF8DA0B3),
      child: const Center(
        child: Icon(Icons.fastfood, color: Colors.white, size: 40),
      ),
    );
  }
}

/// 🖼️ CachedImageWidget مع إعدادات مخصصة للبطاقات
class CachedImageCard extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const CachedImageCard({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CachedImageWidget.card(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
    );
  }
}

/// 🖼️ CachedImageWidget مع إعدادات مخصصة لصفحات التفاصيل
class CachedImageDetail extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const CachedImageDetail({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CachedImageWidget.detail(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
    );
  }
}

/// 🖼️ CachedImageWidget مع إعدادات مخصصة للصور الصغيرة
class CachedImageThumbnail extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const CachedImageThumbnail({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CachedImageWidget.thumbnail(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
    );
  }
}
