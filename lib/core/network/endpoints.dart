class Endpoints {
  // Use localhost for Android emulator and 127.0.0.1 for iOS simulator
  static const String baseUrl =
      //'http://192.168.1.31:8000/api/v1';
      'http://10.0.2.2:8000/api/v1'; // For Android Emulator
  // static const String baseUrl = 'http://127.0.0.1:8000/api/v1'; // For iOS Simulator
  // static const String baseUrl = 'http://localhost:8000/api/v1'; // For Web

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String user = '/user';

  // Add more endpoints as needed
}
