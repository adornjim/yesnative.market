import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../providers/products_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/product_card.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistIds = ref.watch(wishlistProvider);
    final allProducts = ref.watch(productsProvider);
    final favoritedProducts = allProducts.where((p) => wishlistIds.contains(p.id)).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: favoritedProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
                  AppSpacing.gapVlg,
                  Text('No favorites yet', style: Theme.of(context).textTheme.headlineSmall),
                  AppSpacing.gapVsm,
                  const Text('Browse products and tap ♡ to save them here.'),
                ],
              ),
            )
          : GridView.builder(
              padding: AppSpacing.edgeInsetsLg,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.58,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favoritedProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: favoritedProducts[index]);
              },
            ),
    );
  }
}
