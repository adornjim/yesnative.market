import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_spacing.dart';
import '../../models/order.dart';
import '../../providers/orders_provider.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final order = orders.firstWhere((o) => o.id == orderId, orElse: () => orders.first);
    final dateFormat = DateFormat('dd/M/yyyy, HH:mm:ss');
    final firstItem = order.items.isNotEmpty ? order.items.first.product : null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text('Order #${order.orderNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Product Summary
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: firstItem?.imageUrl != null
                      ? Image.asset(
                          firstItem!.imageUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
                AppSpacing.gapHmd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstItem?.name ?? 'Order',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Text('Store', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: order.status == OrderStatus.delivered ? Colors.green : Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            order.status.label,
                            style: TextStyle(
                              color: order.status == OrderStatus.delivered ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Divider(height: 1),
            ),
            
            // Order Progress
            const Text('Order Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            AppSpacing.gapVlg,
            _buildTimeline(context, order.status),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Divider(height: 1),
            ),
            
            // Order Summary
            const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            AppSpacing.gapVmd,
            Text('USER ID: YN-8498F4', style: TextStyle(color: Colors.grey.shade600)), // Dummy info matching reference
            const SizedBox(height: 4),
            Text('Payment: UPI (Completed)', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            Text('Order Date: ${dateFormat.format(order.date.toLocal())}', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, OrderStatus currentStatus) {
    int currentStepIndex = currentStatus.progressIndex;

    return Column(
      children: [
        _buildTimelineStep(context, 'Order Placed', 0, currentStepIndex, isFirst: true),
        _buildTimelineStep(context, 'Accepted', 1, currentStepIndex),
        _buildTimelineStep(context, 'Preparing', 2, currentStepIndex),
        _buildTimelineStep(context, 'Ready for Pickup', 3, currentStepIndex),
        _buildTimelineStep(context, 'Picked Up', 4, currentStepIndex),
        _buildTimelineStep(context, 'Out for Delivery', 5, currentStepIndex),
        _buildTimelineStep(context, 'Delivered', 6, currentStepIndex, isLast: true),
      ],
    );
  }

  Widget _buildTimelineStep(BuildContext context, String title, int stepIndex, int currentStepIndex, {bool isFirst = false, bool isLast = false}) {
    bool isCompleted = stepIndex <= currentStepIndex;
    bool isCurrent = stepIndex == currentStepIndex;
    
    Color activeColor = Theme.of(context).colorScheme.primary;
    Color inactiveColor = Colors.grey.shade400;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            // Line above
            Container(
              width: 2,
              height: 20,
              color: isFirst ? Colors.transparent : (isCompleted ? activeColor : inactiveColor),
            ),
            // Dot
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? activeColor : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? activeColor : inactiveColor,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            // Line below
            Container(
              width: 2,
              height: 30, // Connect to next step text
              color: isLast ? Colors.transparent : (stepIndex < currentStepIndex ? activeColor : inactiveColor),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                    color: isCompleted ? Theme.of(context).colorScheme.onSurface : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isCompleted ? 'Completed' : 'Pending',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey.shade200,
      child: const Icon(Icons.shopping_bag, color: Colors.grey),
    );
  }
}
