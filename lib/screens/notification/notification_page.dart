import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.notifications_active),
            title: Text("Order Confirmed"),
            subtitle: Text("Your order has been placed successfully."),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_shipping),
            title: Text("Order Shipped"),
            subtitle: Text("Your product is on the way."),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.discount),
            title: Text("New Offer"),
            subtitle: Text("Get 20% off on millet products."),
          ),
        ],
      ),
    );
  }
}
