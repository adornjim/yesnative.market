import 'dart:convert';
import 'product.dart';

enum OrderStatus {
  orderPlaced,
  accepted,
  preparing,
  readyForPickup,
  pickedUp,
  outForDelivery,
  delivered,
  cancelled
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.orderPlaced:
        return 'Order Placed';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.readyForPickup:
        return 'Ready for Pickup';
      case OrderStatus.pickedUp:
        return 'Picked Up';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  int get progressIndex {
    switch (this) {
      case OrderStatus.orderPlaced:
        return 0;
      case OrderStatus.accepted:
        return 1;
      case OrderStatus.preparing:
        return 2;
      case OrderStatus.readyForPickup:
        return 3;
      case OrderStatus.pickedUp:
        return 4;
      case OrderStatus.outForDelivery:
        return 5;
      case OrderStatus.delivered:
        return 6;
      case OrderStatus.cancelled:
        return -1;
    }
  }
}

class OrderItem {
  final Product product;
  final int quantity;

  const OrderItem({
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'product': product.id, // For a real app, we'd store just the ID and fetch, but for this we'll store full JSON or reconstruct. 
      // Actually, since we're using shared preferences, it's safer to store the product id and quantity.
      // But we'll just encode the product id and quantity for simplicity.
      'productId': product.id,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map, List<Product> allProducts) {
    final product = allProducts.firstWhere(
      (p) => p.id == map['productId'],
      orElse: () => allProducts.first,
    );
    return OrderItem(
      product: product,
      quantity: map['quantity']?.toInt() ?? 1,
    );
  }
}

class Order {
  final String id;
  final String orderNumber;
  final DateTime date;
  final OrderStatus status;
  final double totalAmount;
  final List<OrderItem> items;
  final String addressId; // Optional link to address

  const Order({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.totalAmount,
    required this.items,
    this.addressId = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'date': date.millisecondsSinceEpoch,
      'status': status.index,
      'totalAmount': totalAmount,
      'items': items.map((x) => x.toMap()).toList(),
      'addressId': addressId,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, List<Product> allProducts) {
    return Order(
      id: map['id'] ?? '',
      orderNumber: map['orderNumber'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      status: OrderStatus.values[map['status'] ?? 0],
      totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
      items: List<OrderItem>.from(map['items']?.map((x) => OrderItem.fromMap(x, allProducts)) ?? []),
      addressId: map['addressId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source, List<Product> allProducts) => Order.fromMap(json.decode(source), allProducts);
}
