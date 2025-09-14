import 'package:equatable/equatable.dart';

/// Address Entity - Single Responsibility Principle (SRP)
/// Responsible for representing user address only
class AddressEntity extends Equatable {
  final int id;
  final int userId;
  final String name; // user's full name
  final String city; // city
  final String phoneNumber; // phone number
  final String address; // street address / full details
  final String? building; // building number/name
  final String? apartment; // apartment number
  final bool isDefault; // is default address
  final DateTime createdAt;
  final DateTime updatedAt;

  const AddressEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.city,
    required this.phoneNumber,
    required this.address,
    this.building,
    this.apartment,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get full address as formatted string
  String get fullAddress {
    final parts = [address];
    if (building != null && building!.isNotEmpty) {
      parts.add('Building: $building');
    }
    if (apartment != null && apartment!.isNotEmpty) {
      parts.add('Apartment: $apartment');
    }
    parts.add(city);
    return parts.where((part) => part.isNotEmpty).join(', ');
  }

  /// Check if address is complete
  bool get isComplete =>
      name.isNotEmpty &&
      city.isNotEmpty &&
      phoneNumber.isNotEmpty &&
      address.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    city,
    phoneNumber,
    address,
    building,
    apartment,
    isDefault,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'AddressEntity(id: $id, userId: $userId, name: $name, city: $city)';
  }
}
