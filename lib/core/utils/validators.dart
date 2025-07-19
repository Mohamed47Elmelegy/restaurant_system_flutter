class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'البريد الإلكتروني مطلوب';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'البريد الإلكتروني غير صحيح';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'كلمة المرور مطلوبة';
    if (value.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) return 'الاسم مطلوب';
    if (value.length < 2) return 'الاسم يجب أن يكون حرفين على الأقل';
    return null;
  }

  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName مطلوب';
    return null;
  }
}
