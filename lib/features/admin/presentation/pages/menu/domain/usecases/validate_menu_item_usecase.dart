import '../entities/menu_item.dart';

/// Use case for validating menu item data
class ValidateMenuItemUseCase {
  /// Validate menu item data
  bool isValid(MenuItem item) {
    return item.id.isNotEmpty &&
        item.name.isNotEmpty &&
        item.category.isNotEmpty &&
        item.price.isNotEmpty &&
        item.rating >= 0 &&
        item.rating <= 5 &&
        item.reviewCount >= 0;
  }

  /// Validate menu item with detailed error messages
  Map<String, String> validateWithErrors(MenuItem item) {
    final errors = <String, String>{};

    if (item.id.isEmpty) {
      errors['id'] = 'ID is required';
    }

    if (item.name.isEmpty) {
      errors['name'] = 'Name is required';
    }

    if (item.category.isEmpty) {
      errors['category'] = 'Category is required';
    }

    if (item.price.isEmpty) {
      errors['price'] = 'Price is required';
    }

    if (item.rating < 0 || item.rating > 5) {
      errors['rating'] = 'Rating must be between 0 and 5';
    }

    if (item.reviewCount < 0) {
      errors['reviewCount'] = 'Review count must be positive';
    }

    return errors;
  }

  /// Check if menu item can be saved
  bool canBeSaved(MenuItem item) {
    return isValid(item);
  }
}
