import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/order.dart';
import 'products_provider.dart';
import '../core/api/api_client.dart';

class OrdersNotifier extends Notifier<List<Order>> {
  @override
  List<Order> build() {
    _loadOrders();
    return [];
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
                id: 'unknown',
                name: bi['productName'] ?? 'Unknown Product',
                price: (bi['price'] ?? 0).toDouble(),
                category: '',
                description: '',
                imageUrl: '',
                tags: [],
                benefits: [],
                ingredients: [],
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
        return OrderStatus.pending;
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
        return OrderStatus.pending;
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
