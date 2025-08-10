import 'package:equatable/equatable.dart';

/// �� Address Entity - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل عنوان المستخدم فقط
class AddressEntity extends Equatable {
  final int id;
  final int userId;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String? phone;
  final bool isDefault;
  final String? label;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AddressEntity({
    required this.id,
    required this.userId,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.phone,
    this.isDefault = false,
    this.label,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get full address as formatted string
  String get fullAddress {
    final parts = [addressLine1];
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      parts.add(addressLine2!);
    }
    parts.addAll([city, state, postalCode, country]);
    return parts.where((part) => part.isNotEmpty).join(', ');
  }

  /// Check if address is complete
  bool get isComplete => 
    addressLine1.isNotEmpty && 
    city.isNotEmpty && 
    state.isNotEmpty && 
    postalCode.isNotEmpty && 
    country.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    userId,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
    phone,
    isDefault,
    label,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'AddressEntity(id: $id, userId: $userId, city: $city, state: $state)';
  }
}