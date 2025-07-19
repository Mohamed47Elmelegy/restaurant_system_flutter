import 'package:dio/dio.dart';

/// نظام مبسط لمعالجة الأخطاء
class ApiError {
  final String message;
  final int? statusCode;
  final Map<String, List<String>>? validationErrors;
  final ErrorType type;

  const ApiError({
    required this.message,
    this.statusCode,
    this.validationErrors,
    required this.type,
  });

  /// تحويل DioException إلى ApiError
  static ApiError fromDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final message = _extractMessage(data, error.message);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError(
          message: 'Request timeout. Please try again.',
          statusCode: statusCode,
          type: ErrorType.timeout,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(statusCode, data, message);

      case DioExceptionType.connectionError:
        return ApiError(
          message: 'No internet connection. Please check your network.',
          statusCode: statusCode,
          type: ErrorType.network,
        );

      case DioExceptionType.cancel:
        return ApiError(
          message: 'Request was cancelled.',
          statusCode: statusCode,
          type: ErrorType.unknown,
        );

      default:
        return ApiError(
          message: message ?? 'An unexpected error occurred.',
          statusCode: statusCode,
          type: ErrorType.unknown,
        );
    }
  }

  static ApiError _handleBadResponse(
    int? statusCode,
    dynamic data,
    String? message,
  ) {
    switch (statusCode) {
      case 400:
        return _handleBadRequest(data, message);
      case 401:
        return ApiError(
          message: message ?? 'Authentication failed. Please login again.',
          statusCode: statusCode,
          type: ErrorType.auth,
        );
      case 403:
        return ApiError(
          message:
              message ?? 'You do not have permission to perform this action.',
          statusCode: statusCode,
          type: ErrorType.auth,
        );
      case 404:
        return ApiError(
          message: message ?? 'The requested resource was not found.',
          statusCode: statusCode,
          type: ErrorType.server,
        );
      case 422:
        return _handleValidationError(data, message);
      case 500:
      case 502:
      case 503:
      case 504:
        return ApiError(
          message: message ?? 'Server error. Please try again later.',
          statusCode: statusCode,
          type: ErrorType.server,
        );
      default:
        return ApiError(
          message: message ?? 'Server error occurred.',
          statusCode: statusCode,
          type: ErrorType.server,
        );
    }
  }

  static ApiError _handleBadRequest(dynamic data, String? message) {
    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      return _handleValidationError(data, message);
    }

    return ApiError(
      message: message ?? 'Invalid request. Please check your input.',
      statusCode: 400,
      type: ErrorType.validation,
    );
  }

  static ApiError _handleValidationError(dynamic data, String? message) {
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

    return ApiError(
      message: message ?? 'Validation failed. Please check your input.',
      statusCode: 422,
      validationErrors: validationErrors,
      type: ErrorType.validation,
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

  /// الحصول على رسالة خطأ مناسبة للمستخدم
  String get userMessage {
    switch (type) {
      case ErrorType.network:
        return 'Network Error: $message';
      case ErrorType.server:
        return 'Server Error: $message';
      case ErrorType.auth:
        return 'Authentication Error: $message';
      case ErrorType.validation:
        return 'Validation Error: $message';
      case ErrorType.timeout:
        return 'Timeout Error: $message';
      case ErrorType.unknown:
        return 'Error: $message';
    }
  }

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
}

/// أنواع الأخطاء
enum ErrorType { network, server, auth, validation, timeout, unknown }
