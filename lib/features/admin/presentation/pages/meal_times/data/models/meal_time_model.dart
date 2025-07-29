import 'package:flutter/material.dart';

import '../../domain/entities/meal_time.dart';

class MealTimeModel extends MealTime {
  const MealTimeModel({
    required super.id,
    required super.name,
    required super.nameAr,
    required super.startTime,
    required super.endTime,
    super.isActive,
    super.categoryIds,
    super.sortOrder,
  });

  factory MealTimeModel.fromJson(Map<String, dynamic> json) {
    return MealTimeModel(
      id: json['id'].toString(), // Convert to string since API returns int
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      startTime: _parseTimeString(json['start_time'] as String),
      endTime: _parseTimeString(json['end_time'] as String),
      isActive: json['is_active'] as bool? ?? true,
      categoryIds:
          (json['category_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'start_time': _formatTimeOfDay(startTime),
      'end_time': _formatTimeOfDay(endTime),
      'is_active': isActive,
      'category_ids': categoryIds,
      'sort_order': sortOrder,
    };
  }

  static TimeOfDay _parseTimeString(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  factory MealTimeModel.fromEntity(MealTime entity) {
    return MealTimeModel(
      id: entity.id,
      name: entity.name,
      nameAr: entity.nameAr,
      startTime: entity.startTime,
      endTime: entity.endTime,
      isActive: entity.isActive,
      categoryIds: entity.categoryIds,
      sortOrder: entity.sortOrder,
    );
  }

  MealTimeModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool? isActive,
    List<String>? categoryIds,
    int? sortOrder,
  }) {
    return MealTimeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isActive: isActive ?? this.isActive,
      categoryIds: categoryIds ?? this.categoryIds,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
