import '../../domain/entities/auth_entity.dart';
import 'user_model.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.accessToken,
    required super.refreshToken,
    required super.user,
    required super.expiresAt,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      expiresAt: DateTime.parse(
        json['expires_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': (user as UserModel).toJson(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  AuthModel copyWith({
    String? accessToken,
    String? refreshToken,
    UserModel? user,
    DateTime? expiresAt,
  }) {
    return AuthModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user as UserModel,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
