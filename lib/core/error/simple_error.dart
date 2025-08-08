import 'package:dio/dio.dart';

/// نظام موحد ومحسن لمعالجة الأخطاء
class AppError {
  final String message;
  final String? arabicMessage;
  final int? statusCode;
  final Map<String, List<String>>? validationErrors;
  final ErrorType type;
  final String? code;
  final DateTime? timestamp;

  const AppError({
    required this.message,
    this.arabicMessage,
    this.statusCode,
    this.validationErrors,
    required this.type,
    this.code,
    this.timestamp,
  });

  /// تحويل DioException إلى AppError
  static AppError fromDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final message = _extractMessage(data, error.message);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError(
          message: 'Request timeout. Please try again.',
          arabicMessage: 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.',
          statusCode: statusCode,
          type: ErrorType.timeout,
          timestamp: DateTime.now(),
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(statusCode, data, message);

      case DioExceptionType.connectionError:
        return AppError(
          message: 'No internet connection. Please check your network.',
          arabicMessage: 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.',
          statusCode: statusCode,
          type: ErrorType.network,
          timestamp: DateTime.now(),
        );

      case DioExceptionType.cancel:
        return AppError(
          message: 'Request was cancelled.',
          arabicMessage: 'تم إلغاء الطلب.',
          statusCode: statusCode,
          type: ErrorType.unknown,
          timestamp: DateTime.now(),
        );

      default:
        return AppError(
          message: message ?? 'An unexpected error occurred.',
          arabicMessage: 'حدث خطأ غير متوقع.',
          statusCode: statusCode,
          type: ErrorType.unknown,
          timestamp: DateTime.now(),
        );
    }
  }

  static AppError _handleBadResponse(
    int? statusCode,
    dynamic data,
    String? message,
  ) {
    switch (statusCode) {
      case 400:
        return _handleBadRequest(data, message);
      case 401:
        return AppError(
          message: message ?? 'Email or password is incorrect',
          arabicMessage: 'خطاء في البريد الإلكتروني أو كلمة المرور',
          statusCode: statusCode,
          type: ErrorType.auth,
          code: 'AUTH_FAILED',
          timestamp: DateTime.now(),
        );
      case 403:
        return AppError(
          message:
              message ?? 'You do not have permission to perform this action.',
          arabicMessage: 'ليس لديك صلاحية لتنفيذ هذا الإجراء.',
          statusCode: statusCode,
          type: ErrorType.auth,
          code: 'FORBIDDEN',
          timestamp: DateTime.now(),
        );
      case 404:
        return AppError(
          message: message ?? 'The requested resource was not found.',
          arabicMessage: 'لم يتم العثور على المورد المطلوب.',
          statusCode: statusCode,
          type: ErrorType.server,
          code: 'NOT_FOUND',
          timestamp: DateTime.now(),
        );
      case 422:
        return _handleValidationError(data, message);
      case 500:
      case 502:
      case 503:
      case 504:
        return AppError(
          message: message ?? 'Server error. Please try again later.',
          arabicMessage: 'خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقاً.',
          statusCode: statusCode,
          type: ErrorType.server,
          code: 'SERVER_ERROR',
          timestamp: DateTime.now(),
        );
      default:
        return AppError(
          message: message ?? 'Server error occurred.',
          arabicMessage: 'حدث خطأ في الخادم.',
          statusCode: statusCode,
          type: ErrorType.server,
          timestamp: DateTime.now(),
        );
    }
  }

  static AppError _handleBadRequest(dynamic data, String? message) {
    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      return _handleValidationError(data, message);
    }

    return AppError(
      message: message ?? 'Invalid request. Please check your input.',
      arabicMessage: 'طلب غير صحيح. يرجى التحقق من البيانات المدخلة.',
      statusCode: 400,
      type: ErrorType.validation,
      code: 'BAD_REQUEST',
      timestamp: DateTime.now(),
    );
  }

  static AppError _handleValidationError(dynamic data, String? message) {
    Map<String, List<String>>? validationErrors;

    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        validationErrors = errors.map(
          (key, value) => MapEntry(
            key,
            value is List ? value.cast<String>() : [value.toString()],
          ),
        );
      }
    }

    return AppError(
      message: message ?? 'Validation failed. Please check your input.',
      arabicMessage: 'فشل في التحقق من البيانات. يرجى تصحيح الأخطاء.',
      statusCode: 422,
      validationErrors: validationErrors,
      type: ErrorType.validation,
      code: 'VALIDATION_ERROR',
      timestamp: DateTime.now(),
    );
  }

  static String? _extractMessage(dynamic data, String? fallback) {
    if (data is Map<String, dynamic>) {
      return data['message'] ??
          data['error'] ??
          data['msg'] ??
          data['detail'] ??
          data['description'] ??
          fallback;
    } else if (data is String) {
      return data;
    }
    return fallback;
  }

  /// الحصول على رسالة خطأ مناسبة للمستخدم (عربية)
  String get userMessage => arabicMessage ?? message;

  /// الحصول على رسالة خطأ مناسبة للمطور (إنجليزية)
  String get developerMessage => message;

  /// الحصول على رسالة خطأ مناسبة للمستخدم بدون نوع الخطأ
  String get cleanUserMessage => arabicMessage ?? message;

  /// الحصول على رسالة خطأ كاملة للمطور
  String get fullDeveloperMessage => '${type.englishLabel}: $message';

  /// التحقق من إمكانية إعادة المحاولة
  bool get isRetryable {
    return type == ErrorType.network ||
        type == ErrorType.timeout ||
        type == ErrorType.server;
  }

  /// التحقق من الحاجة لإعادة تسجيل الدخول
  bool get requiresReauth {
    return type == ErrorType.auth;
  }

  /// التحقق من وجود أخطاء تحقق
  bool get hasValidationErrors =>
      validationErrors != null && validationErrors!.isNotEmpty;

  /// الحصول على أول رسالة خطأ تحقق
  String? get firstValidationError {
    if (hasValidationErrors) {
      final firstError = validationErrors!.values.first;
      if (firstError.isNotEmpty) {
        return firstError.first;
      }
    }
    return null;
  }

  /// الحصول على جميع رسائل أخطاء التحقق
  List<String> get allValidationErrors {
    List<String> errors = [];
    if (hasValidationErrors) {
      for (var errorList in validationErrors!.values) {
        errors.addAll(errorList);
      }
    }
    return errors;
  }

  /// إنشاء خطأ مخصص
  factory AppError.custom({
    required String message,
    String? arabicMessage,
    int? statusCode,
    Map<String, List<String>>? validationErrors,
    ErrorType type = ErrorType.unknown,
    String? code,
  }) {
    return AppError(
      message: message,
      arabicMessage: arabicMessage,
      statusCode: statusCode,
      validationErrors: validationErrors,
      type: type,
      code: code,
      timestamp: DateTime.now(),
    );
  }

  /// إنشاء خطأ شبكة
  factory AppError.network(String message, {String? arabicMessage}) {
    return AppError(
      message: message,
      arabicMessage: arabicMessage ?? 'خطأ في الاتصال بالشبكة',
      type: ErrorType.network,
      code: 'NETWORK_ERROR',
      timestamp: DateTime.now(),
    );
  }

  /// إنشاء خطأ خادم
  factory AppError.server(
    String message, {
    String? arabicMessage,
    int? statusCode,
  }) {
    return AppError(
      message: message,
      arabicMessage: arabicMessage ?? 'خطأ في الخادم',
      statusCode: statusCode,
      type: ErrorType.server,
      code: 'SERVER_ERROR',
      timestamp: DateTime.now(),
    );
  }

  /// إنشاء خطأ مصادقة
  factory AppError.auth(
    String message, {
    String? arabicMessage,
    int? statusCode,
  }) {
    return AppError(
      message: message,
      arabicMessage: arabicMessage ?? 'خطأ في المصادقة',
      statusCode: statusCode,
      type: ErrorType.auth,
      code: 'AUTH_ERROR',
      timestamp: DateTime.now(),
    );
  }

  /// إنشاء خطأ تحقق
  factory AppError.validation(
    String message, {
    String? arabicMessage,
    Map<String, List<String>>? validationErrors,
  }) {
    return AppError(
      message: message,
      arabicMessage: arabicMessage ?? 'خطأ في التحقق من البيانات',
      validationErrors: validationErrors,
      type: ErrorType.validation,
      code: 'VALIDATION_ERROR',
      timestamp: DateTime.now(),
    );
  }

  @override
  String toString() {
    return cleanUserMessage;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppError &&
        other.message == message &&
        other.statusCode == statusCode &&
        other.type == type &&
        other.code == code;
  }

  @override
  int get hashCode {
    return Object.hash(message, statusCode, type, code);
  }
}

/// أنواع الأخطاء المحسنة
enum ErrorType {
  network('Network Error', 'خطأ في الشبكة'),
  server('Server Error', 'خطأ في الخادم'),
  auth('Authentication Error', 'خطأ في المصادقة'),
  validation('Validation Error', 'خطأ في التحقق'),
  timeout('Timeout Error', 'خطأ في المهلة'),
  unknown('Unknown Error', 'خطأ غير معروف');

  const ErrorType(this.englishLabel, this.arabicLabel);

  final String englishLabel;
  final String arabicLabel;
}
