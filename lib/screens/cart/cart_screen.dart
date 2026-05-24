import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/gradient_image_placeholder.dart';
import '../../widgets/glass_card.dart';

import 'package:flutter_animate/flutter_animate.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartNotifierProvider);
    final total = ref.watch(cartTotalProvider);
    final count = ref.watch(cartCountProvider);
    final formatCurrency = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          if (cartItems.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Cart?'),
                    content: const Text('Are you sure you want to remove all items from your cart?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(cartNotifierProvider.notifier).clearCart();
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(foregroundColor: AppColors.error),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
              label: const Text('Clear', style: TextStyle(color: AppColors.error)),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Theme.of(context).colorScheme.surfaceContainerHighest, Theme.of(context).colorScheme.surfaceContainerHighest],
                      ),
                    ),
                    child: Icon(Icons.shopping_bag_outlined, size: 48, color: Theme.of(context).colorScheme.primary),
                  ),
                  AppSpacing.gapVlg,
                  Text('Your Cart is Empty', style: Theme.of(context).textTheme.headlineSmall),
                  AppSpacing.gapVsm,
                  const Text('Looks like you haven\'t added anything yet.'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: AppSpacing.edgeInsetsMd,
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) => AppSpacing.gapVmd,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Dismissible(
                        key: ValueKey(item.product.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: AppSpacing.edgeInsetsHlg,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.surface),
                        ),
                        onDismissed: (direction) {
                          ref.read(cartNotifierProvider.notifier).removeFromCart(item.product.id);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: AppSpacing.edgeInsetsSm,
                          child: Row(
                            children: [
                              // Image
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: item.product.imageUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(item.product.imageUrl!, fit: BoxFit.cover),
                                      )
                                    : GradientImagePlaceholder(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Center(
                                          child: Text(
                                            item.product.name[0],
                                            style: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), fontSize: 24, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                              ),
                              AppSpacing.gapHmd,
                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: Theme.of(context).textTheme.titleMedium,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    AppSpacing.gapVsm,
                                    Text(
                                      formatCurrency.format(item.product.price),
                                      style: Theme.of(context).textTheme.labelLarge,
                                    ),
                                  ],
                                ),
                              ),
                              // Quantity Controls
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 16),
                                      onPressed: () => ref.read(cartNotifierProvider.notifier).updateQuantity(item.product.id, item.quantity - 1),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 16),
                                      onPressed: () => ref.read(cartNotifierProvider.notifier).updateQuantity(item.product.id, item.quantity + 1),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: (index * 100).ms, duration: 400.ms).slideX(begin: 0.1, curve: Curves.easeOutQuad);
                    },
                  ),
                ),
                
                // Order Summary
                GlassCard(
                  padding: AppSpacing.edgeInsetsLg,
                  borderRadius: 24,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal', style: TextStyle(color: Colors.grey)),
                            Text(formatCurrency.format(total)),
                          ],
                        ),
                        AppSpacing.gapVsm,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Shipping', style: TextStyle(color: Colors.grey)),
                            Text('FREE', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total ($count items)', style: Theme.of(context).textTheme.titleLarge),
                            Text(
                              formatCurrency.format(total),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                        AppSpacing.gapVmd,
                        ElevatedButton(
                          onPressed: cartItems.isEmpty ? null : () => context.go('/checkout'),
                          style: ElevatedButton.styleFrom(
                            padding: AppSpacing.edgeInsetsVmd,
                          ),
                          child: const Text('Proceed to Checkout'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}



