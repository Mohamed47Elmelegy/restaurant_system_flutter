import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// 🟦 BaseUseCase - مبدأ المسؤولية الواحدة (SRP)
/// كل use case مسؤول عن منطق أعمال واحد فقط
///
/// 🟦 مبدأ الفتح والإغلاق (OCP)
/// يمكن إضافة use cases جديدة بدون تعديل BaseUseCase
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstraction وليس implementation
abstract class BaseUseCase<Type, Params> {
  /// تنفيذ Use Case
  Future<Either<Failure, Type>> call(Params params);
}

/// 🟦 NoParams - للـ Use Cases التي لا تحتاج parameters
class NoParams {
  const NoParams();
}

/// 🟦 BaseUseCase بدون parameters
abstract class BaseUseCaseNoParams<Type> {
  /// تنفيذ Use Case
  Future<Either<Failure, Type>> call();
}

/// 🟦 BaseUseCase مع parameters متعددة
abstract class BaseUseCaseMultiParams<Type, Params1, Params2> {
  /// تنفيذ Use Case
  Future<Either<Failure, Type>> call(Params1 params1, Params2 params2);
}

/// 🟦 BaseUseCase للعمليات التي لا تعيد قيمة
abstract class BaseUseCaseVoid<Params> {
  /// تنفيذ Use Case
  Future<Either<Failure, void>> call(Params params);
}

/// 🟦 BaseUseCase للعمليات التي لا تعيد قيمة ولا تحتاج parameters
abstract class BaseUseCaseVoidNoParams {
  /// تنفيذ Use Case
  Future<Either<Failure, void>> call();
}
