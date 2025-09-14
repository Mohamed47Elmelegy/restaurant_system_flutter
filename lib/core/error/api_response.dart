import 'package:dio/dio.dart';
import 'simple_error.dart';

/// نظام موحد للاستجابات من API
class ApiResponse<T> {
  final bool status;
  final String message;
  final String? arabicMessage;
  final T? data;
  final Map<String, List<String>>? errors;
  final int? statusCode;
  final String? code;
  final DateTime? timestamp;

  const ApiResponse({
    required this.status,
    required this.message,
    this.arabicMessage,
    this.data,
    this.errors,
    this.statusCode,
    this.code,
    this.timestamp,
  });

  /// تحويل JSON إلى ApiResponse
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['success'] ?? json['status'] ?? false,
      message: json['message'] ?? 'An unexpected error occurred',
      arabicMessage:
          json['arabic_message'] ?? json['message_ar'] ?? 'حدث خطأ غير متوقع',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      errors: json['errors'] != null ? _parseErrors(json['errors']) : null,
      statusCode: json['status_code'],
      code: json['code'],
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : DateTime.now(),
    );
  }

  /// تحويل ApiResponse إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'arabic_message': arabicMessage,
      'data': data,
      'errors': errors,
      'status_code': statusCode,
      'code': code,
      'timestamp': timestamp?.toIso8601String(),
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
    return userMessage;
  }

  /// الحصول على جميع رسائل الأخطاء
  List<String> get allErrorMessages {
    final List<String> messages = [];

    if (errors != null) {
      for (var errorList in errors!.values) {
        messages.addAll(errorList);
      }
    }

    if (messages.isEmpty) {
      messages.add(userMessage);
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

  /// الحصول على رسالة مناسبة للمستخدم (عربية)
  String get userMessage => arabicMessage ?? message;

  /// الحصول على رسالة مناسبة للمطور (إنجليزية)
  String get developerMessage => message;

  /// الحصول على رسالة مناسبة للمستخدم بدون نوع الخطأ
  String get cleanUserMessage => arabicMessage ?? message;

  /// إنشاء استجابة نجاح
  factory ApiResponse.success(
    T data, {
    String message = 'Operation completed successfully',
    String? arabicMessage,
  }) {
    return ApiResponse<T>(
      status: true,
      message: message,
      arabicMessage: arabicMessage ?? 'تمت العملية بنجاح',
      data: data,
      timestamp: DateTime.now(),
    );
  }

  /// إنشاء استجابة خطأ
  factory ApiResponse.error(
    String message, {
    String? arabicMessage,
    Map<String, List<String>>? errors,
    int? statusCode,
    String? code,
  }) {
    return ApiResponse<T>(
      status: false,
      message: message,
      arabicMessage: arabicMessage,
      errors: errors,
      statusCode: statusCode,
      code: code,
      timestamp: DateTime.now(),
    );
  }

  /// إنشاء استجابة خطأ في التحقق
  factory ApiResponse.validationError(
    Map<String, List<String>> errors, {
    String message = 'Please correct the errors in your input',
    String? arabicMessage,
  }) {
    return ApiResponse<T>(
      status: false,
      message: message,
      arabicMessage: arabicMessage ?? 'يرجى تصحيح الأخطاء في البيانات المدخلة',
      errors: errors,
      statusCode: 422,
      code: 'VALIDATION_ERROR',
      timestamp: DateTime.now(),
    );
  }

  /// إنشاء استجابة خطأ من DioException - يستخدم AppError
  factory ApiResponse.fromDioException(DioException e) {
    final appError = AppError.fromDioException(e);

    return ApiResponse<T>(
      status: false,
      message: appError.message,
      arabicMessage: appError.arabicMessage,
      errors: appError.validationErrors,
      statusCode: appError.statusCode,
      code: appError.code,
      timestamp: appError.timestamp,
    );
  }

  /// تحويل ApiResponse إلى AppError
  AppError toAppError() {
    return AppError.custom(
      message: message,
      arabicMessage: arabicMessage,
      statusCode: statusCode,
      validationErrors: errors,
      type: _getErrorType(statusCode),
      code: code,
    );
  }

  /// الحصول على نوع الخطأ
  static ErrorType _getErrorType(int? statusCode) {
    if (statusCode == null) return ErrorType.unknown;

    switch (statusCode) {
      case 400:
      case 422:
        return ErrorType.validation;
      case 401:
      case 403:
        return ErrorType.auth;
      case 404:
      case 500:
      case 502:
      case 503:
      case 504:
        return ErrorType.server;
      default:
        return ErrorType.unknown;
    }
  }

  @override
  String toString() {
    return cleanUserMessage;
  }
}
