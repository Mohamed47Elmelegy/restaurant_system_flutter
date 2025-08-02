/// 🟦 BaseResponse - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل استجابة API فقط
///
/// 🟦 مبدأ الفتح والإغلاق (OCP)
/// يمكن إضافة أنواع بيانات جديدة بدون تعديل BaseResponse
class BaseResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final Map<String, List<String>>? errors;
  final int? statusCode;
  final DateTime? timestamp;

  const BaseResponse({
    required this.success,
    this.data,
    this.message,
    this.errors,
    this.statusCode,
    this.timestamp,
  });

  /// تحويل JSON إلى BaseResponse
  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return BaseResponse<T>(
      success: json['success'] ?? json['status'] ?? false,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      message: json['message'] ?? 'حدث خطأ غير متوقع',
      errors: json['errors'] != null ? _parseErrors(json['errors']) : null,
      statusCode: json['status_code'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  /// تحويل BaseResponse إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'message': message,
      'errors': errors,
      'status_code': statusCode,
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
  bool get isSuccess => success == true;

  /// التحقق من الفشل
  bool get isError => success == false;

  /// الحصول على رسالة الخطأ الأولى
  String? get firstError {
    if (errors != null && errors!.isNotEmpty) {
      final firstKey = errors!.keys.first;
      final firstErrors = errors![firstKey];
      return firstErrors?.isNotEmpty == true ? firstErrors!.first : null;
    }
    return message;
  }

  /// نسخ BaseResponse مع تعديلات
  BaseResponse<T> copyWith({
    bool? success,
    T? data,
    String? message,
    Map<String, List<String>>? errors,
    int? statusCode,
    DateTime? timestamp,
  }) {
    return BaseResponse<T>(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
      errors: errors ?? this.errors,
      statusCode: statusCode ?? this.statusCode,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseResponse<T> &&
        other.success == success &&
        other.data == data &&
        other.message == message &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode {
    return Object.hash(success, data, message, statusCode);
  }

  @override
  String toString() {
    return 'BaseResponse(success: $success, data: $data, message: $message)';
  }
}
