# 🏗️ دليل البنية المعمارية - نظام القائمة

## 📋 **نظرة عامة**

هذا الدليل يشرح البنية المعمارية الكاملة لنظام القائمة، من Data Layer إلى Presentation Layer، مع شرح كل طبقة ومسؤولياتها والتحسينات المطبقة.

---

## 🔗 **العلاقة مع نظام إضافة المنتجات (Add Items System)**

### **🎯 العلاقة الأساسية:**

**`menu/`** و **`add_items/`** هما مكونان متكاملان في نظام إدارة المطعم:

#### **1. التدفق المنطقي:**
```
📝 إضافة منتج جديد (add_items/) 
    ↓
💾 حفظ في قاعدة البيانات
    ↓
📋 عرض في القائمة (menu/)
```

#### **2. المسؤوليات المتباينة:**

**`menu/` (نظام العرض):**
- ✅ **عرض المنتجات المضافة** - قائمة المنتجات
- ✅ **تصفية حسب الفئات** - تصفية وبحث
- ✅ **تعديل وحذف المنتجات** - إدارة المنتجات الموجودة
- ✅ **إدارة حالة التوفر** - تغيير حالة المنتج

**`add_items/` (نظام الإضافة):**
- ✅ **إنشاء منتجات جديدة** - نموذج تفصيلي
- ✅ **تحميل الصور** - رفع الصور
- ✅ **اختيار الفئات** - تحديد الفئات
- ✅ **إعدادات التوفر** - تحديد الحالة

#### **3. مشاركة البيانات:**

**API Endpoints المشتركة:**
- `GET /admin/products` - جلب المنتجات (menu/)
- `POST /admin/products` - إضافة منتج (add_items/)
- `PUT /admin/products/{id}` - تحديث منتج (menu/)
- `DELETE /admin/products/{id}` - حذف منتج (menu/)

**Data Models المشتركة:**
- `Product` Entity - الكيان الأساسي
- `ProductModel` - نموذج البيانات
- `ProductRepository` - واجهة المستودع

---

## 🗂️ **هيكل الملفات المحسن**

```
lib/features/admin/presentation/pages/menu/
├── data/
│   ├── models/
│   │   └── menu_item_model.dart          # Data Model
│   ├── repositories/
│   │   └── menu_repository_impl.dart     # Repository Implementation
│   └── datasources/
│       └── menu_remote_data_source.dart  # API Calls
├── domain/
│   ├── entities/
│   │   └── menu_item.dart                # Business Entity
│   ├── repositories/
│   │   └── menu_repository.dart          # Repository Interface
│   └── usecases/                         # Business Logic (محسن)
│       ├── load_menu_items_usecase.dart  # تحميل المنتجات
│       ├── load_menu_items_by_category_usecase.dart  # تحميل حسب الفئة
│       ├── search_menu_items_usecase.dart  # البحث
│       ├── delete_menu_item_usecase.dart  # حذف منتج
│       └── toggle_menu_item_availability_usecase.dart  # تغيير التوفر
└── presentation/
    ├── cubit/
    │   ├── menu_cubit.dart               # State Management (محسن)
    │   ├── menu_events.dart              # Events (محسن)
    │   └── menu_states.dart              # States (محسن)
    ├── pages/
    │   └── admin_menu_page.dart          # UI (محسن)
    └── widgets/
        ├── menu_filter_tabs.dart         # تصفية الفئات
        ├── menu_item_card.dart           # بطاقة المنتج
        └── custom_bottom_navigation.dart # التنقل السفلي
```

---

## 🗄️ **1. Domain Layer (طبقة النطاق)**

### 📊 **1.1 Business Entities**

**الملف:** `domain/entities/menu_item.dart`

```dart
class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.imagePath,
    this.description,
    this.isAvailable = true,
  });

  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviewCount;
  final String price;
  final String imagePath;
  final String? description;
  final bool isAvailable;

  // ✅ Business Logic Methods
  bool get isValid => name.isNotEmpty && price.isNotEmpty;
  String get formattedPrice => '\$$price';
  String get ratingText => '$rating (${reviewCount} reviews)';
  bool get isExpensive => double.tryParse(price) ?? 0 > 20;
  bool get isPopular => rating >= 4.0 && reviewCount >= 10;

  // ✅ Copy With Method
  MenuItem copyWith({
    String? id,
    String? name,
    String? category,
    double? rating,
    int? reviewCount,
    String? price,
    String? imagePath,
    String? description,
    bool? isAvailable,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
```

### 🔧 **1.2 Repository Interface**

**الملف:** `domain/repositories/menu_repository.dart`

```dart
abstract class MenuRepository {
  /// Get all menu items
  Future<List<MenuItem>> getMenuItems();

  /// Get menu items by category
  Future<List<MenuItem>> getMenuItemsByCategory(String category);

  /// Get a single menu item by ID
  Future<MenuItem?> getMenuItemById(String id);

  /// Add a new menu item
  Future<MenuItem> addMenuItem(MenuItem menuItem);

  /// Update an existing menu item
  Future<MenuItem> updateMenuItem(MenuItem menuItem);

  /// Delete a menu item
  Future<bool> deleteMenuItem(String id);

  /// Search menu items by name
  Future<List<MenuItem>> searchMenuItems(String query);

  /// Get available categories
  Future<List<String>> getCategories();
}
```

### 🎯 **1.3 Use Cases (محسن)**

**الملف:** `domain/usecases/load_menu_items_usecase.dart`

```dart
class LoadMenuItemsUseCase {
  final MenuRepository repository;

  LoadMenuItemsUseCase({required this.repository});

  Future<List<MenuItem>> call() async {
    try {
      return await repository.getMenuItems();
    } catch (e) {
      throw Exception('فشل في تحميل المنتجات: $e');
    }
  }
}
```

**الملف:** `domain/usecases/load_menu_items_by_category_usecase.dart`

```dart
class LoadMenuItemsByCategoryParams {
  final String category;
  const LoadMenuItemsByCategoryParams({required this.category});
}

class LoadMenuItemsByCategoryUseCase {
  final MenuRepository repository;

  LoadMenuItemsByCategoryUseCase({required this.repository});

  Future<List<MenuItem>> call(LoadMenuItemsByCategoryParams params) async {
    try {
      if (params.category.isEmpty) {
        throw Exception('اسم الفئة مطلوب');
      }
      
      return await repository.getMenuItemsByCategory(params.category);
    } catch (e) {
      throw Exception('فشل في تحميل المنتجات للفئة ${params.category}: $e');
    }
  }
}
```

**الملف:** `domain/usecases/search_menu_items_usecase.dart`

```dart
class SearchMenuItemsParams {
  final String query;
  const SearchMenuItemsParams({required this.query});
}

class SearchMenuItemsUseCase {
  final MenuRepository repository;

  SearchMenuItemsUseCase({required this.repository});

  Future<List<MenuItem>> call(SearchMenuItemsParams params) async {
    try {
      if (params.query.trim().isEmpty) {
        throw Exception('نص البحث مطلوب');
      }
      
      if (params.query.trim().length < 2) {
        throw Exception('نص البحث يجب أن يكون على الأقل حرفين');
      }
      
      return await repository.searchMenuItems(params.query.trim());
    } catch (e) {
      throw Exception('فشل في البحث عن المنتجات: $e');
    }
  }
}
```

**الملف:** `domain/usecases/delete_menu_item_usecase.dart`

```dart
class DeleteMenuItemParams {
  final String id;
  const DeleteMenuItemParams({required this.id});
}

class DeleteMenuItemUseCase {
  final MenuRepository repository;

  DeleteMenuItemUseCase({required this.repository});

  Future<bool> call(DeleteMenuItemParams params) async {
    try {
      if (params.id.isEmpty) {
        throw Exception('معرف المنتج مطلوب');
      }
      
      return await repository.deleteMenuItem(params.id);
    } catch (e) {
      throw Exception('فشل في حذف المنتج: $e');
    }
  }
}
```

**الملف:** `domain/usecases/toggle_menu_item_availability_usecase.dart`

```dart
class ToggleMenuItemAvailabilityParams {
  final String id;
  final bool isAvailable;

  const ToggleMenuItemAvailabilityParams({
    required this.id,
    required this.isAvailable,
  });
}

class ToggleMenuItemAvailabilityUseCase {
  final MenuRepository repository;

  ToggleMenuItemAvailabilityUseCase({required this.repository});

  Future<MenuItem> call(ToggleMenuItemAvailabilityParams params) async {
    try {
      if (params.id.isEmpty) {
        throw Exception('معرف المنتج مطلوب');
      }
      
      // Get current menu item
      final currentItem = await repository.getMenuItemById(params.id);
      if (currentItem == null) {
        throw Exception('المنتج غير موجود');
      }
      
      // Create updated item with new availability
      final updatedItem = currentItem.copyWith(isAvailable: params.isAvailable);
      
      // Update the item
      return await repository.updateMenuItem(updatedItem);
    } catch (e) {
      throw Exception('فشل في تغيير حالة توفر المنتج: $e');
    }
  }
}
```

---

## 📊 **2. Data Layer (طبقة البيانات)**

### 📋 **2.1 Data Models**

**الملف:** `data/models/menu_item_model.dart`

```dart
class MenuItemModel {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviewCount;
  final String price;
  final String imagePath;
  final String? description;
  final bool isAvailable;

  const MenuItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.imagePath,
    this.description,
    this.isAvailable = true,
  });

  // ✅ Factory Methods للتحويل
  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      price: json['price']?.toString() ?? '0',
      imagePath: json['image_path'] ?? '',
      description: json['description'],
      isAvailable: json['is_available'] ?? true,
    );
  }

  factory MenuItemModel.fromEntity(MenuItem entity) {
    return MenuItemModel(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      price: entity.price,
      imagePath: entity.imagePath,
      description: entity.description,
      isAvailable: entity.isAvailable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'rating': rating,
      'review_count': reviewCount,
      'price': price,
      'image_path': imagePath,
      'description': description,
      'is_available': isAvailable,
    };
  }

  MenuItem toEntity() {
    return MenuItem(
      id: id,
      name: name,
      category: category,
      rating: rating,
      reviewCount: reviewCount,
      price: price,
      imagePath: imagePath,
      description: description,
      isAvailable: isAvailable,
    );
  }
}
```

### 🔄 **2.2 Repository Implementation**

**الملف:** `data/repositories/menu_repository_impl.dart`

```dart
class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MenuItem>> getMenuItems() async {
    try {
      final menuItemModels = await remoteDataSource.getMenuItems();
      return menuItemModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get menu items: $e');
    }
  }

  @override
  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    try {
      final menuItemModels = await remoteDataSource.getMenuItemsByCategory(category);
      return menuItemModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get menu items by category: $e');
    }
  }

  @override
  Future<MenuItem?> getMenuItemById(String id) async {
    try {
      final menuItemModel = await remoteDataSource.getMenuItemById(id);
      return menuItemModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to get menu item: $e');
    }
  }

  @override
  Future<MenuItem> updateMenuItem(MenuItem menuItem) async {
    try {
      final menuItemModel = MenuItemModel.fromEntity(menuItem);
      final updatedMenuItemModel = await remoteDataSource.updateMenuItem(menuItemModel);
      return updatedMenuItemModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update menu item: $e');
    }
  }

  @override
  Future<bool> deleteMenuItem(String id) async {
    try {
      return await remoteDataSource.deleteMenuItem(id);
    } catch (e) {
      throw Exception('Failed to delete menu item: $e');
    }
  }

  @override
  Future<List<MenuItem>> searchMenuItems(String query) async {
    try {
      final menuItemModels = await remoteDataSource.searchMenuItems(query);
      return menuItemModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search menu items: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      return await remoteDataSource.getCategories();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }
}
```

---

## 🎨 **3. Presentation Layer (طبقة العرض)**

### 🎮 **3.1 Events (محسن)**

**الملف:** `presentation/bloc/menu_events.dart`

```dart
import 'package:equatable/equatable.dart';
import '../../domain/usecases/load_menu_items_by_category_usecase.dart';
import '../../domain/usecases/search_menu_items_usecase.dart';
import '../../domain/usecases/delete_menu_item_usecase.dart';
import '../../domain/usecases/toggle_menu_item_availability_usecase.dart';

// Events
abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

class LoadMenuItems extends MenuEvent {}

class LoadMenuItemsByCategory extends MenuEvent {
  final LoadMenuItemsByCategoryParams params;

  const LoadMenuItemsByCategory(this.params);

  @override
  List<Object?> get props => [params];
}

class SearchMenuItems extends MenuEvent {
  final SearchMenuItemsParams params;

  const SearchMenuItems(this.params);

  @override
  List<Object?> get props => [params];
}

class DeleteMenuItem extends MenuEvent {
  final DeleteMenuItemParams params;

  const DeleteMenuItem(this.params);

  @override
  List<Object?> get props => [params];
}

class RefreshMenuItems extends MenuEvent {}

class FilterMenuItems extends MenuEvent {
  final String filterType;
  final dynamic filterValue;

  const FilterMenuItems(this.filterType, this.filterValue);

  @override
  List<Object?> get props => [filterType, filterValue];
}

class SortMenuItems extends MenuEvent {
  final String sortBy;
  final bool ascending;

  const SortMenuItems(this.sortBy, {this.ascending = true});

  @override
  List<Object?> get props => [sortBy, ascending];
}

class LoadMenuCategories extends MenuEvent {}

class ToggleMenuItemAvailability extends MenuEvent {
  final ToggleMenuItemAvailabilityParams params;

  const ToggleMenuItemAvailability(this.params);

  @override
  List<Object?> get props => [params];
}
```

### 📊 **3.2 States (محسن)**

**الملف:** `presentation/bloc/menu_states.dart`

```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/menu_item.dart';

// States
abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuItemsLoaded extends MenuState {
  final List<MenuItem> menuItems;
  final String? selectedCategory;
  final List<String> categories;
  final String? searchQuery;
  final String? sortBy;
  final bool ascending;

  const MenuItemsLoaded(
    this.menuItems, {
    this.selectedCategory,
    this.categories = const [],
    this.searchQuery,
    this.sortBy,
    this.ascending = true,
  });

  @override
  List<Object?> get props => [
    menuItems,
    selectedCategory,
    categories,
    searchQuery,
    sortBy,
    ascending,
  ];

  MenuItemsLoaded copyWith({
    List<MenuItem>? menuItems,
    String? selectedCategory,
    List<String>? categories,
    String? searchQuery,
    String? sortBy,
    bool? ascending,
  }) {
    return MenuItemsLoaded(
      menuItems ?? this.menuItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }
}

class MenuItemDeleted extends MenuState {
  final String deletedId;
  final List<MenuItem> remainingItems;

  const MenuItemDeleted(this.deletedId, this.remainingItems);

  @override
  List<Object?> get props => [deletedId, remainingItems];
}

class MenuItemAvailabilityToggled extends MenuState {
  final String itemId;
  final bool isAvailable;

  const MenuItemAvailabilityToggled(this.itemId, this.isAvailable);

  @override
  List<Object?> get props => [itemId, isAvailable];
}

class MenuCategoriesLoaded extends MenuState {
  final List<String> categories;

  const MenuCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class MenuSearchResults extends MenuState {
  final List<MenuItem> searchResults;
  final String query;

  const MenuSearchResults(this.searchResults, this.query);

  @override
  List<Object?> get props => [searchResults, query];
}

class MenuFiltered extends MenuState {
  final List<MenuItem> filteredItems;
  final String filterType;
  final dynamic filterValue;

  const MenuFiltered(this.filteredItems, this.filterType, this.filterValue);

  @override
  List<Object?> get props => [filteredItems, filterType, filterValue];
}

class MenuSorted extends MenuState {
  final List<MenuItem> sortedItems;
  final String sortBy;
  final bool ascending;

  const MenuSorted(this.sortedItems, this.sortBy, this.ascending);

  @override
  List<Object?> get props => [sortedItems, sortBy, ascending];
}

class MenuError extends MenuState {
  final String message;
  final String? code;

  const MenuError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class MenuValidationError extends MenuState {
  final String message;

  const MenuValidationError(this.message);

  @override
  List<Object?> get props => [message];
}

class MenuAuthError extends MenuState {
  final String message;

  const MenuAuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class MenuEmpty extends MenuState {
  final String? message;
  final String? selectedCategory;

  const MenuEmpty({this.message, this.selectedCategory});

  @override
  List<Object?> get props => [message, selectedCategory];
}
```

### 🎯 **3.3 Cubit (محسن)**

**الملف:** `presentation/bloc/menu_cubit.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import '../../domain/usecases/load_menu_items_usecase.dart';
import '../../domain/usecases/load_menu_items_by_category_usecase.dart';
import '../../domain/usecases/search_menu_items_usecase.dart';
import '../../domain/usecases/delete_menu_item_usecase.dart';
import '../../domain/usecases/toggle_menu_item_availability_usecase.dart';
import 'menu_events.dart';
import 'menu_states.dart';

// Cubit
class MenuCubit extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;
  final LoadMenuItemsUseCase loadMenuItemsUseCase;
  final LoadMenuItemsByCategoryUseCase loadMenuItemsByCategoryUseCase;
  final SearchMenuItemsUseCase searchMenuItemsUseCase;
  final DeleteMenuItemUseCase deleteMenuItemUseCase;
  final ToggleMenuItemAvailabilityUseCase toggleMenuItemAvailabilityUseCase;

  MenuCubit({required this.menuRepository})
      : loadMenuItemsUseCase = LoadMenuItemsUseCase(repository: menuRepository),
        loadMenuItemsByCategoryUseCase = LoadMenuItemsByCategoryUseCase(
          repository: menuRepository,
        ),
        searchMenuItemsUseCase = SearchMenuItemsUseCase(
          repository: menuRepository,
        ),
        deleteMenuItemUseCase = DeleteMenuItemUseCase(repository: menuRepository),
        toggleMenuItemAvailabilityUseCase = ToggleMenuItemAvailabilityUseCase(
          repository: menuRepository,
        ),
        super(MenuInitial()) {
    on<LoadMenuItems>(_onLoadMenuItems);
    on<LoadMenuItemsByCategory>(_onLoadMenuItemsByCategory);
    on<SearchMenuItems>(_onSearchMenuItems);
    on<DeleteMenuItem>(_onDeleteMenuItem);
    on<RefreshMenuItems>(_onRefreshMenuItems);
    on<FilterMenuItems>(_onFilterMenuItems);
    on<SortMenuItems>(_onSortMenuItems);
    on<LoadMenuCategories>(_onLoadMenuCategories);
    on<ToggleMenuItemAvailability>(_onToggleMenuItemAvailability);
  }

  /// Get categories from repository
  Future<List<String>> getCategories() async {
    return await menuRepository.getCategories();
  }

  Future<void> _onLoadMenuItems(
    LoadMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      log('🔄 MenuCubit: Loading menu items...');
      final menuItems = await loadMenuItemsUseCase();
      final categories = await menuRepository.getCategories();

      log(
        '✅ MenuCubit: Menu items loaded successfully - ${menuItems.length} items',
      );
      log('✅ MenuCubit: Categories loaded - ${categories.length} categories');

      emit(MenuItemsLoaded(menuItems, categories: categories));
    } catch (e) {
      log('❌ MenuCubit: Failed to load menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onLoadMenuItemsByCategory(
    LoadMenuItemsByCategory event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      log(
        '🔄 MenuCubit: Loading menu items for category: ${event.params.category}',
      );
      final menuItems = await loadMenuItemsByCategoryUseCase(event.params);
      final categories = await menuRepository.getCategories();

      log(
        '✅ MenuCubit: Menu items loaded for category - ${menuItems.length} items',
      );

      if (menuItems.isEmpty) {
        emit(
          MenuEmpty(
            message: 'لا توجد منتجات في هذه الفئة',
            selectedCategory: event.params.category,
          ),
        );
      } else {
        emit(
          MenuItemsLoaded(
            menuItems,
            selectedCategory: event.params.category,
            categories: categories,
          ),
        );
      }
    } catch (e) {
      log('❌ MenuCubit: Failed to load menu items by category - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onSearchMenuItems(
    SearchMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      log(
        '🔄 MenuCubit: Searching menu items with query: ${event.params.query}',
      );
      final menuItems = await searchMenuItemsUseCase(event.params);
      log('✅ MenuCubit: Search completed - ${menuItems.length} items found');

      if (menuItems.isEmpty) {
        emit(MenuSearchResults([], event.params.query));
      } else {
        emit(MenuSearchResults(menuItems, event.params.query));
      }
    } catch (e) {
      log('❌ MenuCubit: Failed to search menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onDeleteMenuItem(
    DeleteMenuItem event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Deleting menu item with id: ${event.params.id}');
      final success = await deleteMenuItemUseCase(event.params);

      if (success) {
        log('✅ MenuCubit: Menu item deleted successfully');
        // Reload menu items after deletion
        final menuItems = await loadMenuItemsUseCase();
        emit(MenuItemDeleted(event.params.id, menuItems));
      } else {
        emit(MenuError('فشل في حذف المنتج'));
      }
    } catch (e) {
      log('❌ MenuCubit: Failed to delete menu item - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onRefreshMenuItems(
    RefreshMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      log('🔄 MenuCubit: Refreshing menu items...');
      final menuItems = await loadMenuItemsUseCase();
      final categories = await menuRepository.getCategories();

      log('✅ MenuCubit: Menu items refreshed - ${menuItems.length} items');
      emit(MenuItemsLoaded(menuItems, categories: categories));
    } catch (e) {
      log('❌ MenuCubit: Failed to refresh menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onFilterMenuItems(
    FilterMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Filtering menu items by ${event.filterType}');
      final allItems = await loadMenuItemsUseCase();
      List<MenuItem> filteredItems = [];

      switch (event.filterType) {
        case 'category':
          filteredItems = allItems
              .where((item) => item.category == event.filterValue)
              .toList();
          break;
        case 'price':
          final maxPrice = double.tryParse(event.filterValue.toString()) ?? 0.0;
          filteredItems = allItems.where((item) {
            final itemPrice = double.tryParse(item.price) ?? 0.0;
            return itemPrice <= maxPrice;
          }).toList();
          break;
        case 'availability':
          final isAvailable = event.filterValue as bool;
          filteredItems = allItems
              .where((item) => item.isAvailable == isAvailable)
              .toList();
          break;
        default:
          filteredItems = allItems;
      }

      log('✅ MenuCubit: Filtered items - ${filteredItems.length} items');
      emit(MenuFiltered(filteredItems, event.filterType, event.filterValue));
    } catch (e) {
      log('❌ MenuCubit: Failed to filter menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onSortMenuItems(
    SortMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Sorting menu items by ${event.sortBy}');
      final allItems = await loadMenuItemsUseCase();
      List<MenuItem> sortedItems = [];

      switch (event.sortBy) {
        case 'name':
          sortedItems = List.from(allItems)
            ..sort(
              (a, b) => event.ascending
                  ? a.name.compareTo(b.name)
                  : b.name.compareTo(a.name),
            );
          break;
        case 'price':
          sortedItems = List.from(allItems)
            ..sort((a, b) {
              final priceA = double.tryParse(a.price) ?? 0.0;
              final priceB = double.tryParse(b.price) ?? 0.0;
              return event.ascending
                  ? priceA.compareTo(priceB)
                  : priceB.compareTo(priceA);
            });
          break;
        case 'rating':
          sortedItems = List.from(allItems)
            ..sort(
              (a, b) => event.ascending
                  ? a.rating.compareTo(b.rating)
                  : b.rating.compareTo(a.rating),
            );
          break;
        default:
          sortedItems = allItems;
      }

      log('✅ MenuCubit: Sorted items - ${sortedItems.length} items');
      emit(MenuSorted(sortedItems, event.sortBy, event.ascending));
    } catch (e) {
      log('❌ MenuCubit: Failed to sort menu items - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onLoadMenuCategories(
    LoadMenuCategories event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Loading menu categories...');
      final categories = await menuRepository.getCategories();
      log('✅ MenuCubit: Categories loaded - ${categories.length} categories');
      emit(MenuCategoriesLoaded(categories));
    } catch (e) {
      log('❌ MenuCubit: Failed to load categories - $e');
      _handleError(e, emit);
    }
  }

  Future<void> _onToggleMenuItemAvailability(
    ToggleMenuItemAvailability event,
    Emitter<MenuState> emit,
  ) async {
    try {
      log('🔄 MenuCubit: Toggling availability for item: ${event.params.id}');
      final updatedItem = await toggleMenuItemAvailabilityUseCase(event.params);
      log('✅ MenuCubit: Availability toggled successfully');
      emit(
        MenuItemAvailabilityToggled(event.params.id, event.params.isAvailable),
      );
    } catch (e) {
      log('❌ MenuCubit: Failed to toggle availability - $e');
      _handleError(e, emit);
    }
  }

  void _handleError(dynamic error, Emitter<MenuState> emit) {
    final errorMessage = error.toString();

    if (errorMessage.contains('اسم الفئة') ||
        errorMessage.contains('نص البحث') ||
        errorMessage.contains('معرف المنتج')) {
      emit(MenuValidationError(errorMessage));
    } else if (errorMessage.contains('تسجيل الدخول') ||
        errorMessage.contains('غير مصرح')) {
      emit(MenuAuthError(errorMessage));
    } else {
      emit(MenuError(errorMessage));
    }
  }
}
```

### 🎨 **3.4 UI Components**

**الملف:** `presentation/pages/admin_menu_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/menu_events.dart';
import '../bloc/menu_states.dart';
import '../widgets/menu_filter_tabs.dart';
import '../widgets/menu_item_card.dart';
import '../bloc/menu_cubit.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/usecases/load_menu_items_by_category_usecase.dart';
import '../../domain/usecases/search_menu_items_usecase.dart';
import '../../domain/usecases/delete_menu_item_usecase.dart';
import '../../domain/usecases/toggle_menu_item_availability_usecase.dart';
import '../../../../../../../core/di/service_locator.dart';

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  State<AdminMenuPage> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  int _selectedCategoryIndex = 0;
  List<String> _categories = ['All'];
  bool _isLoadingCategories = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MenuCubit>()..add(LoadMenuItems()),
      child: BlocListener<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is MenuError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is MenuItemDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حذف المنتج بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _isLoadingCategories
                          ? const Center(child: CircularProgressIndicator())
                          : MenuFilterTabs(
                              categories: _categories,
                              selectedIndex: _selectedCategoryIndex,
                              onCategorySelected: (index) {
                                setState(() {
                                  _selectedCategoryIndex = index;
                                });
                                final cubit = context.read<MenuCubit>();
                                if (index == 0) {
                                  cubit.add(LoadMenuItems());
                                } else {
                                  cubit.add(
                                    LoadMenuItemsByCategory(
                                      LoadMenuItemsByCategoryParams(
                                        category: _categories[index],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            _buildItemsCountText(state),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: _buildMenuItemsList(state)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ... باقي الأساليب
}
```

---

## 🎯 **المزايا المحققة من التحسينات**

### ✅ **1. فصل المسؤوليات:**
- **UI**: عرض البيانات فقط
- **Cubit**: State Management
- **UseCase**: Business Logic + Validation
- **Repository**: Data Access

### ✅ **2. تحسين Error Handling:**
```dart
// ✅ معالجة أخطاء مختلفة
if (state is MenuValidationError) {
  // عرض أخطاء validation
} else if (state is MenuAuthError) {
  // عرض أخطاء authentication
} else if (state is MenuError) {
  // عرض أخطاء عامة
}
```

### ✅ **3. سهولة الاختبار:**
```dart
// ✅ يمكن اختبار UseCase منفصل
test('should load menu items by category correctly', () {
  final useCase = LoadMenuItemsByCategoryUseCase(mockRepository);
  final params = LoadMenuItemsByCategoryParams(category: 'Pizza');
  
  expect(() => useCase(params), returnsNormally);
});
```

### ✅ **4. اتباع Clean Architecture:**
```
UI → Cubit → UseCase → Repository → Model ↔ Entity
```

### ✅ **5. تقليل التكرار:**
- **قبل:** Business Logic في Cubit
- **بعد:** Business Logic في UseCase فقط

---

## 🚀 **الخلاصة**

تم تطبيق جميع التحسينات بنجاح! الآن الكود:

- ✅ **منظم ومفصل** بين الطبقات
- ✅ **سهل الاختبار** والصيانة
- ✅ **يتبع Clean Architecture**
- ✅ **يحسن تجربة المستخدم**

**المفتاح للنجاح:** اتبع Clean Architecture وفصل المسؤوليات بين الطبقات! 🚀 