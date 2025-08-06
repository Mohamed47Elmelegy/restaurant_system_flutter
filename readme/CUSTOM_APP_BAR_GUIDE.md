# Custom App Bar Guide - Restaurant System

## 🎯 Overview

تم إنشاء Custom App Bar Widget يتطابق مع الصورة المطلوبة ويحتوي على ثلاثة أقسام:

1. **Menu/Drawer Icon** - زر القائمة على اليسار
2. **Delivery Address** - عنوان التوصيل في الوسط
3. **Shopping Cart with Badge** - سلة التسوق مع البادج على اليمين

## 🏗️ المكونات

### AppBarHelper Class
تم إضافة الدالة الجديدة `createCustomAppBar` في `lib/core/utils/app_bar_helper.dart`:

```dart
static Widget createCustomAppBar({
  required VoidCallback onMenuPressed,
  required VoidCallback onAddressPressed,
  required VoidCallback onCartPressed,
  required String deliveryAddress,
  int cartItemCount = 0,
  Color? backgroundColor,
})
```

### المكونات الفرعية

#### 1. Menu Button (`_buildMenuButton`)
- أيقونة القائمة في دائرة رمادية فاتحة
- يستخدم `AppIcons.menu` من الأصول
- قابل للتخصيص عبر `onMenuPressed`

#### 2. Address Section (`_buildAddressSection`)
- يعرض "DELIVER TO" باللون البرتقالي
- يعرض العنوان الحالي مع أيقونة السهم للأسفل
- قابل للتخصيص عبر `onAddressPressed`

#### 3. Cart Button (`_buildCartButton`)
- أيقونة السلة في دائرة رمادية داكنة
- بادج برتقالي يعرض عدد العناصر
- يستخدم `AppIcons.shoppingBag` من الأصول

## 📱 كيفية الاستخدام

### الاستخدام الأساسي

```dart
AppBarHelper.createCustomAppBar(
  onMenuPressed: () {
    // فتح القائمة الجانبية
    Scaffold.of(context).openDrawer();
  },
  onAddressPressed: () {
    // اختيار عنوان التوصيل
    _showAddressDialog(context);
  },
  onCartPressed: () {
    // فتح سلة التسوق
    _showCartDialog(context);
  },
  deliveryAddress: 'Halal Lab office',
  cartItemCount: 2,
)
```

### الاستخدام في صفحة كاملة

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom App Bar
          AppBarHelper.createCustomAppBar(
            onMenuPressed: () => Scaffold.of(context).openDrawer(),
            onAddressPressed: () => _handleAddressSelection(),
            onCartPressed: () => _handleCartPress(),
            deliveryAddress: 'Halal Lab office',
            cartItemCount: 2,
          ),
          
          // Page Content
          Expanded(
            child: YourPageContent(),
          ),
        ],
      ),
    );
  }
}
```

### الاستخدام مع State Management

```dart
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String currentAddress = 'Halal Lab office';
  int cartItemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarHelper.createCustomAppBar(
            onMenuPressed: _handleMenu,
            onAddressPressed: _handleAddress,
            onCartPressed: _handleCart,
            deliveryAddress: currentAddress,
            cartItemCount: cartItemCount,
          ),
          Expanded(child: YourContent()),
        ],
      ),
    );
  }

  void _handleAddress() {
    // تحديث العنوان
    setState(() {
      currentAddress = 'New Address';
    });
  }

  void _addToCart() {
    setState(() {
      cartItemCount++;
    });
  }
}
```

## 🎨 التخصيص

### تغيير الألوان

```dart
AppBarHelper.createCustomAppBar(
  // ... other parameters
  backgroundColor: Colors.white, // لون خلفية App Bar
)
```

### تغيير عدد عناصر السلة

```dart
AppBarHelper.createCustomAppBar(
  // ... other parameters
  cartItemCount: 5, // عدد العناصر في السلة
)
```

### تغيير العنوان

```dart
AppBarHelper.createCustomAppBar(
  // ... other parameters
  deliveryAddress: 'Home Address', // عنوان التوصيل
)
```

## 📁 الملفات المحدثة

1. **`lib/core/utils/app_bar_helper.dart`**
   - إضافة `createCustomAppBar` method
   - إضافة `_buildMenuButton` method
   - إضافة `_buildAddressSection` method
   - إضافة `_buildCartButton` method

2. **`lib/core/widgets/custom_app_bar_demo.dart`** (جديد)
   - مثال بسيط لاستخدام Custom App Bar

3. **`lib/core/widgets/custom_app_bar_usage_example.dart`** (جديد)
   - مثال متقدم مع State Management

## 🔧 المتطلبات

### الأصول المطلوبة
- `assets/icons/menu.svg` - أيقونة القائمة
- `assets/icons/shopping-bag.svg` - أيقونة السلة

### المكتبات المطلوبة
- `flutter_screenutil` - للاستجابة
- `AppColors.lightPrimary` - للون البرتقالي

## 🎯 المميزات

### ✅ المميزات المطبقة
- ✅ تصميم مطابق للصورة المطلوبة
- ✅ ثلاثة أقسام منفصلة: Menu, Address, Cart
- ✅ بادج برتقالي لعدد العناصر في السلة
- ✅ قابل للتخصيص بالكامل
- ✅ يدعم State Management
- ✅ يستخدم الأصول الموجودة في المشروع
- ✅ متجاوب مع أحجام الشاشات المختلفة

### 🎨 التصميم
- **Menu Button**: دائرة رمادية فاتحة مع أيقونة القائمة
- **Address Section**: "DELIVER TO" برتقالي + العنوان + سهم للأسفل
- **Cart Button**: دائرة رمادية داكنة مع أيقونة السلة البيضاء + بادج برتقالي

## 🚀 الاستخدام السريع

```dart
// في أي صفحة
AppBarHelper.createCustomAppBar(
  onMenuPressed: () => print('Menu pressed'),
  onAddressPressed: () => print('Address pressed'),
  onCartPressed: () => print('Cart pressed'),
  deliveryAddress: 'Your Address',
  cartItemCount: 3,
)
```

## 📝 ملاحظات مهمة

1. **الأيقونات**: تأكد من وجود الأيقونات في مجلد `assets/icons/`
2. **الألوان**: يستخدم `AppColors.lightPrimary` للون البرتقالي
3. **الاستجابة**: يستخدم `flutter_screenutil` للاستجابة
4. **التفاعل**: جميع الأزرار قابلة للتخصيص عبر callbacks

## 🔄 التحديثات المستقبلية

- إضافة دعم للوضع المظلم
- إضافة المزيد من خيارات التخصيص
- إضافة animations للتفاعلات
- دعم RTL للغة العربية 