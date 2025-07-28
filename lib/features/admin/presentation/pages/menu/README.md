# Menu Management UI - Clean Architecture

This module provides a modern, clean UI for managing restaurant menu items following Clean Architecture principles.

## 🏗️ Architecture Overview

### Domain Layer (Core Business Logic)
- **MenuItem Entity** (`domain/entities/menu_item.dart`)
  - Lightweight data structure
  - Core business rules
  - No dependencies on external layers

- **MenuRepository Interface** (`domain/repositories/menu_repository.dart`)
  - Abstract contract for data operations
  - Defines all menu-related operations

### Data Layer (Data Management)
- **MenuItemModel** (`data/models/menu_item_model.dart`)
  - Extends entity with data transformation logic
  - JSON serialization/deserialization
  - Business logic methods (validation, formatting)
  - Conversion between entity and model

- **MenuRepositoryImpl** (`data/repositories/menu_repository_impl.dart`)
  - Concrete implementation of repository interface
  - Handles data operations and model conversions
  - In-memory storage (can be replaced with API/database)

### Presentation Layer (UI)
- **AdminMenuPage**: Main page with state management
- **Custom Widgets**: Reusable UI components
- **State Management**: Local state for filtering and navigation

## 🎨 UI Components

### Custom Widgets

1. **MenuFilterTabs** (`widgets/menu_filter_tabs.dart`)
   - Horizontal scrollable filter tabs
   - Categories: All, Breakfast, Lunch, Dinner
   - Active state with orange underline indicator
   - Smooth category switching

2. **MenuItemCard** (`widgets/menu_item_card.dart`)
   - Clean card layout for food items
   - Food image with fallback icon
   - Category tag with orange background
   - Star rating with review count
   - Price display with "Pick UP" text
   - Options menu (edit/delete) with vertical dots

3. **CustomBottomNavigation** (`widgets/custom_bottom_navigation.dart`)
   - Custom bottom navigation bar
   - Prominent add button in center
   - Grid, Menu, Notifications, Profile icons
   - Active state highlighting

### Main Page Features

- **Header**: Back button and "My Food List" title
- **Filter Tabs**: Category-based filtering
- **Item Count**: Shows total filtered items
- **Menu List**: Scrollable list of food items
- **Bottom Navigation**: Custom navigation with add button

## 🎯 Features

### Data Management
- **Entity**: Lightweight data structure
- **Model**: Rich data with business logic
- **Repository**: Data operations and persistence
- **Type Safety**: Strong typing throughout

### Business Logic (in Model)
- **Validation**: `isValid` property
- **Formatting**: `formattedPrice`, `ratingText`
- **Categorization**: `categoryDisplayName`
- **Analysis**: `isExpensive`, `isPopular`

### Filtering & Search
- Filter by category (All, Breakfast, Lunch, Dinner)
- Dynamic item count display
- Search functionality (name and category)
- Smooth category switching

### Item Management
- View menu items with details
- Edit items (placeholder functionality)
- Delete items with confirmation dialog
- Item selection handling

### Navigation
- Back navigation
- Bottom navigation with add button
- Add new item navigation

## 🎨 Design System

### Colors
- Primary: Orange (`AppColors.lightPrimary`)
- Background: White
- Text: Black and grey variants
- Accents: Red for ratings, grey for secondary text

### Typography
- Title: 20px, bold
- Item names: 16px, semi-bold
- Prices: 16px, bold
- Secondary text: 12-14px, regular

### Spacing
- Consistent 16px padding
- 12px item spacing
- 4px micro spacing

## 🚀 Usage

```dart
// Navigate to menu page
Navigator.pushNamed(context, AppRoutes.adminMenu);

// The page handles all interactions internally
```

## 🔧 Clean Architecture Benefits

### Separation of Concerns
- **Entity**: Pure data structure
- **Model**: Business logic and data transformation
- **Repository**: Data operations
- **UI**: Presentation only

### Testability
- Each layer can be tested independently
- Mock repositories for UI testing
- Business logic isolated in models

### Maintainability
- Clear dependencies between layers
- Easy to modify business logic
- Scalable architecture

### Flexibility
- Easy to swap data sources
- Can add caching layer
- Can implement different UI patterns

## 🔧 Customization

### Adding New Categories
1. Update `_categories` list in `AdminMenuPage`
2. Add corresponding menu items with new category
3. Update `categoryDisplayName` in model if needed

### Modifying Item Card
1. Edit `MenuItemCard` widget
2. Update `MenuItemModel` business logic if needed
3. Adjust styling in widget

### Changing Colors
1. Update `AppColors` constants
2. Modify widget color references
3. Test light/dark theme compatibility

## 📱 Responsive Design

- Horizontal scrolling for filter tabs
- Flexible card layout
- Adaptive bottom navigation
- Safe area handling

## 🔄 State Management

- Local state for selected category
- Local state for bottom navigation
- Menu items list management
- Filtered items computation

## 🎯 Future Enhancements

- [ ] BLoC/Cubit state management
- [ ] API integration
- [ ] Local database (SQLite/Hive)
- [ ] Image upload/management
- [ ] Offline support
- [ ] Real-time updates
- [ ] Advanced filtering
- [ ] Bulk operations
- [ ] Analytics integration 