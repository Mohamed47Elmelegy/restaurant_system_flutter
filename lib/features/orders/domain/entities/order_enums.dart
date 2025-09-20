/// Order Type Enum (Updated)
enum OrderType { dineIn, delivery, pickup }

/// Order Status Enum (Updated)
enum OrderStatus {
  // common
  pending,
  confirmed,
  paid,
  cancelled,

  // preparing & serving
  preparing,
  readyToServe,
  served,

  // pickup
  readyForPickup,
  pickedUp,

  // delivery
  onTheWay,
  delivered,

  // after-service
  completed,
  refunded,
}

/// Payment Status Enum
enum PaymentStatus { unpaid, paid, refunded }
