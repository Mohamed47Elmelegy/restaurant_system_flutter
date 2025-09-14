import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'api_response.dart';
import 'failures.dart';
import 'simple_error.dart';

/// مساعد لمعالجة الأخطاء - يوفر وظائف شائعة لمعالجة الأخطاء
class ErrorHelper {
  /// تحويل AppError إلى Failure
  static Failure appErrorToFailure(AppError error) {
    return Failure.fromAppError(error);
  }

  /// تحويل ApiResponse إلى Either
  static Either<Failure, T> apiResponseToEither<T>(ApiResponse<T> response) {
    if (response.isSuccess) {
      return Right(response.data as T);
    } else {
      return Left(Failure.fromAppError(response.toAppError()));
    }
  }

  /// إنشاء خطأ شبكة
  static AppError networkError([String? message]) {
    return AppError.network(
      message ?? 'Network connection failed',
      arabicMessage: 'فشل في الاتصال بالشبكة',
    );
  }

  /// إنشاء خطأ خادم
  static AppError serverError([String? message]) {
    return AppError.server(
      message ?? 'Server error occurred',
      arabicMessage: 'حدث خطأ في الخادم',
    );
  }

  /// إنشاء خطأ مصادقة
  static AppError authError([String? message]) {
    return AppError.auth(
      message ?? 'Authentication failed',
      arabicMessage: 'فشل في المصادقة',
    );
  }

  /// إنشاء خطأ تحقق
  static AppError validationError(
    String message, {
    Map<String, List<String>>? errors,
  }) {
    return AppError.validation(
      message,
      arabicMessage: 'خطأ في التحقق من البيانات',
      validationErrors: errors,
    );
  }

  /// إنشاء خطأ مهلة
  static AppError timeoutError([String? message]) {
    return AppError.custom(
      message: message ?? 'Request timeout',
      arabicMessage: 'انتهت مهلة الاتصال',
      type: ErrorType.timeout,
      code: 'TIMEOUT_ERROR',
    );
  }

  /// إنشاء خطأ غير معروف
  static AppError unknownError([String? message]) {
    return AppError.custom(
      message: message ?? 'Unknown error occurred',
      arabicMessage: 'حدث خطأ غير معروف',
      type: ErrorType.unknown,
      code: 'UNKNOWN_ERROR',
    );
  }

  /// التحقق من إمكانية إعادة المحاولة
  static bool isRetryable(AppError error) {
    return error.isRetryable;
  }

  /// التحقق من الحاجة لإعادة تسجيل الدخول
  static bool requiresReauth(AppError error) {
    return error.requiresReauth;
  }

  /// الحصول على رسالة خطأ مناسبة للمستخدم
  static String getUserMessage(AppError error) {
    return error.cleanUserMessage;
  }

  /// الحصول على رسالة خطأ مناسبة للمطور
  static String getDeveloperMessage(AppError error) {
    return error.fullDeveloperMessage;
  }

  /// معالجة خطأ DioException - يستخدم AppError
  static AppError handleDioException(dynamic error) {
    if (error is DioException) {
      return AppError.fromDioException(error);
    }
    return unknownError(error.toString());
  }

  /// معالجة خطأ عام - يستخدم AppError
  static AppError handleException(dynamic error) {
    if (error is DioException) {
      return AppError.fromDioException(error);
    } else if (error is AppError) {
      return error;
    } else {
      return unknownError(error.toString());
    }
  }

  /// إنشاء استجابة نجاح
  static ApiResponse<T> successResponse<T>(
    T data, {
    String? message,
    String? arabicMessage,
  }) {
    return ApiResponse.success(
      data,
      message: message ?? 'Operation completed successfully',
      arabicMessage: arabicMessage,
    );
  }

  /// إنشاء استجابة خطأ
  static ApiResponse<T> errorResponse<T>(
    String message, {
    String? arabicMessage,
    Map<String, List<String>>? errors,
    int? statusCode,
    String? code,
  }) {
    return ApiResponse.error(
      message,
      arabicMessage: arabicMessage,
      errors: errors,
      statusCode: statusCode,
      code: code,
    );
  }

  /// إنشاء استجابة خطأ تحقق
  static ApiResponse<T> validationErrorResponse<T>(
    Map<String, List<String>> errors, {
    String? message,
    String? arabicMessage,
  }) {
    return ApiResponse.validationError(
      errors,
      message: message ?? 'Validation failed',
      arabicMessage: arabicMessage,
    );
  }

  /// إنشاء استجابة خطأ من DioException - يستخدم AppError
  static ApiResponse<T> dioExceptionResponse<T>(DioException error) {
    return ApiResponse.fromDioException(error);
  }

  /// تحويل خطأ إلى Either
  static Either<Failure, T> errorToEither<T>(AppError error) {
    return Left(Failure.fromAppError(error));
  }

  /// تحويل نجاح إلى Either
  static Either<Failure, T> successToEither<T>(T data) {
    return Right(data);
  }

  /// معالجة Either مع خطأ
  static Either<Failure, T> handleEitherError<T>(dynamic error) {
    final appError = handleException(error);
    return errorToEither(appError);
  }

  /// إنشاء خطأ مخصص مع رسائل عربية
  static AppError customError({
    required String message,
    required String arabicMessage,
    ErrorType type = ErrorType.unknown,
    int? statusCode,
    String? code,
    Map<String, List<String>>? validationErrors,
  }) {
    return AppError.custom(
      message: message,
      arabicMessage: arabicMessage,
      statusCode: statusCode,
      validationErrors: validationErrors,
      type: type,
      code: code,
    );
  }

  /// إنشاء فشل مخصص
  static Failure customFailure({
    required String message,
    required String arabicMessage,
    String? code,
    ErrorType? errorType,
  }) {
    return UnknownFailure.custom(
      message,
      arabicMessage: arabicMessage,
      code: code,
    );
  }

  /// التحقق من نوع الخطأ
  static bool isNetworkError(AppError error) => error.type == ErrorType.network;
  static bool isServerError(AppError error) => error.type == ErrorType.server;
  static bool isAuthError(AppError error) => error.type == ErrorType.auth;
  static bool isValidationError(AppError error) =>
      error.type == ErrorType.validation;
  static bool isTimeoutError(AppError error) => error.type == ErrorType.timeout;
  static bool isUnknownError(AppError error) => error.type == ErrorType.unknown;

  /// الحصول على رمز الخطأ
  static String getErrorCode(AppError error) => error.code ?? 'UNKNOWN_ERROR';

  /// الحصول على رمز الحالة
  static int? getStatusCode(AppError error) => error.statusCode;

  /// التحقق من وجود أخطاء تحقق
  static bool hasValidationErrors(AppError error) => error.hasValidationErrors;

  /// الحصول على أول خطأ تحقق
  static String? getFirstValidationError(AppError error) =>
      error.firstValidationError;

  /// الحصول على جميع أخطاء التحقق
  static List<String> getAllValidationErrors(AppError error) =>
      error.allValidationErrors;
}

/// امتدادات مفيدة للتعامل مع الأخطاء
extension ErrorExtensions on AppError {
  /// تحويل إلى Failure
  Failure toFailure() => Failure.fromAppError(this);

  /// التحقق من نوع محدد
  bool get isNetwork => type == ErrorType.network;
  bool get isServer => type == ErrorType.server;
  bool get isAuth => type == ErrorType.auth;
  bool get isValidation => type == ErrorType.validation;
  bool get isTimeout => type == ErrorType.timeout;
  bool get isUnknown => type == ErrorType.unknown;

  /// الحصول على التسمية العربية
  String get arabicLabel => type.arabicLabel;

  /// الحصول على التسمية الإنجليزية
  String get englishLabel => type.englishLabel;
}

/// امتدادات مفيدة للتعامل مع ApiResponse
extension ApiResponseExtensions<T> on ApiResponse<T> {
  /// تحويل إلى Either
  Either<Failure, T> toEither() => ErrorHelper.apiResponseToEither(this);

  /// تحويل إلى AppError
  AppError toAppError() => AppError.custom(
    message: message,
    arabicMessage: arabicMessage,
    statusCode: statusCode,
    validationErrors: errors,
    type: _getErrorType(statusCode),
    code: code,
  );

  /// الحصول على نوع الخطأ
  ErrorType _getErrorType(int? statusCode) {
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
}
