import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final int id;
  final String name;
  final String category;
  final double price;
  final String? image;
  final String status;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.image,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    price,
    image,
    status,
    createdAt,
  ];
}
