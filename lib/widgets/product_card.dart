import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'gradient_image_placeholder.dart';

import 'package:flutter_animate/flutter_animate.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback? onViewDetails;

  const ProductCard({
    super.key,
    required this.product,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatCurrency = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
                              color: AppColors.accentGold,
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
                              const Icon(Icons.star, size: 14, color: AppColors.accentGold),
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
                                const Icon(Icons.check_circle, size: 14, color: AppColors.primaryGreen),
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
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(cartNotifierProvider.notifier).addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              backgroundColor: AppColors.primaryGreen,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart, color: AppColors.white, size: 18),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
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
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOutQuad);
  }

  Widget _buildPlaceholder(BuildContext context) {
    return GradientImagePlaceholder(
      child: Center(
        child: Text(
          product.name[0],
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.primaryGreen.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
