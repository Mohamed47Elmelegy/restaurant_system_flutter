import '../../features/admin/presentation/pages/add_category/domain/entities/main_category.dart';

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

 
  /// Get validation error message
  static String getValidationErrorMessage(List<String> errors) {
    return errors.join(', ');
  }
}
