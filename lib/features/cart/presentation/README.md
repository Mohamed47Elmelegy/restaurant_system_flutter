# Cart Presentation Layer - UI Components 🎨

This directory contains the presentation layer UI components for the cart feature, designed to match the modern dark UI shown in the provided image.

## Structure

```
lib/features/cart/presentation/
├── pages/
│   ├── cart_page.dart          # Main cart page with items list
│   ├── checkout_page.dart      # Optional checkout page
│   └── index.dart              # Exports for pages
├── widgets/
│   ├── cart_item_widget.dart   # Individual cart item display
│   ├── cart_summary_widget.dart # Order total and place order button
│   ├── empty_cart_widget.dart  # Empty state display
│   ├── cart_app_bar.dart       # Custom app bar with item count
│   ├── add_to_cart_button.dart # Reusable add to cart button
│   └── index.dart              # Exports for widgets
└── bloc/                       # Already existing state management
```

## UI Components Overview

### 🛒 CartPage
The main cart page featuring:
- Dark theme matching the design (background: `#2A2A3A`)
- Custom app bar with total items count
- Scrollable list of cart items
- Bottom summary section with delivery address and total
- Empty state handling

### 📱 Widgets

#### CartAppBar
- Custom app bar with back navigation
- Shows "Cart" title
- Displays total items count badge in orange
- Responsive design

#### CartItemWidget
- Product image placeholder (dark grey container)
- Product name and price display
- Quantity controls with +/- buttons
- Remove item button (red circle with X)
- Matches the design layout from the image

#### CartSummaryWidget
- Delivery address section with edit option
- Order breakdown dialog (subtotal, tax, delivery fee)
- Large total display
- Orange "PLACE ORDER" button
- Navigates to checkout page

#### EmptyCartWidget
- Centered empty state design
- Shopping cart icon in dark container
- Friendly message text
- "Start Shopping" button to return

#### AddToCartButton
- Animated button with loading states
- Success/error feedback via SnackBar
- Disabled state for unavailable items
- Two variants: full button and quick add icon

## Color Scheme

The UI uses the app's color scheme:
- Background: `#2A2A3A` (dark blue-grey)
- Cards: `#3A3A4A` (slightly lighter)
- Primary: Orange (`AppColors.lightPrimary`)
- Text: White and grey variations
- Error: Red for remove buttons

## Features

### ✅ Implemented
- [x] Modern dark UI design
- [x] Quantity increment/decrement
- [x] Item removal
- [x] Total calculation
- [x] Empty state handling
- [x] Loading states
- [x] Error handling
- [x] Navigation to checkout
- [x] Responsive design
- [x] Accessibility considerations

## Integration Status

### ✅ COMPLETED - Ready to Use

✅ **Cart UI Components**: All cart widgets matching the design are implemented  
✅ **Navigation Setup**: Cart button in home app bar navigates to cart page  
✅ **State Management**: BlocBuilder integration for real-time cart count  
✅ **Auto-loading**: Cart data loads automatically when app starts  
✅ **Error Handling**: Proper error states and loading indicators  

### 🎯 How to Use

1. **Add Products to Cart**: Use `AddToCartButton` widget anywhere in the app
2. **View Cart**: Click the cart button in the home app bar
3. **Manage Items**: Use quantity controls and remove buttons in cart
4. **Checkout**: Click "PLACE ORDER" to navigate to checkout page

### 🔗 Integration Points

- **HomePage**: Provides CartCubit via MultiBlocProvider
- **HomeCustomAppBar**: Shows real-time cart count from CartCubit state
- **CartButton**: Navigates to CartPage when pressed
- **Service Locator**: CartCubit registered as factory for DI

The cart feature is now fully integrated and ready to use! 🚀

## Usage Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/cart/presentation/bloc/cart_cubit.dart';

// Navigate to cart page
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => BlocProvider.value(
      value: context.read<CartCubit>(),
      child: const CartPage(),
    ),
  ),
);
```

## Notes

1. **State Management**: Uses the existing BLoC pattern with CartCubit
2. **Design Fidelity**: Matches the provided dark UI design
3. **Scalability**: Components are modular and reusable
4. **Performance**: Optimized with proper widget rebuilds
5. **Accessibility**: Includes semantic labels and proper contrast

The implementation follows Flutter best practices and integrates seamlessly with the existing cart domain and data layers.
