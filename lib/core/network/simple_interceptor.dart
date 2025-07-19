import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/simple_error.dart';

/// Interceptor مبسط يجمع بين إضافة التوكن ومعالجة الأخطاء
class SimpleInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  SimpleInterceptor(this.storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // إضافة التوكن تلقائياً
    final token = await storage.read(key: 'token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // تحويل الخطأ إلى ApiError مبسط
    final apiError = ApiError.fromDioException(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: apiError,
        response: err.response,
        type: err.type,
      ),
    );
  }
}
