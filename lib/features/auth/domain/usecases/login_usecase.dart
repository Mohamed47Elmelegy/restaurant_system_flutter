import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<AuthEntity, LoginParams> {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
