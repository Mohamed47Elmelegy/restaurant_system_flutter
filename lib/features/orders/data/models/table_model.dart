// lib/features/order/data/models/table_model.dart
import '../../domain/entities/table_entity.dart';

/// 🟨 Table Model - Data Layer
class TableModel extends TableEntity {
  const TableModel({
    required super.id,
    required super.number,
    required super.name,
    required super.capacity,
    required super.isAvailable,
    required super.qrCode,
    super.location,
  });

  /// Factory constructor from JSON
  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] as int,
      number: json['number'] as String,
      name: json['name'] as String,
      capacity: json['capacity'] as int,
      isAvailable: json['is_available'] as bool,
      qrCode: json['qr_code'] as String,
      location: json['location'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'name': name,
      'capacity': capacity,
      'is_available': isAvailable,
      'qr_code': qrCode,
      if (location != null) 'location': location,
    };
  }

  /// Create a copy with updated fields
  TableModel copyWith({
    int? id,
    String? number,
    String? name,
    int? capacity,
    bool? isAvailable,
    String? qrCode,
    String? location,
  }) {
    return TableModel(
      id: id ?? this.id,
      number: number ?? this.number,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      isAvailable: isAvailable ?? this.isAvailable,
      qrCode: qrCode ?? this.qrCode,
      location: location ?? this.location,
    );
  }

  /// Convert from entity to model
  factory TableModel.fromEntity(TableEntity entity) {
    return TableModel(
      id: entity.id,
      number: entity.number,
      name: entity.name,
      capacity: entity.capacity,
      isAvailable: entity.isAvailable,
      qrCode: entity.qrCode,
      location: entity.location,
    );
  }
}
