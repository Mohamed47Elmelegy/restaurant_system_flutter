class FoodItemEntity {
  final int id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final String image;
  final String category;

  FoodItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.image,
    required this.category,
  });
}
