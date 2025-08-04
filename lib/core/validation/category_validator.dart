import '../../features/admin/presentation/pages/add_category/domain/entities/main_category.dart';
import '../../features/admin/presentation/pages/add_category/domain/entities/sub_category.dart';

/// 🟦 CategoryValidator - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن التحقق من صحة بيانات الفئات فقط
class CategoryValidator {
  /// Validate main category data
  static List<String> validateMainCategory(MainCategory category) {
    final errors = <String>[];

    if (category.name.isEmpty) {
      errors.add('اسم الفئة مطلوب');
    }

    if (category.nameAr.isEmpty) {
      errors.add('اسم الفئة بالعربية مطلوب');
    }

    if (category.sortOrder < 0) {
      errors.add('ترتيب الفئة يجب أن يكون أكبر من أو يساوي صفر');
    }

    return errors;
  }

  /// Validate sub category data
  static List<String> validateSubCategory(SubCategory subCategory) {
    final errors = <String>[];

    if (subCategory.name.isEmpty) {
      errors.add('اسم الفئة الفرعية مطلوب');
    }

    if (subCategory.nameAr.isEmpty) {
      errors.add('اسم الفئة الفرعية بالعربية مطلوب');
    }

    if (subCategory.mainCategoryId <= 0) {
      errors.add('يجب اختيار الفئة الرئيسية');
    }

    if (subCategory.sortOrder < 0) {
      errors.add('ترتيب الفئة الفرعية يجب أن يكون أكبر من أو يساوي صفر');
    }

    return errors;
  }

  /// Check if main category is valid
  static bool isMainCategoryValid(MainCategory category) {
    return validateMainCategory(category).isEmpty;
  }

  /// Check if sub category is valid
  static bool isSubCategoryValid(SubCategory subCategory) {
    return validateSubCategory(subCategory).isEmpty;
  }

  /// Get validation error message
  static String getValidationErrorMessage(List<String> errors) {
    return errors.join(', ');
  }
}
