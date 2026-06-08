import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:firebase_auth/firebase_auth.dart';

import '../models/order.dart';
import '../models/product.dart';
import 'products_provider.dart';
import '../core/api/api_client.dart';

class OrdersNotifier extends Notifier<List<Order>> {
  IO.Socket? _socket;

  @override
  List<Order> build() {
    _loadOrders();
    _initSocket();
    return [];
  }

  void _initSocket() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _socket = IO.io('http://localhost:3000', IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .build());

    _socket!.onConnect((_) {
      print('Connected to Socket.io');
      _socket!.emit('join_user_room', user.uid);
    });

    _socket!.on('order_updated', (data) {
      print('Order updated in real-time: $data');
      _loadOrders(); // Refresh orders list instantly
    });
  }

  Future<void> _loadOrders() async {
    try {
      final data = await ApiClient.get('/orders/me');
      final allProducts = ref.read(productsProvider);
      
      final List<Order> orders = (data as List).map((item) {
          // Map backend items to OrderItems
          final backendItems = item['items'] as List<dynamic>? ?? [];
          final orderItems = backendItems.map((bi) {
            final product = allProducts.firstWhere(
              (p) => p.name == bi['productName'],
              orElse: () => Product(
                id: -1,
                name: bi['productName'] ?? 'Unknown Product',
                price: (bi['price'] ?? 0).toDouble(),
                category: '',
                description: '',
                imageUrl: '',
                benefits: [],
                rating: 0.0,
                reviews: 0,
              ),
            );
            return OrderItem(
              product: product,
              quantity: bi['quantity'] ?? 1,
            );
          }).toList();

          return Order(
            id: item['_id'],
            orderNumber: item['orderId'],
            date: DateTime.parse(item['createdAt']),
            status: _parseStatus(item['status']),
            totalAmount: (item['total'] ?? 0).toDouble(),
            items: orderItems,
            addressId: item['address'] ?? '',
          );
        }).toList();

        // Sort orders by date descending
        orders.sort((a, b) => b.date.compareTo(a.date));
        state = orders;
    } catch (e) {
      print('Failed to load orders: $e');
    }
  }

  OrderStatus _parseStatus(String? status) {
    switch (status) {
      case 'pending':
        return OrderStatus.orderPlaced;
      case 'confirmed':
      case 'processing':
        return OrderStatus.preparing;
      case 'shipped':
        return OrderStatus.outForDelivery;
      case 'delivered':
      case 'completed':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.orderPlaced;
    }
  }

  Future<void> placeOrder(
    List<OrderItem> items, 
    double totalAmount, 
    {
      String address = '',
      String customerName = '',
      String customerPhone = '',
    }
  ) async {
    try {
      final backendItems = items.map((i) => {
        'productName': i.product.name,
        'quantity': i.quantity,
        'price': i.product.price,
      }).toList();

      final res = await ApiClient.post('/orders', {
        'items': backendItems,
        'total': totalAmount,
        'address': address,
        'customerName': customerName,
        'customerPhone': customerPhone,
      });

      // Reload orders after successful placement
      await _loadOrders();
    } catch (e) {
      print('Order error: $e');
    }
  }
}

final ordersProvider = NotifierProvider<OrdersNotifier, List<Order>>(() {
  return OrdersNotifier();
});
