import 'package:first_app/models/grocery_item.dart';

class OrderItem {
  final GroceryItem item;
  final int count;

  const OrderItem({
    required this.item,
    required this.count,
  });

  double get totalPrice => item.price * count;
}

enum OrderStatus {
  confirmed,
  preparing,
  outForDelivery,
  delivered,
}

class BookingOrder {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  final String deliveryAddress;
  final String deliverySlot;
  final String paymentMethod;
  final DateTime orderDate;
  final OrderStatus status;

  BookingOrder({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.deliverySlot,
    required this.paymentMethod,
    required this.orderDate,
    this.status = OrderStatus.confirmed,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.confirmed:
        return 'Booking Confirmed';
      case OrderStatus.preparing:
        return 'Packing Groceries';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }
}
