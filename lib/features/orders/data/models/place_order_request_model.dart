// lib/features/order/data/models/place_order_request_model.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

/// 🟨 Place Order Request Model
class PlaceOrderRequestModel extends Equatable {
  final OrderType type;
  final int? tableId;
  final String? deliveryAddress;
  final String? specialInstructions;
  final String? notes;

  const PlaceOrderRequestModel({
    required this.type,
    this.tableId,
    this.deliveryAddress,
    this.specialInstructions,
    this.notes,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'type': _orderTypeToString(type)};

    if (tableId != null) {
      json['table_id'] = tableId;
    }

    if (deliveryAddress != null) {
      json['delivery_address'] = deliveryAddress;
    }

    if (specialInstructions != null) {
      json['special_instructions'] = specialInstructions;
    }

    if (notes != null) {
      json['notes'] = notes;
    }

    return json;
  }

  /// Validate dine-in order requirements
  bool get isValidDineInOrder => type == OrderType.dineIn && tableId != null;

  /// Validate delivery order requirements
  bool get isValidDeliveryOrder =>
      type == OrderType.delivery &&
      deliveryAddress != null &&
      deliveryAddress!.isNotEmpty;

  /// Check if order request is valid
  bool get isValid => isValidDineInOrder || isValidDeliveryOrder;

  static String _orderTypeToString(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return 'dine_in';
      case OrderType.delivery:
        return 'delivery';
    }
  }

  @override
  List<Object?> get props => [
    type,
    tableId,
    deliveryAddress,
    specialInstructions,
    notes,
  ];
}
