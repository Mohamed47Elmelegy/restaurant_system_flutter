import 'package:equatable/equatable.dart';

/// 🟩 Table Entity - Domain Layer
class TableEntity extends Equatable {
  final int id;
  final String number;
  final String name;
  final int capacity;
  final bool isAvailable;
  final String qrCode;
  final String? location;

  const TableEntity({
    required this.id,
    required this.number,
    required this.name,
    required this.capacity,
    required this.isAvailable,
    required this.qrCode,
    this.location,
  });

  /// Check if table is occupied
  bool get isOccupied => !isAvailable;

  @override
  List<Object?> get props => [
    id,
    number,
    name,
    capacity,
    isAvailable,
    qrCode,
    location,
  ];
}
