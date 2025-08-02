/// 🟦 BaseModel - مبدأ المسؤولية الواحدة (SRP)
/// كل model مسؤول عن تحويل البيانات فقط
///
/// 🟦 مبدأ الفتح والإغلاق (OCP)
/// يمكن إضافة models جديدة بدون تعديل BaseModel
abstract class BaseModel<T> {
  /// تحويل Model إلى JSON
  Map<String, dynamic> toJson();

  /// تحويل Model إلى Entity
  T toEntity();

  /// نسخ Model مع تعديلات
  BaseModel<T> copyWith(Map<String, dynamic> changes);

  /// مقارنة Models
  @override
  bool operator ==(Object other);

  /// Hash code للـ Model
  @override
  int get hashCode;

  /// String representation
  @override
  String toString();
}
