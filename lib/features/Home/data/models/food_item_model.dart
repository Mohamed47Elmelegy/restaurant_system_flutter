class FoodItemModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final String image;
  final String category;

  FoodItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.image,
    required this.category,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: _parseDouble(json['price']),
      rating: _parseDouble(json['rating']),
      image: json['image'] as String,
      category: json['category'] as String,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'rating': rating,
      'image': image,
      'category': category,
    };
  }
}
