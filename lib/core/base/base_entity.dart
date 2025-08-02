import 'package:equatable/equatable.dart';

/// 🟦 BaseEntity - مبدأ المسؤولية الواحدة (SRP)
/// كل entity مسؤول عن تمثيل كيان الأعمال فقط
///
/// 🟦 مبدأ الفتح والإغلاق (OCP)
/// يمكن إضافة entities جديدة بدون تعديل BaseEntity
abstract class BaseEntity extends Equatable {
  /// معرف الكيان
  final String id;

  /// تاريخ الإنشاء
  final DateTime? createdAt;

  /// تاريخ التحديث
  final DateTime? updatedAt;

  const BaseEntity({required this.id, this.createdAt, this.updatedAt});

  /// نسخ Entity مع تعديلات
  BaseEntity copyWith({String? id, DateTime? createdAt, DateTime? updatedAt});

  /// تحويل Entity إلى Map
  Map<String, dynamic> toMap();

  /// التحقق من صحة البيانات
  bool get isValid;

  /// الحصول على عمر الكيان بالأيام
  int get ageInDays {
    if (createdAt == null) return 0;
    return DateTime.now().difference(createdAt!).inDays;
  }

  /// التحقق من أن الكيان تم إنشاؤه اليوم
  bool get isCreatedToday {
    if (createdAt == null) return false;
    final now = DateTime.now();
    final created = createdAt!;
    return now.year == created.year &&
        now.month == created.month &&
        now.day == created.day;
  }

  @override
  List<Object?> get props => [id, createdAt, updatedAt];

  @override
  String toString() {
    return 'BaseEntity(id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
