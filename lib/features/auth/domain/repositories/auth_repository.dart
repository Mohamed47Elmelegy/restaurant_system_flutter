import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> register(
    String name,
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthEntity>> refreshToken();
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, void>> saveAuthData(AuthEntity auth);
  Future<Either<Failure, AuthEntity?>> getAuthData();
}
