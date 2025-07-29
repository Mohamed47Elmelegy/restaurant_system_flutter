import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/simple_error.dart';
import 'dart:developer';

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
      log('🔐 SimpleInterceptor: Token added to request - ${options.uri}');
      log('🔐 SimpleInterceptor: Token preview: ${token.substring(0, 10)}...');
    } else {
      log('⚠️ SimpleInterceptor: No token found for request - ${options.uri}');
    }

    log('🔐 SimpleInterceptor: Request headers: ${options.headers}');
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('🔴 SimpleInterceptor: Request error - ${err.requestOptions.uri}');
    log('🔴 SimpleInterceptor: Error status: ${err.response?.statusCode}');
    log('🔴 SimpleInterceptor: Error message: ${err.message}');

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
