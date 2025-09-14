import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl(this.remoteDataSource, this.secureStorage);

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      log('🔄 Repository: Starting login process for $email');

      final response = await remoteDataSource.login(email, password);
      log('📦 Repository: Raw response received: $response');

      if (response['status'] == true) {
        final data = response['data'];
        log('📦 Repository: Processing successful response data: $data');

        final user = UserModel.fromJson(data['user']);
        log('👤 Repository: User model created: ${user.name}');

        final auth = AuthModel(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          user: user,
          expiresAt: DateTime.parse(data['expires_at']),
        );

        // حفظ البيانات في الـ secure storage
        await _saveAuthDataToStorage(auth);
        log('✅ Repository: Auth data saved to secure storage');

        log('✅ Repository: Auth model created successfully');
        return Right(auth);
      } else {
        log('❌ Repository: Login failed - ${response['message']}');
        return Left(
          AuthFailure(
            message: response['message'] ?? 'فشل تسجيل الدخول',
            code: 'LOGIN_FAILED',
          ),
        );
      }
    } catch (e) {
      log('💥 Repository: Login error caught: $e');
      return Left(AuthFailure(message: e.toString(), code: 'LOGIN_ERROR'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      log('🔄 Repository: Starting register process for $email');

      final response = await remoteDataSource.register(name, email, password);
      log('📦 Repository: Raw response received: $response');

      if (response['status'] == true) {
        final data = response['data'];
        log('📦 Repository: Processing successful response data: $data');

        final user = UserModel.fromJson(data['user']);
        log('👤 Repository: User model created: ${user.name}');

        final auth = AuthModel(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          user: user,
          expiresAt: DateTime.parse(data['expires_at']),
        );

        // حفظ البيانات في الـ secure storage
        await _saveAuthDataToStorage(auth);
        log('✅ Repository: Auth data saved to secure storage');

        log('✅ Repository: Auth model created successfully');
        return Right(auth);
      } else {
        log('❌ Repository: Register failed - ${response['message']}');
        return Left(
          AuthFailure(
            message: response['message'] ?? 'فشل التسجيل',
            code: 'REGISTER_FAILED',
          ),
        );
      }
    } catch (e) {
      log('💥 Repository: Register error caught: $e');
      return Left(AuthFailure(message: e.toString(), code: 'REGISTER_ERROR'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      log('🔄 Repository: Starting getCurrentUser process');

      final token = await secureStorage.read(key: 'token');
      if (token == null) {
        log('❌ Repository: No token found in secure storage');
        return const Left(
          AuthFailure(
            message: 'لم يتم العثور على بيانات تسجيل الدخول',
            code: 'NO_TOKEN_FOUND',
          ),
        );
      }

      final response = await remoteDataSource.getUser(token);
      log('📦 Repository: Raw response received: $response');

      if (response['status'] == true) {
        final user = UserModel.fromJson(response['data']['user']);
        log('✅ Repository: User retrieved successfully: ${user.name}');
        return Right(user);
      } else {
        log('❌ Repository: GetUser failed - ${response['message']}');
        return Left(
          AuthFailure(
            message: response['message'] ?? 'فشل جلب بيانات المستخدم',
            code: 'GET_USER_FAILED',
          ),
        );
      }
    } catch (e) {
      log('💥 Repository: GetUser error caught: $e');
      return Left(AuthFailure(message: e.toString(), code: 'GET_USER_ERROR'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      log('🔄 Repository: Starting logout process');

      // حذف جميع البيانات من الـ secure storage
      await secureStorage.deleteAll();
      log('✅ Repository: All auth data cleared from secure storage');

      return const Right(null);
    } catch (e) {
      log('💥 Repository: Logout error caught: $e');
      return Left(AuthFailure(message: e.toString(), code: 'LOGOUT_ERROR'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> refreshToken() async {
    // TODO: Implement token refresh
    return const Left(
      AuthFailure(
        message: 'Token refresh not implemented yet',
        code: 'REFRESH_TOKEN_NOT_IMPLEMENTED',
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await secureStorage.read(key: 'token');
      final isLoggedIn = token != null;
      log('🔍 Repository: Is logged in: $isLoggedIn');
      return Right(isLoggedIn);
    } catch (e) {
      log('💥 Repository: IsLoggedIn error caught: $e');
      return Left(
        AuthFailure(message: e.toString(), code: 'IS_LOGGED_IN_ERROR'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveAuthData(AuthEntity auth) async {
    try {
      await _saveAuthDataToStorage(auth as AuthModel);
      log('✅ Repository: Auth data saved to secure storage');
      return const Right(null);
    } catch (e) {
      log('💥 Repository: SaveAuthData error caught: $e');
      return Left(
        AuthFailure(message: e.toString(), code: 'SAVE_AUTH_DATA_ERROR'),
      );
    }
  }

  @override
  Future<Either<Failure, AuthEntity?>> getAuthData() async {
    try {
      final token = await secureStorage.read(key: 'token');
      final userJsonStr = await secureStorage.read(key: 'user');
      final expiresAtStr = await secureStorage.read(key: 'expires_at');

      if (token == null || userJsonStr == null || expiresAtStr == null) {
        log('❌ Repository: Incomplete auth data in secure storage');
        return const Right(null);
      }

      // تحويل الـ JSON string إلى Map
      final userJson = jsonDecode(userJsonStr) as Map<String, dynamic>;
      final user = UserModel.fromJson(userJson);

      final auth = AuthModel(
        accessToken: token,
        refreshToken: token, // For now using same token
        user: user,
        expiresAt: DateTime.parse(expiresAtStr),
      );

      log('✅ Repository: Auth data retrieved from secure storage');
      return Right(auth);
    } catch (e) {
      log('💥 Repository: GetAuthData error caught: $e');
      return Left(
        AuthFailure(message: e.toString(), code: 'GET_AUTH_DATA_ERROR'),
      );
    }
  }

  /// حفظ بيانات المصادقة في الـ secure storage
  Future<void> _saveAuthDataToStorage(AuthModel auth) async {
    await secureStorage.write(key: 'token', value: auth.accessToken);
    await secureStorage.write(
      key: 'user',
      value: jsonEncode((auth.user as UserModel).toJson()),
    );
    await secureStorage.write(
      key: 'expires_at',
      value: auth.expiresAt.toIso8601String(),
    );
    log('💾 Repository: Auth data saved to secure storage');
  }
}
