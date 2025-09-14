import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🟦 BaseState - مبدأ المسؤولية الواحدة (SRP)
/// كل state مسؤول عن تمثيل حالة واحدة فقط
abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

/// 🟦 BaseEvent - مبدأ المسؤولية الواحدة (SRP)
/// كل event مسؤول عن حدث واحد فقط
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}

/// 🟦 BaseCubit - مبدأ المسؤولية الواحدة (SRP)
/// كل cubit مسؤول عن إدارة حالة feature واحد فقط
///
/// 🟦 مبدأ الفتح والإغلاق (OCP)
/// يمكن إضافة cubits جديدة بدون تعديل BaseCubit
///
/// 🟦 مبدأ قلب الاعتماديات (DIP)
/// يعتمد على abstraction وليس implementation
abstract class BaseCubit<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  BaseCubit(super.initialState);

  /// إرسال event
  void emitEvent(Event event) {
    add(event);
  }

  /// إرسال state
  void emitState(State state) {
    add(state as Event);
  }

  /// إرسال error state
  void emitError(String message) {
    // يجب على كل cubit أن يحدد كيف يتعامل مع الأخطاء
    throw UnimplementedError('emitError must be implemented by subclass');
  }

  /// إرسال loading state
  void emitLoading() {
    // يجب على كل cubit أن يحدد كيف يتعامل مع loading
    throw UnimplementedError('emitLoading must be implemented by subclass');
  }

  /// إرسال success state
  void emitSuccess() {
    // يجب على كل cubit أن يحدد كيف يتعامل مع success
    throw UnimplementedError('emitSuccess must be implemented by subclass');
  }

  /// التحقق من أن Cubit في حالة loading
  bool get isLoading => state.toString().contains('Loading');

  /// التحقق من أن Cubit في حالة error
  bool get isError => state.toString().contains('Error');

  /// التحقق من أن Cubit في حالة success
  bool get isSuccess => state.toString().contains('Success');

  /// الحصول على رسالة الخطأ من State
  String? get errorMessage {
    // يجب على كل cubit أن يحدد كيف يحصل على رسالة الخطأ
    return null;
  }

  /// إعادة تعيين State إلى الحالة الأولية
  void reset() {
    // يجب على كل cubit أن يحدد كيف يعيد تعيين الحالة
    throw UnimplementedError('reset must be implemented by subclass');
  }
}
