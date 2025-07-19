import 'package:dio/dio.dart';
import '../../../../core/network/api_path.dart';
import '../../../../core/error/simple_error.dart';
import 'dart:developer';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  );
  Future<Map<String, dynamic>> getUser(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      log('🔵 Login Request - URL: ${ApiPath.login()}');
      log('🔵 Login Request - Data: {"email": "$email", "password": "***"}');

      final response = await dio.post(
        ApiPath.login(),
        data: {'email': email, 'password': password},
      );

      log('🟢 Login Response Status: ${response.statusCode}');
      log('🟢 Login Response Data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      log('🔴 Login DioException: ${e.message}');
      log('🔴 Login DioException Type: ${e.type}');
      log('🔴 Login DioException Response: ${e.response?.data}');
      log('🔴 Login DioException Status: ${e.response?.statusCode}');

      // تحويل الخطأ إلى رسالة مفهومة
      final apiError = ApiError.fromDioException(e);
      throw Exception(apiError.userMessage);
    } catch (e) {
      log('🔴 Login Unexpected Error: $e');
      throw Exception('حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.');
    }
  }

  @override
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      log('🔵 Register Request - URL: ${ApiPath.register()}');
      log(
        '🔵 Register Request - Data: {"name": "$name", "email": "$email", "password": "***"}',
      );

      final response = await dio.post(
        ApiPath.register(),
        data: {'name': name, 'email': email, 'password': password},
      );

      log('🟢 Register Response Status: ${response.statusCode}');
      log('🟢 Register Response Data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      log('🔴 Register DioException: ${e.message}');
      log('🔴 Register DioException Type: ${e.type}');
      log('🔴 Register DioException Response: ${e.response?.data}');
      log('🔴 Register DioException Status: ${e.response?.statusCode}');

      // تحويل الخطأ إلى رسالة مفهومة
      final apiError = ApiError.fromDioException(e);
      throw Exception(apiError.userMessage);
    } catch (e) {
      log('🔴 Register Unexpected Error: $e');
      throw Exception('حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.');
    }
  }

  @override
  Future<Map<String, dynamic>> getUser(String token) async {
    try {
      log('🔵 GetUser Request - URL: ${ApiPath.user()}');
      log('🔵 GetUser Request - Token: ${token.substring(0, 10)}...');

      final response = await dio.get(
        ApiPath.user(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      log('🟢 GetUser Response Status: ${response.statusCode}');
      log('🟢 GetUser Response Data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      log('🔴 GetUser DioException: ${e.message}');
      log('🔴 GetUser DioException Type: ${e.type}');
      log('🔴 GetUser DioException Response: ${e.response?.data}');
      log('🔴 GetUser DioException Status: ${e.response?.statusCode}');

      // تحويل الخطأ إلى رسالة مفهومة
      final apiError = ApiError.fromDioException(e);
      throw Exception(apiError.userMessage);
    } catch (e) {
      log('🔴 GetUser Unexpected Error: $e');
      throw Exception('حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.');
    }
  }
}
