import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/order.dart';
import '../models/product.dart';
import 'products_provider.dart';

class OrdersNotifier extends Notifier<List<Order>> {
  static const _storageKey = 'user_orders';
  final _uuid = const Uuid();

  @override
  List<Order> build() {
    _loadOrders();
    return [];
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? ordersJson = prefs.getString(_storageKey);
    final allProducts = ref.read(productsProvider);
    
    if (ordersJson != null) {
      final List<dynamic> decodedList = json.decode(ordersJson);
      final List<Order> orders = decodedList.map((item) => Order.fromMap(item, allProducts)).toList();
      // Sort orders by date descending
      orders.sort((a, b) => b.date.compareTo(a.date));
      state = orders;
    } else {
      // Add a dummy order for demonstration if empty
      if (allProducts.isNotEmpty) {
        final dummyOrder = Order(
          id: _uuid.v4(),
          orderNumber: 'NRK2026051300005',
          date: DateTime.now().subtract(const Duration(hours: 2)),
          status: OrderStatus.preparing,
          totalAmount: 598.50,
          items: [
            OrderItem(product: allProducts[0], quantity: 1),
            if (allProducts.length > 1) OrderItem(product: allProducts[1], quantity: 2),
          ],
        );
        state = [dummyOrder];
        _saveOrders([dummyOrder]);
      }
    }
  }

  Future<void> _saveOrders(List<Order> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = json.encode(orders.map((o) => o.toMap()).toList());
    await prefs.setString(_storageKey, encodedList);
  }

  Future<void> placeOrder(List<OrderItem> items, double totalAmount, {String addressId = ''}) async {
    final now = DateTime.now();
    final String orderNum = 'NRK${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecondsSinceEpoch.toString().substring(8)}';
    
    final newOrder = Order(
      id: _uuid.v4(),
      orderNumber: orderNum,
      date: now,
      status: OrderStatus.paymentConfirmed, // New orders start as confirmed
      totalAmount: totalAmount,
      items: items,
      addressId: addressId,
    );

    final newState = [newOrder, ...state];
    state = newState;
    await _saveOrders(newState);
  }
}

final ordersProvider = NotifierProvider<OrdersNotifier, List<Order>>(() {
  return OrdersNotifier();
});
