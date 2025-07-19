import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  dio.options.baseUrl = 'http://10.0.2.2:8000/api/v1';
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);

  try {
    print('🔵 Testing API connection...');

    // Test register
    print('🔵 Testing register endpoint...');
    final registerResponse = await dio.post(
      '/auth/register',
      data: {
        'name': 'Test User',
        'email': 'test@example.com',
        'password': 'password123',
      },
    );

    print('🟢 Register Response: ${registerResponse.data}');

    // Test login
    print('🔵 Testing login endpoint...');
    final loginResponse = await dio.post(
      '/auth/login',
      data: {'email': 'test@example.com', 'password': 'password123'},
    );

    print('🟢 Login Response: ${loginResponse.data}');
  } catch (e) {
    print('🔴 Error: $e');
    if (e is DioException) {
      print('🔴 DioException Type: ${e.type}');
      print('🔴 DioException Message: ${e.message}');
      print('🔴 DioException Response: ${e.response?.data}');
      print('🔴 DioException Status: ${e.response?.statusCode}');
    }
  }
}
