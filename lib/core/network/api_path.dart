import 'endpoints.dart';

class ApiPath {
  static String login() => Endpoints.baseUrl + Endpoints.login;
  static String register() => Endpoints.baseUrl + Endpoints.register;
  static String user() => Endpoints.baseUrl + Endpoints.user;
  // Add more helpers as needed
}
