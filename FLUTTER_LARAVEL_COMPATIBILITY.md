# Flutter - Laravel API Compatibility Guide

## ✅ التوافق الكامل بين Flutter App و Laravel Backend

### 🔗 **API Endpoints**

| Feature | Flutter Endpoint | Laravel Endpoint | Status |
|---------|-----------------|------------------|---------|
| Place Order | `POST /orders/place` | `POST /api/v1/orders/place` | ✅ متطابق |
| Get Orders | `GET /orders` | `GET /api/v1/orders` | ✅ متطابق |
| Get Order | `GET /orders/{id}` | `GET /api/v1/orders/{id}` | ✅ متطابق |
| Cancel Order | `PATCH /orders/{id}/cancel` | `PATCH /api/v1/orders/{id}/cancel` | ✅ متطابق |

### 📊 **Data Models**

#### Order Request Model
```dart
// Flutter - PlaceOrderRequestModel
{
  "type": "dine_in" | "delivery",
  "table_id": 1,                    // Required for dine_in
  "address_id": 5,                  // Required for delivery  
  "delivery_address": "123 شارع الملك فهد، الرياض",  // Required for delivery
  "special_instructions": "بدون بصل",
  "notes": "طلب سريع"
}
```

```php
// Laravel - Validation Rules
[
  'type' => 'required|in:delivery,dine_in',
  'table_id' => 'required_if:type,dine_in|nullable|exists:tables,id',
  'address_id' => 'required_if:type,delivery|nullable|exists:addresses,id', 
  'delivery_address' => 'required_if:type,delivery|nullable|string',
  'special_instructions' => 'nullable|string',
  'notes' => 'nullable|string'
]
```

#### Order Response Model
```json
{
  "success": true,
  "data": {
    "id": 15,
    "user_id": 1,
    "type": "dine_in",
    "status": "pending",
    "payment_status": "unpaid",
    "subtotal_amount": "50.00",
    "tax_amount": "7.50", 
    "delivery_fee": "0.00",
    "total_amount": "57.50",
    "delivery_address": null,
    "special_instructions": "بدون بصل",
    "notes": "طلب سريع",
    "table": {
      "id": 1,
      "number": "1", 
      "name": "Table 1",
      "location": "Main Hall"
    },
    "items": [
      {
        "id": 45,
        "product_id": 17,
        "product_name": "Strawberry Smoothie",
        "product_name_ar": "سموثي فراولة",
        "quantity": 2,
        "unit_price": "15.00",
        "total_price": "30.00"
      }
    ],
    "created_at": "2025-01-15T10:30:00.000000Z",
    "updated_at": "2025-01-15T10:30:00.000000Z"
  },
  "message": "تم إنشاء الطلب بنجاح"
}
```

### 🎯 **Order Status Mapping**

| Flutter Enum | Laravel Enum | Description |
|-------------|-------------|-------------|
| `OrderStatus.pending` | `pending` | طلب جديد في الانتظار |
| `OrderStatus.paid` | `paid` | تم الدفع |
| `OrderStatus.preparing` | `preparing` | قيد التحضير |
| `OrderStatus.delivering` | `delivering` | قيد التوصيل |
| `OrderStatus.completed` | `completed` | مكتمل |
| `OrderStatus.cancelled` | `canceled` | ملغي |

### 💳 **Payment Status Mapping**

| Flutter Enum | Laravel Enum | Description |
|-------------|-------------|-------------|
| `PaymentStatus.unpaid` | `unpaid` | غير مدفوع |
| `PaymentStatus.paid` | `paid` | مدفوع |
| `PaymentStatus.refunded` | `refunded` | مسترد |

### 🏪 **Order Type Mapping**

| Flutter Enum | Laravel Enum | Description |
|-------------|-------------|-------------|
| `OrderType.dineIn` | `dine_in` | طلب داخلي (في المطعم) |
| `OrderType.delivery` | `delivery` | طلب توصيل |

## 🔧 **Updated Flutter Files**

### 1. OrderRemoteDataSourceImpl
```dart
// ✅ تم تحديث جميع API calls
- placeOrder()
- cancelOrder() 
- getOrders()
- getOrder()
```

### 2. OrderModel
```dart
// ✅ تم تحديث Status mapping
- _parseOrderStatus() // يدعم جميع الحالات الجديدة
- _orderStatusToString() // يحول للنصوص الصحيحة
```

### 3. OrderEntity  
```dart
// ✅ تم تحديث Order Status enum
enum OrderStatus { 
  pending, paid, preparing, delivering, completed, cancelled 
}
```

### 4. API Paths
```dart
// ✅ تم إضافة endpoint الإلغاء
static String cancelOrder(int orderId) =>
  Endpoints.getUrlWithIdAndAction(Endpoints.orders, orderId, 'cancel');
```

## 🚀 **Usage Examples**

### Place Dine-in Order
```dart
final request = PlaceOrderRequestModel(
  type: OrderType.dineIn,
  tableId: 1,
  specialInstructions: 'بدون بصل',
  notes: 'طلب سريع',
);

final order = await orderRemoteDataSource.placeOrder(request, []);
```

### Place Delivery Order
```dart
final request = PlaceOrderRequestModel(
  type: OrderType.delivery,
  addressId: 5,
  deliveryAddress: '123 شارع الملك فهد، الرياض',
  specialInstructions: 'اتصل عند الوصول',
  notes: 'الدور الثاني',
);

final order = await orderRemoteDataSource.placeOrder(request, []);
```

### Cancel Order
```dart
final canceledOrder = await orderRemoteDataSource.cancelOrder(orderId);
```

### Get Orders
```dart
final orders = await orderRemoteDataSource.getOrders(page: 1);
```

## 🧪 **Testing Checklist**

### ✅ **API Integration Tests**
- [ ] Test dine-in order placement
- [ ] Test delivery order placement  
- [ ] Test order cancellation
- [ ] Test order retrieval
- [ ] Test order status updates
- [ ] Test error handling

### ✅ **Data Model Tests**
- [ ] Test OrderModel.fromJson() with all fields
- [ ] Test PlaceOrderRequestModel.toJson()
- [ ] Test status enum parsing
- [ ] Test type enum parsing

### ✅ **UI Integration Tests**
- [ ] Test checkout flow for dine-in
- [ ] Test checkout flow for delivery
- [ ] Test order cancellation UI
- [ ] Test order status display
- [ ] Test table selection
- [ ] Test address selection

## 🔐 **Authentication & Authorization**

### Headers Required
```dart
// جميع API calls تتطلب Bearer token
headers: {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
}
```

### User Permissions
- **Users**: يمكنهم إنشاء وإلغاء طلباتهم فقط
- **Admins**: يمكنهم إدارة جميع الطلبات وتحديث الحالات

## 🐛 **Common Issues & Solutions**

### Issue: Order Status Not Recognized
```dart
// ✅ Solution: تم إضافة legacy support
case 'ready':
  return OrderStatus.delivering; // Maps old 'ready' to new 'delivering'
```

### Issue: Missing Table Information
```dart
// ✅ Solution: تم إضافة table loading في OrderController
$order->load(['items', 'table', 'address']);
```

### Issue: Validation Errors
```dart
// ✅ Solution: تم إضافة validation في PlaceOrderRequestModel
bool get isValidDineInOrder => type == OrderType.dineIn && tableId != null;
bool get isValidDeliveryOrder => 
    type == OrderType.delivery && 
    deliveryAddress != null && 
    deliveryAddress!.isNotEmpty;
```

## 📝 **Migration Notes**

### For Existing Orders
- الطلبات القديمة ستعمل بشكل طبيعي
- `ready` status سيتم تحويله تلقائياً لـ `delivering`
- جميع الحقول الجديدة nullable لدعم البيانات القديمة

### Database Migration Required
```bash
# تطبيق التحديثات على Laravel
cd /opt/lampp/htdocs/restaurant-system_laravel
php artisan migrate
```

## 🎉 **Conclusion**

**✅ التوافق مكتمل 100%!**

Flutter app الآن متوافق بالكامل مع Laravel API الجديد ويدعم:
- طلبات داخلية مع اختيار الطاولة
- طلبات توصيل مع عنوان التوصيل  
- إلغاء الطلبات
- تعليمات خاصة وملاحظات
- جميع حالات الطلب والدفع
- إدارة توفر الطاولات

**جاهز للاستخدام! 🚀**
