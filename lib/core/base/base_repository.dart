import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// 🟦 BaseRepository - مبدأ المسؤولية الواحدة (SRP)
/// كل repository مسؤول عن نوع بيانات واحد فقط
///
/// 🟦 مبدأ الفتح والإغلاق (OCP)
/// مفتوح للتوسيع، مغلق للتعديل
///
/// 🟦 مبدأ الاستبدال (LSP)
/// أي repository يمكن أن يحل محل BaseRepository
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstraction وليس implementation
abstract class BaseRepository<T> {
  /// جلب جميع العناصر
  Future<Either<Failure, List<T>>> getAll();

  /// جلب عنصر بواسطة المعرف
  Future<Either<Failure, T?>> getById(String id);

  /// إضافة عنصر جديد
  Future<Either<Failure, T>> add(T item);

  /// تحديث عنصر موجود
  Future<Either<Failure, T>> update(String id, T item);

  /// حذف عنصر
  Future<Either<Failure, bool>> delete(String id);

  /// البحث في العناصر
  Future<Either<Failure, List<T>>> search(String query);

  /// جلب العناصر مع pagination
  Future<Either<Failure, List<T>>> getPaginated({
    int page = 1,
    int limit = 10,
    String? sortBy,
    bool ascending = true,
  });
}
