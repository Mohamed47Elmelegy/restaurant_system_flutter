import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:restaurant_system_flutter/core/network/endpoints.dart';
import '../utils/debug_console_messages.dart';
import 'simple_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  final Dio dio;
  final SimpleInterceptor simpleInterceptor;

  DioClient(this.dio, this.simpleInterceptor) {
    dio.options.baseUrl = Endpoints.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);

    // إضافة interceptor واحد فقط
    dio.interceptors.add(simpleInterceptor);
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 120,
      ),
    );
    log(
      DebugConsoleMessages.success(
        'DioClient initialized with simplified error handling!',
      ),
    );
  }
}
