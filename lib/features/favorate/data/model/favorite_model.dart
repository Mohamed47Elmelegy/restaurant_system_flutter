import '../../domain/Entity/favorite_entity.dart';

class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required super.id,
    required super.userId,
    required super.productId,
    required super.productName,
    super.productImage,
    required super.productPrice,
    super.productDescription,
    required super.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      productImage: json['product_image'],
      productPrice: _parseDouble(json['product_price']),
      productDescription: json['product_description'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  /// Safely parse double values from various data types
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  factory FavoriteModel.fromEntity(FavoriteEntity entity) {
    return FavoriteModel(
      id: entity.id,
      userId: entity.userId,
      productId: entity.productId,
      productName: entity.productName,
      productImage: entity.productImage,
      productPrice: entity.productPrice,
      productDescription: entity.productDescription,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'product_price': productPrice,
      'product_description': productDescription,
      'created_at': createdAt.toIso8601String(),
    };
  }

  FavoriteModel copyWith({
    int? id,
    int? userId,
    int? productId,
    String? productName,
    String? productImage,
    double? productPrice,
    String? productDescription,
    DateTime? createdAt,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      productPrice: productPrice ?? this.productPrice,
      productDescription: productDescription ?? this.productDescription,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
