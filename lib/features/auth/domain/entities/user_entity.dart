import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String name;
  final String? phone;
  final String? avatar;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.avatar,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    phone,
    avatar,
    role,
    createdAt,
    updatedAt,
  ];
}
