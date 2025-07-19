import 'package:equatable/equatable.dart';
import 'user_entity.dart';

class AuthEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserEntity user;
  final DateTime expiresAt;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, user, expiresAt];
}
