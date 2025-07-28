class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.imagePath,
    this.description,
    this.isAvailable = true,
  });

  final String category;
  final String? description;
  final String id;
  final String imagePath;
  final bool isAvailable;
  final String name;
  final String price;
  final double rating;
  final int reviewCount;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MenuItem(id: $id, name: $name, category: $category, price: $price)';
  }

  MenuItem copyWith({
    String? id,
    String? name,
    String? category,
    double? rating,
    int? reviewCount,
    String? price,
    String? imagePath,
    String? description,
    bool? isAvailable,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
