import '../entities/main_category.dart';

class CategoryHelper {
  // Backward-compatible simple resolver
  static String getNameById({
    required int id,
    required List<CategoryEntity> categories,
    String fallbackPrefix = 'تصنيف ',
  }) {
    return getNameByIdFlexible(
      id: id,
      categories: categories,
      fallbackPrefix: fallbackPrefix,
    );
  }

  static String getNameByStringId({
    required String id,
    required List<CategoryEntity> categories,
    String fallbackPrefix = 'تصنيف ',
  }) {
    return getNameByIdFlexible(
      id: id,
      categories: categories,
      fallbackPrefix: fallbackPrefix,
    );
  }

  // Robust resolver: handles int or string ids, trims, and compares numerically
  static String getNameByIdFlexible({
    required Object id,
    required List<CategoryEntity> categories,
    String fallbackPrefix = 'تصنيف ',
  }) {
    final String raw = id.toString().trim();
    final String rawLower = raw.toLowerCase();
    final String rawDigits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    final int? rawInt = int.tryParse(rawDigits.isEmpty ? raw : rawDigits);

    for (final category in categories) {
      final String cid = (category.id).trim();
      if (cid == raw || cid.toLowerCase() == rawLower) {
        return category.name;
      }
      final String cidDigits = cid.replaceAll(RegExp(r'[^0-9]'), '');
      final int? cidInt = int.tryParse(cidDigits.isEmpty ? cid : cidDigits);
      if (rawInt != null && cidInt != null && rawInt == cidInt) {
        return category.name;
      }
      if (rawInt != null && category.sortOrder == rawInt) {
        return category.name;
      }
    }

    return '$fallbackPrefix$raw';
  }
}
