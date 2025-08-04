import 'package:dio/dio.dart';

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

  /// إنشاء استجابة خطأ من DioException
  factory ApiResponse.fromDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    String message = 'حدث خطأ في الاتصال';
    Map<String, List<String>>? errors;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.';
        break;
      case DioExceptionType.badResponse:
        if (statusCode == 422 && data is Map && data['errors'] != null) {
          // Validation errors
          final validationErrors = data['errors'] as Map<String, dynamic>;
          errors = validationErrors.map((key, value) {
            if (value is List) {
              return MapEntry(key, value.cast<String>());
            } else if (value is String) {
              return MapEntry(key, [value]);
            }
            return MapEntry(key, [value.toString()]);
          });
          message = 'يرجى تصحيح الأخطاء في البيانات المدخلة';
        } else if (statusCode == 401) {
          message = 'فشل في المصادقة. يرجى تسجيل الدخول مرة أخرى.';
        } else if (statusCode == 403) {
          message = 'ليس لديك صلاحية لتنفيذ هذا الإجراء.';
        } else if (statusCode == 404) {
          message = 'لم يتم العثور على المورد المطلوب.';
        } else if (statusCode == 500) {
          message = 'خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقاً.';
        } else {
          message = data?['message'] ?? 'حدث خطأ في الخادم';
        }
        break;
      case DioExceptionType.connectionError:
        message = 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.';
        break;
      case DioExceptionType.cancel:
        message = 'تم إلغاء الطلب.';
        break;
      default:
        message = e.message ?? 'حدث خطأ غير متوقع';
    }

    return ApiResponse<T>(
      status: false,
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(status: $status, message: $message, data: $data, errors: $errors, statusCode: $statusCode)';
  }
}
