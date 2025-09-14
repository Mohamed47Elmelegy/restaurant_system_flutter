/// 🟦 FormValidator - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن التحقق من صحة النماذج العامة فقط
class FormValidator {
  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  /// Validate email format
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'البريد الإلكتروني غير صحيح';
    }

    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }

    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[^\d]'), ''))) {
      return 'رقم الهاتف غير صحيح';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    if (password.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }

    return null;
  }

  /// Validate terms and conditions acceptance
  static String? validateTermsAcceptance(bool? isAccepted) {
    if (isAccepted == null || !isAccepted) {
      return 'يجب الموافقة على الشروط والأحكام';
    }
    return null;
  }

  /// Validate number
  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }

    if (int.tryParse(value) == null) {
      return '$fieldName يجب أن يكون رقم صحيح';
    }

    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(String? value, String fieldName) {
    final numberError = validateNumber(value, fieldName);
    if (numberError != null) {
      return numberError;
    }

    final number = int.tryParse(value!);
    if (number != null && number < 0) {
      return '$fieldName يجب أن يكون أكبر من أو يساوي صفر';
    }

    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(
    String? value,
    int minLength,
    String fieldName,
  ) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }

    if (value.trim().length < minLength) {
      return '$fieldName يجب أن يكون $minLength أحرف على الأقل';
    }

    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(
    String? value,
    int maxLength,
    String fieldName,
  ) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }

    if (value.trim().length > maxLength) {
      return '$fieldName يجب أن يكون $maxLength أحرف كحد أقصى';
    }

    return null;
  }

  /// Validate price
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'السعر مطلوب';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'السعر يجب أن يكون رقم صحيح';
    }

    if (price < 0) {
      return 'السعر يجب أن يكون أكبر من أو يساوي صفر';
    }

    return null;
  }

  /// Validate URL
  static String? validateUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      return 'الرابط مطلوب';
    }

    try {
      Uri.parse(url);
    } catch (e) {
      return 'الرابط غير صحيح';
    }

    return null;
  }
}
