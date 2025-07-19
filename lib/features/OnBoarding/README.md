# Onboarding Feature

This feature provides an onboarding experience for new users of the restaurant app.

## Structure

```
OnBoarding/
├── data/
│   ├── models/
│   │   └── onboarding_model.dart
│   └── datasources/
│       └── onboarding_data.dart
├── presentation/
│   ├── bloc/
│   │   ├── onboarding_bloc.dart
│   │   ├── onboarding_event.dart
│   │   └── onboarding_state.dart
│   ├── pages/
│   │   └── onboarding_page.dart
│   └── widgets/
│       ├── onboarding_indicator.dart
│       ├── onboarding_screen_widget.dart
│       ├── onboarding_navigation_widget.dart
│       └── onboarding_skip_button.dart
└── index.dart
```

## Features

- **Multiple Screens**: 3 onboarding screens with different content
- **Smooth Animations**: Page transitions and indicator animations
- **Navigation**: Previous/Next buttons and Skip functionality
- **Custom Indicators**: Animated dots showing current page
- **SVG Support**: Uses SVG images for better quality
- **SOLID Principles**: Each widget has a single responsibility

## Screens

1. **Welcome Screen**: Features the Chef-bro.svg image
2. **Ordering Screen**: Features the Order food-bro.svg image  
3. **Delivery Screen**: Features the Chef-bro.svg image

## Usage

The onboarding is automatically shown after the splash screen. Users can:
- Swipe through screens
- Use Previous/Next buttons
- Skip to login directly
- Complete onboarding to proceed to login

## Navigation

- From Splash → Onboarding
- From Onboarding → Login (when completed or skipped) 