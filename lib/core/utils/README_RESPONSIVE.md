# Responsive Design Guide

## Overview
This project uses `flutter_screenutil` for responsive design along with a custom `ResponsiveHelper` class that combines ScreenUtil with MediaQuery for better flexibility.

## Setup

### 1. Dependencies
```yaml
dependencies:
  flutter_screenutil: ^5.9.3
```

### 2. Main.dart Configuration
```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

// In MyApp widget
return ScreenUtilInit(
  designSize: const Size(375, 812), // iPhone X design size
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (context, child) {
    return MaterialApp(
      // ... your app configuration
    );
  },
);
```

## Usage

### 1. Basic ScreenUtil Usage
```dart
// Width and Height
width: 100.w
height: 200.h

// Font Size
fontSize: 16.sp

// Radius
borderRadius: BorderRadius.circular(12.r)

// Padding
padding: EdgeInsets.all(16.w)
```

### 2. ResponsiveHelper Usage

#### Adaptive Dimensions
```dart
// Width and Height
width: ResponsiveHelper.getAdaptiveWidth(100)
height: ResponsiveHelper.getAdaptiveHeight(200)

// Font Size
fontSize: ResponsiveHelper.getAdaptiveFontSize(16)

// Radius
borderRadius: BorderRadius.circular(ResponsiveHelper.getAdaptiveRadius(12))
```

#### Adaptive Padding
```dart
// All sides
padding: ResponsiveHelper.getAdaptivePadding(all: 16)

// Specific sides
padding: ResponsiveHelper.getAdaptivePadding(
  left: 16,
  top: 8,
  right: 16,
  bottom: 8,
)

// Symmetric padding
padding: ResponsiveHelper.getAdaptiveSymmetricPadding(
  horizontal: 16,
  vertical: 8,
)
```

#### Adaptive SizedBox
```dart
// Height only
ResponsiveHelper.getAdaptiveSizedBox(height: 16)

// Width only
ResponsiveHelper.getAdaptiveSizedBox(width: 100)

// Both
ResponsiveHelper.getAdaptiveSizedBox(
  width: 100,
  height: 200,
)
```

### 3. MediaQuery Integration

#### Screen Size Detection
```dart
// Check device type
if (ResponsiveHelper.isMobile(context)) {
  // Mobile specific code
}

if (ResponsiveHelper.isTablet(context)) {
  // Tablet specific code
}

if (ResponsiveHelper.isDesktop(context)) {
  // Desktop specific code
}
```

#### Screen Dimensions
```dart
// Get screen dimensions
double screenWidth = ResponsiveHelper.getScreenWidth(context);
double screenHeight = ResponsiveHelper.getScreenHeight(context);

// Get responsive dimensions (percentage based)
double responsiveWidth = ResponsiveHelper.getResponsiveWidth(context, 0.5); // 50% of screen width
double responsiveHeight = ResponsiveHelper.getResponsiveHeight(context, 0.3); // 30% of screen height
```

#### Orientation Detection
```dart
// Check orientation
if (ResponsiveHelper.isLandscape(context)) {
  // Landscape layout
}

if (ResponsiveHelper.isPortrait(context)) {
  // Portrait layout
}
```

#### Safe Area
```dart
// Get status bar height
double statusBarHeight = ResponsiveHelper.getStatusBarHeight(context);

// Get bottom padding (for devices with home indicator)
double bottomPadding = ResponsiveHelper.getBottomPadding(context);

// Get safe area height
double safeAreaHeight = ResponsiveHelper.getSafeAreaHeight(context);
```

### 4. Responsive Values

#### Device-Specific Values
```dart
// Different values for different devices
double responsiveValue = ResponsiveHelper.getResponsiveValue(
  context,
  mobile: 16,
  tablet: 24,
  desktop: 32,
);

// Responsive padding
EdgeInsets responsivePadding = ResponsiveHelper.getResponsivePadding(
  context,
  mobile: EdgeInsets.all(16),
  tablet: EdgeInsets.all(24),
  desktop: EdgeInsets.all(32),
);
```

## Best Practices

### 1. Use ResponsiveHelper for Complex Layouts
```dart
// Good
Container(
  width: ResponsiveHelper.getAdaptiveWidth(160),
  height: ResponsiveHelper.getAdaptiveHeight(220),
  padding: ResponsiveHelper.getAdaptivePadding(all: 12),
  child: Text(
    'Hello',
    style: TextStyle(
      fontSize: ResponsiveHelper.getAdaptiveFontSize(16),
    ),
  ),
)

// Avoid mixing ScreenUtil and ResponsiveHelper
// Bad
Container(
  width: 160.w,
  height: ResponsiveHelper.getAdaptiveHeight(220),
  // ...
)
```

### 2. Use MediaQuery for Device-Specific Logic
```dart
// Good for conditional layouts
Widget build(BuildContext context) {
  if (ResponsiveHelper.isTablet(context)) {
    return _buildTabletLayout();
  } else {
    return _buildMobileLayout();
  }
}
```

### 3. Combine with Theme Colors
```dart
// Always use theme-aware colors with responsive dimensions
Container(
  width: ResponsiveHelper.getAdaptiveWidth(100),
  decoration: BoxDecoration(
    color: isDark ? AppColors.darkSurface : Colors.white,
    borderRadius: BorderRadius.circular(ResponsiveHelper.getAdaptiveRadius(12)),
  ),
)
```

## Example Implementation

```dart
class ResponsiveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: ResponsiveHelper.getAdaptiveWidth(160),
      height: ResponsiveHelper.getAdaptiveHeight(200),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveHelper.getAdaptiveRadius(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: ResponsiveHelper.getAdaptivePadding(all: 16),
        child: Column(
          children: [
            Text(
              'Title',
              style: TextStyle(
                fontSize: ResponsiveHelper.getAdaptiveFontSize(18),
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextMain,
              ),
            ),
            ResponsiveHelper.getAdaptiveSizedBox(height: 8),
            Text(
              'Description',
              style: TextStyle(
                fontSize: ResponsiveHelper.getAdaptiveFontSize(14),
                color: isDark ? AppColors.darkTextSecondary : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Migration from Fixed Values

### Before
```dart
Container(
  width: 160,
  height: 200,
  padding: EdgeInsets.all(16),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 16),
  ),
)
```

### After
```dart
Container(
  width: ResponsiveHelper.getAdaptiveWidth(160),
  height: ResponsiveHelper.getAdaptiveHeight(200),
  padding: ResponsiveHelper.getAdaptivePadding(all: 16),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: ResponsiveHelper.getAdaptiveFontSize(16)),
  ),
)
```

This approach ensures your app looks great on all screen sizes and orientations! 