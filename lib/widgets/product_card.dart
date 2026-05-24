import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'gradient_image_placeholder.dart';
import 'glass_card.dart';

import 'package:flutter_animate/flutter_animate.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback? onViewDetails;
  final int index;

  const ProductCard({
    super.key,
    required this.product,
    this.onViewDetails,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatCurrency = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image 
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: product.imageUrl != null 
                  ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => _buildPlaceholder(context),
                    )
                  : _buildPlaceholder(context),
            ),
          ),
          
          // Content
          Expanded(
            flex: 6,
            child: Padding(
              padding: AppSpacing.edgeInsetsMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Scrollable Middle Section (Text, Rating, Benefits)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category
                          Text(
                            product.category.toUpperCase().replaceAll('-', ' '),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              letterSpacing: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AppSpacing.gapVsm,
                          
                          // Product Name
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AppSpacing.gapVsm,
                          
                          // Rating
                          Row(
                            children: [
                              Icon(Icons.star, size: 14, color: Theme.of(context).colorScheme.secondary),
                              AppSpacing.gapHsm,
                              Text(
                                '${product.rating} (${product.reviews})',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.gapVsm,
                          
                          // Benefits
                          ...product.benefits.take(2).map((benefit) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check_circle, size: 14, color: Theme.of(context).colorScheme.primary),
                                AppSpacing.gapHsm,
                                Expanded(
                                  child: Text(
                                    benefit,
                                    style: Theme.of(context).textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  
                  AppSpacing.gapVsm,
                  
                  // Bottom Pinned Section (Price & Add to Cart)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency.format(product.price),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(cartNotifierProvider.notifier).addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: Icon(Icons.shopping_cart, color: Theme.of(context).colorScheme.surface, size: 18),
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.all(8),
                          minimumSize: const Size(36, 36),
                        ),
                      ).animate(target: 1).scaleXY(end: 1, duration: 200.ms, curve: Curves.easeOutBack),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 50).ms, duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOutQuad);
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (product.imageUrl != null) {
      return Image.asset(
        product.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    
    return GradientImagePlaceholder(
      child: Center(
        child: Icon(Icons.shopping_bag_outlined, size: 48, color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
      ),
    );
  }
}
