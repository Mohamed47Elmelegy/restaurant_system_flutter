import 'package:equatable/equatable.dart';

/// 🟩 CheckoutStep Entity - Domain Layer
/// Represents a single step in the checkout process
class CheckoutStepEntity extends Equatable {
  final CheckoutStepType type;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isActive;
  final bool isEnabled;
  final Map<String, dynamic>? data;

  const CheckoutStepEntity({
    required this.type,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.isActive = false,
    this.isEnabled = true,
    this.data,
  });

  /// Create a copy with updated properties
  CheckoutStepEntity copyWith({
    CheckoutStepType? type,
    String? title,
    String? description,
    bool? isCompleted,
    bool? isActive,
    bool? isEnabled,
    Map<String, dynamic>? data,
  }) {
    return CheckoutStepEntity(
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive ?? this.isActive,
      isEnabled: isEnabled ?? this.isEnabled,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
    type,
    title,
    description,
    isCompleted,
    isActive,
    isEnabled,
    data,
  ];
}

/// Checkout Step Types
enum CheckoutStepType {
  orderType,
  addressSelection,
  tableSelection,
  orderReview,
  paymentMethod,
  confirmation,
}

/// Extension for CheckoutStepType utilities
extension CheckoutStepTypeExtension on CheckoutStepType {
  String get title {
    switch (this) {
      case CheckoutStepType.orderType:
        return 'نوع الطلب';
      case CheckoutStepType.addressSelection:
        return 'عنوان التوصيل';
      case CheckoutStepType.tableSelection:
        return 'اختيار الطاولة';
      case CheckoutStepType.orderReview:
        return 'مراجعة الطلب';
      case CheckoutStepType.paymentMethod:
        return 'طريقة الدفع';
      case CheckoutStepType.confirmation:
        return 'تأكيد الطلب';
    }
  }

  String get description {
    switch (this) {
      case CheckoutStepType.orderType:
        return 'اختر نوع الطلب - توصيل أو داخل المطعم';
      case CheckoutStepType.addressSelection:
        return 'اختر عنوان التوصيل';
      case CheckoutStepType.tableSelection:
        return 'امسح رمز QR للطاولة أو اختر الطاولة';
      case CheckoutStepType.orderReview:
        return 'راجع طلبك وأضف ملاحظات إضافية';
      case CheckoutStepType.paymentMethod:
        return 'اختر طريقة الدفع المفضلة';
      case CheckoutStepType.confirmation:
        return 'راجع جميع التفاصيل قبل تأكيد الطلب';
    }
  }

  int get stepNumber {
    return index + 1;
  }
}
