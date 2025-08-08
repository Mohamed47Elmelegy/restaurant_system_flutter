import 'package:equatable/equatable.dart';
import 'simple_error.dart';

/// نظام موحد للفشل في مستوى Domain
abstract class Failure extends Equatable {
  final String message;
  final String? arabicMessage;
  final String? code;
  final DateTime? timestamp;
  final ErrorType? errorType;

  const Failure({
    required this.message,
    this.arabicMessage,
    this.code,
    this.timestamp,
    this.errorType,
  });

  /// الحصول على رسالة مناسبة للمستخدم
  String get userMessage => arabicMessage ?? message;

  /// الحصول على رسالة مناسبة للمطور
  String get developerMessage => message;

  /// الحصول على رسالة مناسبة للمستخدم بدون نوع الخطأ
  String get cleanUserMessage => arabicMessage ?? message;

  @override
  String toString() {
    return cleanUserMessage;
  }

  @override
  List<Object?> get props => [
    message,
    arabicMessage,
    code,
    timestamp,
    errorType,
  ];

  /// تحويل AppError إلى Failure
  factory Failure.fromAppError(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        return NetworkFailure(
          message: error.message,
          arabicMessage: error.arabicMessage,
          code: error.code,
          timestamp: error.timestamp,
        );
      case ErrorType.server:
        return ServerFailure(
          message: error.message,
          arabicMessage: error.arabicMessage,
          code: error.code,
          timestamp: error.timestamp,
        );
      case ErrorType.auth:
        return AuthFailure(
          message: error.message,
          arabicMessage: error.arabicMessage,
          code: error.code,
          timestamp: error.timestamp,
        );
      case ErrorType.validation:
        return ValidationFailure(
          message: error.message,
          arabicMessage: error.arabicMessage,
          code: error.code,
          timestamp: error.timestamp,
        );
      case ErrorType.timeout:
        return TimeoutFailure(
          message: error.message,
          arabicMessage: error.arabicMessage,
          code: error.code,
          timestamp: error.timestamp,
        );
      case ErrorType.unknown:
        return UnknownFailure(
          message: error.message,
          arabicMessage: error.arabicMessage,
          code: error.code,
          timestamp: error.timestamp,
        );
    }
  }
}

/// فشل في الخادم
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.arabicMessage,
    super.code,
    super.timestamp,
  }) : super(errorType: ErrorType.server);

  /// إنشاء فشل خادم مخصص
  factory ServerFailure.custom(
    String message, {
    String? arabicMessage,
    String? code,
  }) {
    return ServerFailure(
      message: message,
      arabicMessage: arabicMessage ?? 'خطأ في الخادم',
      code: code ?? 'SERVER_FAILURE',
      timestamp: DateTime.now(),
    );
  }
}

/// فشل في الشبكة
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.arabicMessage,
    super.code,
    super.timestamp,
  }) : super(errorType: ErrorType.network);

  /// إنشاء فشل شبكة مخصص
  factory NetworkFailure.custom(
    String message, {
    String? arabicMessage,
    String? code,
  }) {
    return NetworkFailure(
      message: message,
      arabicMessage: arabicMessage ?? 'خطأ في الاتصال بالشبكة',
      code: code ?? 'NETWORK_FAILURE',
      timestamp: DateTime.now(),
    );
  }
}

/// فشل في التخزين المؤقت
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.arabicMessage,
    super.code,
    super.timestamp,
  }) : super(errorType: ErrorType.unknown);

  /// إنشاء فشل تخزين مؤقت مخصص
  factory CacheFailure.custom(
    String message, {
    String? arabicMessage,
    String? code,
  }) {
    return CacheFailure(
      message: message,
      arabicMessage: arabicMessage ?? 'خطأ في التخزين المؤقت',
      code: code ?? 'CACHE_FAILURE',
      timestamp: DateTime.now(),
    );
  }
}

/// فشل في المصادقة
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.arabicMessage,
    super.code,
    super.timestamp,
  }) : super(errorType: ErrorType.auth);

  /// إنشاء فشل مصادقة مخصص
  factory AuthFailure.custom(
    String message, {
    String? arabicMessage,
    String? code,
  }) {
    return AuthFailure(
      message: message,
      arabicMessage: arabicMessage ?? 'خطأ في المصادقة',
      code: code ?? 'AUTH_FAILURE',
      timestamp: DateTime.now(),
    );
  }
}

/// فشل في التحقق من البيانات
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.arabicMessage,
    super.code,
    super.timestamp,
  }) : super(errorType: ErrorType.validation);

  /// إنشاء فشل تحقق مخصص
  factory ValidationFailure.custom(
    String message, {
    String? arabicMessage,
    String? code,
  }) {
    return ValidationFailure(
      message: message,
      arabicMessage: arabicMessage ?? 'خطأ في التحقق من البيانات',
      code: code ?? 'VALIDATION_FAILURE',
      timestamp: DateTime.now(),
    );
  }
}

/// فشل في المهلة الزمنية
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.arabicMessage,
    super.code,
    super.timestamp,
  }) : super(errorType: ErrorType.timeout);

  /// إنشاء فشل مهلة مخصص
  factory TimeoutFailure.custom(
    String message, {
    String? arabicMessage,
    String? code,
  }) {
    return TimeoutFailure(
      message: message,
      arabicMessage: arabicMessage ?? 'انتهت مهلة الاتصال',
      code: code ?? 'TIMEOUT_FAILURE',
      timestamp: DateTime.now(),
    );
  }
}

/// فشل غير معروف
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.arabicMessage,
    super.code,
    super.timestamp,
  }) : super(errorType: ErrorType.unknown);

  /// إنشاء فشل غير معروف مخصص
  factory UnknownFailure.custom(
    String message, {
    String? arabicMessage,
    String? code,
  }) {
    return UnknownFailure(
      message: message,
      arabicMessage: arabicMessage ?? 'خطأ غير معروف',
      code: code ?? 'UNKNOWN_FAILURE',
      timestamp: DateTime.now(),
    );
  }
}

/// فشل في العمليات
class OperationFailure extends Failure {
  const OperationFailure({
    required super.message,
    super.arabicMessage,
    super.code,
    super.timestamp,
  }) : super(errorType: ErrorType.unknown);

  /// إنشاء فشل عملية مخصص
  factory OperationFailure.custom(
    String message, {
    String? arabicMessage,
    String? code,
  }) {
    return OperationFailure(
      message: message,
      arabicMessage: arabicMessage ?? 'فشل في تنفيذ العملية',
      code: code ?? 'OPERATION_FAILURE',
      timestamp: DateTime.now(),
    );
  }
}
