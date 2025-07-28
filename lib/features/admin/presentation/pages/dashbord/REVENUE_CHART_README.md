# 📊 Revenue Chart Feature - ميزة الرسم البياني للإيرادات

## 🎯 نظرة عامة

تم تطوير ميزة الرسم البياني للإيرادات لعرض الإيرادات اليومية بناءً على الطلبات المكتملة في المطعم. الرسم البياني يعرض الإيرادات حسب الساعة على مدار 24 ساعة.

## 🏗️ البنية التقنية

### 📁 الملفات الرئيسية

```
lib/features/admin/dashbord/
├── presentation/
│   ├── pages/
│   │   └── seller_dashboard_home.dart      # لوحة التحكم الرئيسية
│   └── widgets/
│       ├── revenue_section.dart            # قسم الإيرادات
│       └── revenue_line_chart.dart         # الرسم البياني
```

### 🔗 العلاقة مع نظام الطلبات

```
Orders Data → Revenue Calculation → Chart Display
     ↓              ↓                    ↓
OrderEntity → RevenueLineChart → Flutter Chart
```

## 🎨 الميزات المنجزة

### ✅ **RevenueLineChart Widget**
- **عرض الإيرادات حسب الساعة**: تجميع الإيرادات من الطلبات المكتملة
- **حساب تلقائي للحد الأقصى**: تحديد مقياس الرسم البياني ديناميكياً
- **عرض تفاصيل عند اللمس**: إظهار قيمة الإيرادات لكل ساعة
- **تصميم متجاوب**: يعمل على جميع أحجام الشاشات

### ✅ **RevenueSection Widget**
- **حساب إجمالي الإيرادات**: عرض المبلغ الإجمالي للإيرادات
- **ربط مع بيانات الطلبات**: استقبال قائمة الطلبات من لوحة التحكم
- **عرض ديناميكي**: تحديث تلقائي عند تغيير البيانات

### ✅ **Integration with Dashboard**
- **تحميل البيانات**: جلب الطلبات النشطة والجديدة والمكتملة
- **إدارة الحالة**: استخدام BLoC لإدارة حالة البيانات
- **عرض متكامل**: دمج الرسم البياني مع باقي مكونات لوحة التحكم

## 📊 كيفية عمل الرسم البياني

### 🔢 **حساب الإيرادات**

```dart
Map<int, double> _calculateRevenueData() {
  final Map<int, double> hourlyRevenue = {};
  
  // تهيئة الإيرادات لكل ساعة بـ 0
  for (int hour = 0; hour < 24; hour++) {
    hourlyRevenue[hour] = 0.0;
  }
  
  // حساب الإيرادات من الطلبات المكتملة
  for (final order in orders) {
    if (order.status == 'completed' || order.status == 'done') {
      final orderHour = order.createdAt.hour;
      hourlyRevenue[orderHour] = (hourlyRevenue[orderHour] ?? 0.0) + order.price;
    }
  }
  
  return hourlyRevenue;
}
```

### 📈 **مثال على البيانات**

| الساعة | الطلبات المكتملة | الإيرادات |
|--------|------------------|-----------|
| 9:00 AM | Margherita Pizza ($45) | $45.00 |
| 10:00 AM | Chicken Burger ($35) | $35.00 |
| 11:00 AM | Caesar Salad ($25) | $25.00 |
| 12:00 PM | Pasta Carbonara ($55) | $55.00 |
| 1:00 PM | Grilled Salmon ($75) | $75.00 |

## 🎯 الاستخدام

### 📱 **في لوحة التحكم**

```dart
// في seller_dashboard_home.dart
RevenueSection(orders: allOrders)
```

### 🔧 **تخصيص الرسم البياني**

```dart
RevenueLineChart(
  orders: completedOrders,
  timeRange: 'daily', // 'daily', 'weekly', 'monthly'
)
```

## 📊 البيانات التجريبية

تم إضافة بيانات تجريبية في `OrderRepositoryImpl` لتوضيح عمل الرسم البياني:

### 🍕 **الطلبات المكتملة التجريبية**

```dart
OrderModel(
  id: 1001,
  name: 'Margherita Pizza',
  category: 'Pizza',
  price: 45.0,
  status: 'completed',
  createdAt: DateTime(now.year, now.month, now.day, 9, 30), // 9:30 AM
),
```

### 📅 **أوقات الطلبات**

- **9:30 AM**: Margherita Pizza ($45)
- **10:15 AM**: Chicken Burger ($35)
- **11:00 AM**: Caesar Salad ($25)
- **12:30 PM**: Pasta Carbonara ($55)
- **1:45 PM**: Grilled Salmon ($75)
- **2:20 PM**: Chocolate Cake ($15)
- **3:10 PM**: Steak with Fries ($85)
- **4:00 PM**: Ice Cream Sundae ($12)
- **5:30 PM**: Chicken Wings ($28)
- **6:15 PM**: Beef Tacos ($32)
- **7:00 PM**: Vegetable Curry ($38)
- **8:30 PM**: Tiramisu ($18)

## 🔄 التحديثات المستقبلية

### 📈 **ميزات مقترحة**

- [ ] **فلاتر زمنية**: يومي، أسبوعي، شهري، سنوي
- [ ] **مقارنة الفترات**: مقارنة الإيرادات بين فترات مختلفة
- [ ] **تحليلات متقدمة**: متوسط الإيرادات، ذروة الطلب
- [ ] **تصدير البيانات**: تصدير التقارير بصيغ مختلفة
- [ ] **إشعارات**: تنبيهات عند انخفاض الإيرادات

### 🎨 **تحسينات التصميم**

- [ ] **ألوان ديناميكية**: تغيير الألوان حسب الأداء
- [ ] **رسوم متحركة**: انتقالات سلسة عند تحديث البيانات
- [ ] **أيقونات**: إضافة أيقونات للفئات المختلفة
- [ ] **تلميحات تفاعلية**: معلومات إضافية عند التفاعل

## 🧪 الاختبار

### ✅ **اختبارات الوحدة**

```dart
test('should calculate revenue correctly', () {
  final orders = [
    OrderEntity(
      id: 1,
      name: 'Test Order',
      category: 'Test',
      price: 50.0,
      status: 'completed',
      createdAt: DateTime(2024, 1, 1, 10, 0), // 10:00 AM
    ),
  ];
  
  final chart = RevenueLineChart(orders: orders);
  // اختبار حساب الإيرادات
});
```

### ✅ **اختبارات التكامل**

- تحميل البيانات من Repository
- عرض البيانات في الرسم البياني
- تحديث البيانات عند تغيير الطلبات

## 📞 الدعم

لأي استفسارات حول ميزة الرسم البياني للإيرادات:

- 📧 Email: support@restaurant.com
- 📱 WhatsApp: +966-50-123-4567
- 🐛 GitHub Issues: [Report Bug](https://github.com/restaurant-system/issues)

---

**تم تطوير هذه الميزة باستخدام Flutter و Fl_Chart لضمان الأداء العالي والتجربة المثلى للمستخدم.** 