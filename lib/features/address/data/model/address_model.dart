import '../../domain/entitiy/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.city,
    required super.phoneNumber,
    required super.address,
    super.building,
    super.apartment,
    super.isDefault = false,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      address: json['address'] ?? '',
      building: json['building'],
      apartment: json['apartment'],
      isDefault: json['is_default'] ?? false,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      city: entity.city,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      building: entity.building,
      apartment: entity.apartment,
      isDefault: entity.isDefault,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'city': city,
      'phone_number': phoneNumber,
      'address': address,
      'building': building,
      'apartment': apartment,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AddressModel copyWith({
    int? id,
    int? userId,
    String? name,
    String? city,
    String? phoneNumber,
    String? address,
    String? building,
    String? apartment,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      city: city ?? this.city,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      building: building ?? this.building,
      apartment: apartment ?? this.apartment,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
