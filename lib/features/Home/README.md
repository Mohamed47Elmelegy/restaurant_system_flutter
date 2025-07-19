# Home Feature

This feature contains 3 different versions of the home screen for the restaurant system app.

## Structure

```
Home/
├── data/
│   ├── datasources/
│   │   └── home_datasource.dart
│   ├── models/
│   │   ├── category_model.dart
│   │   ├── food_item_model.dart
│   │   └── banner_model.dart
│   └── repositories/
│       └── home_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── category_entity.dart
│   │   ├── food_item_entity.dart
│   │   └── banner_entity.dart
│   ├── repositories/
│   │   └── home_repository.dart
│   └── usecases/
│       ├── get_categories_usecase.dart
│       ├── get_popular_items_usecase.dart
│       ├── get_recommended_items_usecase.dart
│       └── get_banners_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── home_bloc.dart
    │   ├── home_event.dart
    │   └── home_state.dart
    ├── pages/
    │   └── home_page.dart
    └── widgets/
        ├── home_v1.dart
        ├── home_v2.dart
        ├── home_v3.dart
        └── widgets/
            ├── category_card.dart
            ├── food_item_card.dart
            └── banner_card.dart
```

## Features

### Version 1 (HomeV1)
- Clean and simple layout
- Horizontal scrolling categories
- Banner carousel
- Popular and recommended items in horizontal lists
- Search bar in header

### Version 2 (HomeV2)
- Custom app bar with gradient
- Grid layout for categories
- Grid layout for popular items
- Banner carousel
- Different color scheme (orange theme)

### Version 3 (HomeV3)
- Hero section with gradient background
- Quick action buttons
- Horizontal scrolling categories
- Featured items in list format
- Special offers carousel
- Purple color scheme

## Usage

The home page can be accessed via the `/home` route. Users can switch between the three versions using the dropdown menu in the app bar.

## Data Flow

1. **Data Source**: `HomeDataSourceImpl` provides mock data for categories, food items, and banners
2. **Repository**: `HomeRepositoryImpl` handles data transformation and error handling
3. **Use Cases**: Individual use cases for each data type
4. **BLoC**: `HomeBloc` manages state and handles events
5. **UI**: Three different widget implementations for different layouts

## Dependencies

- `flutter_bloc` for state management
- `equatable` for value equality
- `get_it` for dependency injection

## Navigation

The home page is registered in the app router and can be navigated to using:
```dart
Navigator.pushNamed(context, AppRoutes.home);
``` 