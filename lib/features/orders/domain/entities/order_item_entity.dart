import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final String? productImage;
  final double totalPrice;

  const OrderItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.productImage,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    quantity,
    price,
    productImage,
    totalPrice,
  ];

  @override
  String toString() {
    return 'OrderItemEntity(id: $id, productName: $productName, quantity: $quantity, totalPrice: $totalPrice)';
  }
}