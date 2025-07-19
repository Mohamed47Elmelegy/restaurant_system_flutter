import 'package:dartz/dartz.dart';
import 'dart:developer';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

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

      // TODO: Get token from secure storage
      final token = 'mock_token'; // Replace with actual token
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
    // TODO: Implement logout - clear tokens from secure storage
    return const Right(null);
  }

  @override
  Future<Either<Failure, AuthEntity>> refreshToken() async {
    // TODO: Implement token refresh
    return Left(
      AuthFailure(
        message: 'Token refresh not implemented yet',
        code: 'REFRESH_TOKEN_NOT_IMPLEMENTED',
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    // TODO: Check if user is logged in by checking token in secure storage
    return const Right(false);
  }

  @override
  Future<Either<Failure, void>> saveAuthData(AuthEntity auth) async {
    // TODO: Save auth data to secure storage
    return const Right(null);
  }

  @override
  Future<Either<Failure, AuthEntity?>> getAuthData() async {
    // TODO: Get auth data from secure storage
    return const Right(null);
  }
}
