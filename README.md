# 🍽️ Restaurant Management System - Walima

<div align="center">
  
![Restaurant System](https://img.shields.io/badge/Walima-Restaurant%20Management%20System-orange.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)
![Laravel](https://img.shields.io/badge/Laravel-12.0-red.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**A comprehensive digital restaurant management solution with Flutter mobile app and Laravel backend**

[Features](#-features) • [Tech Stack](#-tech-stack) • [Installation](#-installation) • [API Documentation](#-api-documentation) • [Contributing](#-contributing)

</div>

---

## 📋 Project Overview

**Restaurant Management System - Walima** is a modern, full-stack solution designed to digitize restaurant operations. It combines a beautiful Flutter mobile application for customers and staff with a robust Laravel backend API and advanced admin panel.

### 🎯 Key Objectives
- **Improve customer experience** by 60% through digital ordering
- **Increase operational efficiency** by 40% through automation
- **Drive business growth** by 15% using analytical data
- **Achieve 95% order accuracy** with digital order management
- **Reach 70% customer adoption** in 6 months

---

## ✨ Features

### 📱 **Customer Mobile App (Flutter)**

#### 🔐 **Authentication & User Management**
- Secure user registration and login
- Email verification and password reset
- User profile management
- Guest browsing capabilities

#### 🍽️ **Menu & Ordering**
- **QR Code Table Scanning** - Scan table QR codes for dine-in orders
- **Digital Menu Browsing** - Beautiful, categorized menu display
- **Real-time Product Search** - Find dishes instantly
- **Shopping Cart** - Add, remove, and modify orders
- **Dual Order Types**:
  - 🏠 **Delivery Orders** - With address management and delivery fees
  - 🪑 **Dine-in Orders** - Table-based ordering with no delivery fees

#### 📊 **Order Management**
- Real-time order tracking and status updates
- Order history and reordering functionality
- Special instructions and customizations
- Push notifications for order updates

#### 🎨 **User Experience**
- **Dark/Light Theme** support
- **Responsive Design** - Works on all screen sizes
- **Skeleton Loading** - Smooth loading states
- **Offline Support** - Cache management for offline browsing
- **Multi-language Ready** - Arabic and English support

### 🖥️ **Admin Dashboard & Backend (Laravel)**

#### 📊 **Admin Panel (Filament)**
- **Product Management** - Add, edit, delete menu items
- **Order Management** - View, update, and track all orders
- **Category Management** - Organize menu categories and meal times
- **User Management** - Customer and staff account management
- **Real-time Statistics** - Revenue, orders, and performance metrics

#### 🏢 **Restaurant Operations**
- **Table Management** - QR code generation and table status tracking
- **Real-time Order Processing** - Live order updates with Pusher
- **Inventory Tracking** - Stock management and alerts
- **Staff Interface** - Kitchen and service staff dashboards

#### 🔧 **Technical Features**
- **RESTful API** - Comprehensive API for mobile app
- **Real-time Broadcasting** - Pusher integration for live updates
- **Secure Authentication** - Laravel Sanctum for API security
- **File Management** - Image upload and storage
- **Database Optimization** - Efficient queries and caching

---

## 🛠️ Tech Stack

### Frontend (Flutter)
```yaml
Framework: Flutter 3.8.1
Language: Dart
State Management: BLoC Pattern
Architecture: Clean Architecture
```

#### 📦 Key Dependencies (From actual pubspec.yaml)
- **flutter_bloc** `^8.1.3` - State management
- **dio** `^5.3.2` - HTTP client for API calls
- **hive** `^2.2.3` - Local database and caching
- **flutter_secure_storage** `^9.0.0` - Secure token storage
- **qr_code_scanner_plus** `^2.0.10+1` - QR code scanning
- **fl_chart** `^1.0.0` - Charts and analytics
- **cached_network_image** `^3.3.1` - Image caching
- **lottie** `^3.1.2` - Animations
- **connectivity_plus** `^4.0.2` - Network connectivity
- **flutter_screenutil** `^5.9.3` - Responsive design
- **bot_toast** `^4.0.0` - Notifications and messages
- **skeletonizer** `^2.1.0+1` - Loading states
- **camera** `^0.11.0+2` - Camera support

### Backend (Laravel)
```php
Framework: Laravel 12.0
Language: PHP 8.2+
Database: MySQL/PostgreSQL
Authentication: Laravel Sanctum
Admin Panel: Filament 3.x
```

#### 📦 Key Packages (From actual composer.json)
- **filament/filament** - Modern admin panel
- **laravel/sanctum** `^4.1` - API authentication
- **pusher/pusher-php-server** `^7.2` - Real-time broadcasting
- **bezhansalleh/filament-shield** `^4.0` - Role and permission management
- **spatie/laravel-permission** `^6.20` - Advanced permission system
- **leandrocfe/filament-apex-charts** `4.0.0-beta1` - Analytics charts
- **awcodes/light-switch** `^2.0` - Theme switching

---

## 📱 Screenshots

<div align="center">

| Home Screen | Menu Browsing | QR Scanning | Order Tracking |
|-------------|---------------|-------------|----------------|
| ![Home](assets/screenshots/home.png) | ![Menu](assets/screenshots/menu.png) | ![QR](assets/screenshots/qr.png) | ![Orders](assets/screenshots/orders.png) |

| Admin Dashboard | Order Management | Product Management | Analytics |
|-----------------|------------------|-------------------|-----------|
| ![Dashboard](assets/screenshots/admin-dashboard.png) | ![Admin Orders](assets/screenshots/admin-orders.png) | ![Products](assets/screenshots/products.png) | ![Analytics](assets/screenshots/analytics.png) |

</div>

---

## 🚀 Installation

### Prerequisites
- **Flutter SDK** 3.8.1 or higher
- **Dart SDK** 3.8.1 or higher  
- **PHP** 8.2 or higher
- **Composer** 2.x
- **Node.js** 16+ (for asset compilation)
- **MySQL** 8.0 or PostgreSQL 13+

### 🔧 Backend Setup (Laravel)

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/restaurant-system.git
   cd restaurant-system/Restaurant-System
   ```

2. **Install PHP dependencies**
   ```bash
   composer install
   ```

3. **Environment setup**
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

4. **Configure your `.env` file**
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=restaurant_system
   DB_USERNAME=your_username
   DB_PASSWORD=your_password
   
   # Pusher Configuration (for real-time features)
   PUSHER_APP_ID=your_app_id
   PUSHER_APP_KEY=your_app_key
   PUSHER_APP_SECRET=your_app_secret
   PUSHER_APP_CLUSTER=your_cluster
   BROADCAST_DRIVER=pusher
   ```

5. **Database setup**
   ```bash
   php artisan migrate:fresh --seed
   ```

6. **Create admin user**
   ```bash
   php artisan make:filament-user
   ```

7. **Start the server**
   ```bash
   php artisan serve
   ```

8. **Access admin panel**
   Open `http://localhost:8000/admin` in your browser

### 📱 Frontend Setup (Flutter)

1. **Navigate to Flutter project**
   ```bash
   cd ../restaurant_system_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate necessary files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Configure API endpoint**
   Update the base URL in `lib/core/network/endpoints.dart`:
   ```dart
   // Choose the appropriate URL for your testing environment:
   
   // For Android Emulator
   static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
   
   // For Real Devices (use your computer's IP)
   static const String baseUrl = 'http://192.168.1.X:8000/api/v1';
   
   // For iOS Simulator
   static const String baseUrl = 'http://127.0.0.1:8000/api/v1';
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

> 💡 **Note**: Make sure to run the Laravel server first before running the Flutter app

---

## 📖 API Documentation

### 🔐 Authentication Endpoints
```http
POST /api/v1/auth/register     # User registration
POST /api/v1/auth/login        # User login
GET  /api/v1/user              # Get current user (requires token)
GET  /api/test                 # API health check
```

### 🍽️ Menu & Products (From actual endpoints.dart)
```http
# Public customer endpoints (no token required)
GET /api/v1/menu/meal-times           # Get meal times
GET /api/v1/menu/categories           # Get categories
GET /api/v1/menu/products             # Get products

# Public browsing endpoints (no token required)
GET /api/v1/public/meal-times         # Get meal times
GET /api/v1/public/meal-times/current # Get current meal time
GET /api/v1/public/categories         # Get categories
GET /api/v1/public/products           # Get products
GET /api/v1/public/products/recommended  # Get recommended products
GET /api/v1/public/products/popular   # Get popular products
GET /api/v1/public/products/new       # Get new products
```

### 🛒 Shopping Cart (requires token)
```http
GET    /api/v1/cart               # View shopping cart
POST   /api/v1/cart/items         # Add item to cart
PUT    /api/v1/cart/items/{item}  # Update cart item
DELETE /api/v1/cart/items/{item}  # Remove item from cart
DELETE /api/v1/cart/clear         # Clear cart
```

### 🪑 Table Management
```http
GET  /api/v1/tables/qr/{qrCode}       # Get table by QR code
POST /api/v1/tables/{table}/occupy    # Occupy table
```

### 📦 Order Management (requires token)
```http
GET    /api/v1/orders                 # Get user orders
POST   /api/v1/orders/place           # Place order (dine-in or delivery)
GET    /api/v1/orders/{order}         # Get order details
DELETE /api/v1/orders/{order}/cancel  # Cancel order
POST   /api/v1/orders/{order}/mark-paid  # Mark order as paid
```

### 🔧 Admin Endpoints (requires admin role)
```http
# Product Management
GET    /api/v1/admin/products         # List products
POST   /api/v1/admin/products         # Create product
PUT    /api/v1/admin/products/{id}    # Update product
DELETE /api/v1/admin/products/{id}    # Delete product

# Order Management
GET    /api/v1/admin/orders           # List all orders
PUT    /api/v1/admin/orders/{id}/status  # Update order status
GET    /api/v1/admin/dashboard/statistics  # Dashboard statistics
```

> 📚 **Full API Documentation**: See [Restaurant-System/README_API.md](Restaurant-System/README_API.md) for complete details.

---

## 🏗️ Project Architecture

### Flutter App Structure (From actual project)
```
lib/
├── core/                    # Core functionality
│   ├── config/             # App configuration
│   ├── constants/          # App constants
│   ├── di/                 # Dependency Injection
│   ├── entities/           # Domain entities
│   ├── network/            # Network layer and endpoints.dart
│   ├── routes/             # App routing
│   ├── services/           # Core services
│   ├── theme/              # App theming
│   ├── utils/              # Utility functions
│   └── widgets/            # Reusable widgets
├── features/               # Feature modules (Clean Architecture)
│   ├── auth/               # Authentication (login/register)
│   ├── Home/               # Home screen
│   ├── menu/               # Menu browsing
│   ├── cart/               # Shopping cart
│   ├── orders/             # Order management with REFACTORING_SUMMARY.md
│   ├── admin/              # Admin features (dashboard, products, categories)
│   ├── address/            # Address management
│   ├── checkout/           # Checkout process
│   ├── OnBoarding/         # Onboarding screens
│   ├── splash/             # Splash screen
│   └── settings/           # App settings
└── main.dart               # App entry point (Restaurant System)
```

### Laravel Backend Structure (From actual project)
```
Restaurant-System/
├── app/
│   ├── Filament/           # Admin panel resources (Filament)
│   │   ├── Resources/      # ProductResource, OrderResource, etc.
│   │   └── Widgets/        # RestaurantStatsWidget
│   ├── Http/Controllers/   # API controllers
│   ├── Models/             # Eloquent models (Product, Order, User)
│   └── Services/           # Business logic
├── database/
│   ├── migrations/         # Database migrations
│   └── seeders/           # Data seeders
├── routes/
│   ├── api.php            # API routes (v1 prefix)
│   └── web.php            # Web routes
├── config/                # Configuration files
│   ├── broadcasting.php   # Pusher settings
│   └── sanctum.php        # Authentication settings
└── composer.json          # PHP dependencies
```

### Advanced Features
- **Clean Architecture** in Flutter with separated Data/Domain/Presentation layers
- **BLoC Pattern** for state management
- **Repository Pattern** for data access
- **Filament Admin Panel** for comprehensive management
- **Real-time Updates** with Pusher
- **Multi-language Support** (Arabic and English)

---

## 🔧 Configuration

### 📱 Mobile App Configuration

1. **API Configuration** (`lib/core/config/api_config.dart`)
2. **Theme Configuration** (`lib/core/theme/app_theme.dart`)
3. **Route Configuration** (`lib/core/routes/app_routes.dart`)

### 🖥️ Backend Configuration

1. **Database Configuration** (`.env` and `config/database.php`)
2. **Pusher Configuration** (`.env` and `config/broadcasting.php`)
3. **Filament Configuration** (`app/Providers/Filament/AdminPanelProvider.php`)

---

## 🧪 Testing

### Flutter Tests
```bash
cd restaurant_system_flutter
flutter test
```

### Laravel Tests
```bash
cd Restaurant-System
php artisan test
```

---

## 🚀 Deployment

### Mobile App Deployment
1. **Android**: `flutter build apk --release`
2. **iOS**: `flutter build ios --release`

### Backend Deployment
1. Configure production environment
2. Set up SSL certificates
3. Configure domain and hosting
4. Set up database and Redis
5. Configure Pusher for production

---

## 📄 Documentation

- 📱 [Flutter Setup Guide](FLUTTER_SETUP_STEPS.md)
- 🖥️ [Laravel Setup Guide](LARAVEL_SETUP_STEPS.md)
- 🔄 [Real-time Features Setup](REALTIME_ORDERS_SETUP.md)
- 📊 [Dashboard Documentation](restaurant_system_flutter/DASHBOARD_README.md)
- 🛠️ [Development Guide](DEVELOPER_BRAIN_LIGHT_CONTENT.md)
- 🎯 [Project Management](PROJECT_MANAGEMENT_TEMPLATE.md)
- 📋 [Orders Refactoring Summary](restaurant_system_flutter/lib/features/orders/REFACTORING_SUMMARY.md)
- 🔧 [Pusher Setup Guide](PUSHER_CREDENTIALS_GUIDE.md)

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Development Guidelines
- Follow Flutter and Laravel best practices
- Write tests for new features
- Update documentation as needed
- Use meaningful commit messages

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Team

- **Frontend Developer** - Flutter Mobile App
- **Backend Developer** - Laravel API & Admin Panel  
- **UI/UX Designer** - App Design & User Experience
- **Project Manager** - Coordination & Planning

---

## 🎉 Acknowledgments

- Flutter team for the amazing framework
- Laravel team for the robust backend framework
- Filament team for the beautiful admin panel
- Pusher for real-time functionality
- All contributors and testers

---

<div align="center">

**⭐ Star this repository if you find it helpful!**

Made with ❤️ by the Restaurant System Team - Walima

</div>
