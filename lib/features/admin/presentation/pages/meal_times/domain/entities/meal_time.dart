import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MealTime extends Equatable {
  final String id;
  final String name;
  final String nameAr;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool isActive;
  final List<String> categoryIds;
  final int sortOrder;

  const MealTime({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.startTime,
    required this.endTime,
    this.isActive = true,
    this.categoryIds = const [],
    this.sortOrder = 0,
  });

  /// Get display name based on current locale
  String getDisplayName({bool isArabic = true}) {
    return isArabic ? nameAr : name;
  }

  /// Check if this meal time is currently active based on time
  bool isCurrentMealTime() {
    final now = TimeOfDay.now();
    return _isTimeInRange(now, startTime, endTime);
  }

  /// Check if meal time is available for current time
  bool isAvailableNow() {
    return isActive && isCurrentMealTime();
  }

  /// Get icon based on meal time name
  String getIcon() {
    switch (name.toLowerCase()) {
      case 'breakfast':
        return '🌅';
      case 'lunch':
        return '🍽️';
      case 'dinner':
        return '🌙';
      case 'all_day':
        return '⭕';
      default:
        return '🍴';
    }
  }

  /// Check if time is in range (handles overnight times)
  bool _isTimeInRange(TimeOfDay current, TimeOfDay start, TimeOfDay end) {
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    if (startMinutes <= endMinutes) {
      // Normal time range (e.g., 08:00 - 12:00)
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } else {
      // Overnight time range (e.g., 22:00 - 06:00)
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    nameAr,
    startTime,
    endTime,
    isActive,
    categoryIds,
    sortOrder,
  ];

  @override
  String toString() {
    return 'MealTime(id: $id, name: $name, nameAr: $nameAr, isActive: $isActive)';
  }
}
