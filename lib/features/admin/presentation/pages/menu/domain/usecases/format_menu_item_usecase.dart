import '../entities/menu_item.dart';

/// Use case for formatting menu item data for display
class FormatMenuItemUseCase {
  /// Format price with dollar sign
  String formatPrice(String price) {
    return '\$$price';
  }

  /// Format rating with review count
  String formatRating(double rating, int reviewCount) {
    return '$rating ($reviewCount Review)';
  }

  /// Get display name for category
  String getCategoryDisplayName(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      default:
        return category;
    }
  }

  /// Format menu item for display
  Map<String, String> formatMenuItemForDisplay(MenuItem item) {
    return {
      'formattedPrice': formatPrice(item.price),
      'ratingText': formatRating(item.rating, item.reviewCount),
      'categoryDisplayName': getCategoryDisplayName(item.category),
    };
  }
}
