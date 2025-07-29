class ApiResponse<T> {
  final bool status;
  final String message;
  final T? data;
  final Map<String, List<String>>? errors;
  final int? statusCode;

  const ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  /// تحويل JSON إلى ApiResponse
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['success'] ?? json['status'] ?? false,
      message: json['message'] ?? 'حدث خطأ غير متوقع',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      errors: json['errors'] != null ? _parseErrors(json['errors']) : null,
      statusCode: json['status_code'],
    );
  }

  /// تحويل ApiResponse إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
      'errors': errors,
      'status_code': statusCode,
    };
  }

  /// تحليل أخطاء التحقق
  static Map<String, List<String>>? _parseErrors(dynamic errors) {
    if (errors is Map<String, dynamic>) {
      return errors.map((key, value) {
        if (value is List) {
          return MapEntry(key, value.cast<String>());
        } else if (value is String) {
          return MapEntry(key, [value]);
        }
        return MapEntry(key, [value.toString()]);
      });
    }
    return null;
  }

  /// التحقق من النجاح
  bool get isSuccess => status == true;

  /// التحقق من الفشل
  bool get isError => status == false;

  /// الحصول على رسالة الخطأ الأولى
  String get firstErrorMessage {
    if (errors != null && errors!.isNotEmpty) {
      final firstError = errors!.values.first;
      if (firstError.isNotEmpty) {
        return firstError.first;
      }
    }
    return message;
  }

  /// الحصول على جميع رسائل الأخطاء
  List<String> get allErrorMessages {
    List<String> messages = [];

    if (errors != null) {
      for (var errorList in errors!.values) {
        messages.addAll(errorList);
      }
    }

    if (messages.isEmpty) {
      messages.add(message);
    }

    return messages;
  }

  /// الحصول على رسالة خطأ محددة
  String? getErrorForField(String fieldName) {
    if (errors != null && errors!.containsKey(fieldName)) {
      final fieldErrors = errors![fieldName];
      if (fieldErrors != null && fieldErrors.isNotEmpty) {
        return fieldErrors.first;
      }
    }
    return null;
  }

  /// إنشاء استجابة نجاح
  factory ApiResponse.success(T data, {String message = 'تمت العملية بنجاح'}) {
    return ApiResponse<T>(status: true, message: message, data: data);
  }

  /// إنشاء استجابة خطأ
  factory ApiResponse.error(
    String message, {
    Map<String, List<String>>? errors,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      status: false,
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }

  /// إنشاء استجابة خطأ في التحقق
  factory ApiResponse.validationError(
    Map<String, List<String>> errors, {
    String message = 'يرجى تصحيح الأخطاء في البيانات المدخلة',
  }) {
    return ApiResponse<T>(
      status: false,
      message: message,
      errors: errors,
      statusCode: 422,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(status: $status, message: $message, data: $data, errors: $errors, statusCode: $statusCode)';
  }
}
