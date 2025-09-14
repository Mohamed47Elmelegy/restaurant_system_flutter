import 'package:equatable/equatable.dart';

/// 🟦 Favorite Entity - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل منتج مفضل للمستخدم فقط
class FavoriteEntity extends Equatable {
  final int id;
  final int userId;
  final int productId;
  final String productName;
  final String? productImage;
  final double productPrice;
  final String? productDescription;
  final DateTime createdAt;

  const FavoriteEntity({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.productPrice,
    this.productDescription,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    productId,
    productName,
    productImage,
    productPrice,
    productDescription,
    createdAt,
  ];

  @override
  String toString() {
    return 'FavoriteEntity(id: $id, userId: $userId, productId: $productId, productName: $productName)';
  }
}
