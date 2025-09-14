# Restaurant System Dashboard

## Overview
This restaurant system includes a comprehensive dashboard for restaurant owners and administrators to manage their operations, track orders, and monitor performance.

## Features

### 🏠 Main Dashboard (`DashboardMain`)
- **Welcome Section**: Beautiful gradient header with restaurant branding
- **Quick Stats**: Real-time statistics for orders, revenue, and active tables
- **Quick Actions**: Easy access to main dashboard, order management, menu management, and customer support
- **Recent Activity**: Live feed of restaurant activities and events

### 📊 Full Dashboard (`SellerDashboardHome`)
- **Statistics Cards**: Visual representation of key metrics
- **Tabbed Interface**: Organized into 4 main sections:
  - **Overview**: Quick actions and recent activity
  - **Orders**: Order management with filters and lists
  - **Analytics**: Revenue charts and category analysis
  - **Settings**: Dashboard customization options
- **Charts**: Revenue trends and category distribution using fl_chart
- **Responsive Design**: Works on all screen sizes

## How to Access

### For Users
1. Navigate to the Admin section of the app
2. The dashboard is the first tab in the bottom navigation
3. Tap "Full Dashboard" to access detailed analytics

### For Developers
```dart
// Navigate to main dashboard
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const DashboardMain(),
  ),
);

// Navigate to full dashboard
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const SellerDashboardHome(),
  ),
);
```

## Technical Details

### Dependencies
- `fl_chart: ^1.0.0` - For charts and graphs
- `flutter_screenutil: ^5.9.3` - For responsive design
- `flutter_bloc: ^8.1.3` - For state management

### Architecture
- **Clean Architecture**: Follows domain-driven design principles
- **BLoC Pattern**: Uses BLoC for state management
- **Repository Pattern**: Data access through repositories
- **Dependency Injection**: Uses GetIt for service locator

## Recent Fixes

### AddressCubit Issue Resolution
**Problem**: The `AddressCubit` was registered as a `LazySingleton` in the service locator, causing "Cannot add new events after calling close" errors when navigating between pages.

**Solution**: Changed the registration from `LazySingleton` to `Factory` in `service_locator.dart`:

```dart
// Before (causing issues)
getIt.registerLazySingleton<AddressCubit>(...)

// After (fixed)
getIt.registerFactory<AddressCubit>(...)
```

**Why This Fixes It**: 
- `LazySingleton` creates one instance that persists across the app
- When navigating, the same instance is reused but may be in a "closed" state
- `Factory` creates a new instance each time, ensuring fresh state

## Customization

### Adding New Dashboard Sections
1. Create new widgets in the `presentation/widgets/` directory
2. Add them to the appropriate tab in `SellerDashboardHome`
3. Update the tab controller length if adding new tabs

### Modifying Colors and Themes
- Colors are defined in `lib/core/theme/app_colors.dart`
- Text styles are in `lib/core/theme/text_styles.dart`
- Use the existing theme system for consistency

### Adding New Statistics
1. Update the `_calculateStatistics()` method in `SellerDashboardHome`
2. Add new stat cards to the statistics section
3. Ensure data sources are properly connected

## Performance Considerations

- Dashboard loads data on initialization
- Charts are rendered efficiently using fl_chart
- Images and assets are optimized for mobile
- State management prevents unnecessary rebuilds

## Future Enhancements

- Real-time notifications for new orders
- Push notifications for urgent updates
- Export functionality for reports
- Multi-language support
- Dark/Light theme toggle
- Customizable dashboard layouts

## Troubleshooting

### Common Issues
1. **Charts not displaying**: Ensure `fl_chart` dependency is added
2. **Navigation errors**: Check that all routes are properly defined
3. **State management issues**: Verify BLoC providers are correctly set up

### Debug Mode
Enable debug logging in the dashboard by setting:
```dart
// In dashboard files
print('Debug: Loading dashboard data');
```

## Contributing

When adding new features to the dashboard:
1. Follow the existing code structure
2. Use the established theme system
3. Add proper error handling
4. Include loading states
5. Test on different screen sizes
6. Update this documentation

## Support

For technical issues or questions about the dashboard implementation, refer to the main project documentation or contact the development team.
