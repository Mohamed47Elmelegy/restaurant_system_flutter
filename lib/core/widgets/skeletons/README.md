# Custom Skeleton Loaders for Restaurant System

This directory contains custom skeleton loading widgets designed specifically for the restaurant system app. These skeletons provide smooth loading animations that match the actual UI structure of each page.

## Overview

The skeleton loaders are built using the `skeletonizer: ^2.1.0+1` package and provide realistic loading states for:

- **Home Page** - Categories, popular items, recommended items
- **Category Items** - Grid view of food items 
- **Orders** - Order lists with tabs
- **Address** - Address list and forms

## Features

- ✅ **Responsive Design** - Uses `flutter_screenutil` for consistent sizing
- ✅ **Theme-Aware** - Adapts to light/dark themes automatically
- ✅ **Performance Optimized** - Efficient rendering with minimal overhead
- ✅ **Realistic Structure** - Mirrors actual UI components
- ✅ **Smooth Animations** - Shimmer effects with proper timing

## Available Skeleton Widgets

### 1. HomePageSkeleton

**Usage:**
```dart
const SkeletonWrapper(
  enabled: true,
  child: HomePageSkeleton(),
)
```

**Features:**
- App bar with profile and notifications
- Address selection section
- Horizontal categories list
- Popular items horizontal scroll
- Recommended items grid

### 2. CategoryItemsSkeleton

**Usage:**
```dart
const SkeletonWrapper(
  enabled: true,
  child: CategoryItemsSkeleton(),
)
```

**Features:**
- Grid layout matching food item cards
- Image placeholders with proper aspect ratio
- Text placeholders for name, category, price
- Add button placeholder

### 3. OrdersSkeleton

**Usage:**
```dart
SkeletonWrapper(
  enabled: true,
  child: OrdersSkeleton(tabController: _tabController),
)
```

**Features:**
- Tab bar skeleton (optional)
- Order card skeletons with realistic structure
- Order items with images and details
- Action buttons and status indicators

### 4. AddressSkeleton

**Usage:**
```dart
const SkeletonWrapper(
  enabled: true,
  child: AddressSkeleton(),
)
```

**Features:**
- Address card skeletons with titles and descriptions
- Default badge placeholders
- Action buttons (edit, delete, set default)
- Add new address button

### 5. AddressFormSkeleton

**Usage:**
```dart
const SkeletonWrapper(
  enabled: true,
  child: AddressFormSkeleton(),
)
```

**Features:**
- Form field placeholders
- Label and input combinations
- Checkbox skeleton
- Save button placeholder

### 6. OrderDetailsSkeleton

**Usage:**
```dart
const SkeletonWrapper(
  enabled: true,
  child: OrderDetailsSkeleton(),
)
```

**Features:**
- Order header with status
- Detailed item list with images
- Order summary breakdown
- Delivery information section

## Implementation Guide

### Step 1: Import the Skeletons

```dart
import '../../../../core/widgets/skeleton_wrapper.dart';
import '../../../../core/widgets/skeletons/skeletons.dart';
```

### Step 2: Replace Loading States

**Before:**
```dart
if (state is Loading) {
  return const Center(child: CircularProgressIndicator());
}
```

**After:**
```dart
if (state is Loading) {
  return const SkeletonWrapper(
    enabled: true,
    child: HomePageSkeleton(), // Choose appropriate skeleton
  );
}
```

### Step 3: Using with CommonStateBuilder

```dart
CommonStateBuilder<YourBloc, YourState>(
  isLoading: (state) => state is YourLoadingState,
  loadingBuilder: (context) => const SkeletonWrapper(
    enabled: true,
    child: YourPageSkeleton(),
  ),
  builder: (context, state) => YourActualContent(),
)
```

## Customization

### Colors and Theme

The skeletons automatically adapt to your app's theme through:
- `ThemeHelper.getCardBackgroundColor(context)`
- `ThemeHelper.getCardShadow(context)`
- `Colors.grey[300]` for light mode placeholders
- `Colors.grey[800]` for dark mode placeholders (via SkeletonWrapper)

### Timing and Animation

Skeleton animations are controlled by the `SkeletonWrapper`:
- **Duration:** 1500ms
- **Effect:** ShimmerEffect
- **Switch Animation:** Enabled for smooth transitions

### Adding New Skeletons

1. Create a new skeleton widget in this directory
2. Follow the naming convention: `[PageName]Skeleton`
3. Use consistent spacing with `flutter_screenutil`
4. Add theme support via `ThemeHelper`
5. Export in `skeletons.dart`

Example:
```dart
class NewPageSkeleton extends StatelessWidget {
  const NewPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        // More skeleton elements...
      ],
    );
  }
}
```

## Best Practices

1. **Match Real UI Structure** - Ensure skeletons closely match the actual content layout
2. **Use Proper Aspect Ratios** - Maintain the same proportions as real content
3. **Consistent Spacing** - Use the same padding and margins as actual widgets
4. **Performance** - Keep skeletons lightweight and efficient
5. **Theme Compatibility** - Always test in both light and dark themes

## Performance Notes

- Skeletons are stateless widgets for maximum performance
- Use `const` constructors wherever possible
- Avoid complex animations or heavy computations
- Consider using `ListView.builder` for long lists

## Testing

To test skeletons:

1. **Visual Testing** - Compare with actual UI layouts
2. **Theme Testing** - Verify appearance in light/dark modes
3. **Performance Testing** - Ensure smooth animations
4. **Accessibility** - Check screen reader compatibility

## Files Structure

```
skeletons/
├── README.md                 # This documentation
├── skeletons.dart           # Barrel export file
├── home_page_skeleton.dart   # Home page loading skeleton
├── category_items_skeleton.dart # Category items grid skeleton
├── orders_skeleton.dart     # Orders list and details skeletons
└── address_skeleton.dart    # Address list and form skeletons
```

## Integration Status

✅ **Home Page** - Integrated with `HomeViewBodyBuilder`  
✅ **Category Items** - Integrated with `CategoryItemsPage`  
✅ **Orders** - Integrated with `MyOrdersTabPage`  
✅ **Address** - Integrated with `AddressPage`  

The skeleton loaders are now fully integrated and will automatically display during loading states, providing a much better user experience compared to simple loading spinners.
