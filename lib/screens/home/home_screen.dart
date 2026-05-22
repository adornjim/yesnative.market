import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/products_provider.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: CustomScrollView(
        slivers: [
          // Announcement Bar
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: const Text(
                'Traditional Wellness for Modern Living • Clean Label Millet Nutrition',
                style: TextStyle(color: AppColors.white, fontSize: 12),
              ),
            ),
          ),
          
          // AppBar
          SliverAppBar(
            backgroundColor: AppColors.white,
            pinned: true,
            title: const Text('YES NATIVE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
          
          SliverList(
            delegate: SliverChildListDelegate([
              _buildHeroSection(context),
              _buildFeaturedProducts(context, ref),
              _buildFinalCTA(context),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.white, AppColors.warmBeige],
        ),
      ),
      padding: AppSpacing.edgeInsetsLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rooted in Tradition',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.accentGold,
              letterSpacing: 2,
            ),
          ),
          AppSpacing.gapVsm,
          Text(
            'Functional Superfoods Built for Modern Lifestyles',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          AppSpacing.gapVmd,
          Text(
            'Clean-label, millet-based nutrition designed to support your specific wellness goals—from weight management to daily energy.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[700],
            ),
          ),
          AppSpacing.gapVlg,
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.go('/shop'),
                  child: const Text('Shop Products'),
                ),
              ),
              AppSpacing.gapHmd,
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go('/wellness'),
                  child: const Text('Explore Wellness'),
                ),
              ),
            ],
          ),
          AppSpacing.gapVxl,
        ],
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, curve: Curves.easeOutBack),
    );
  }

  Widget _buildFeaturedProducts(BuildContext context, WidgetRef ref) {
    // Just grab the first 4 products for featured
    final allProducts = ref.watch(productsProvider);
    final featured = allProducts.take(4).toList();

    return Padding(
      padding: AppSpacing.edgeInsetsLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Featured Products', style: Theme.of(context).textTheme.headlineMedium),
          AppSpacing.gapVlg,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: featured.length,
            itemBuilder: (context, index) {
              return ProductCard(product: featured[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFinalCTA(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
      ),
      child: Column(
        children: [
          Text(
            'Bring Traditional Wellness Back Into Everyday Life',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.white,
            ),
          ),
          AppSpacing.gapVlg,
          ElevatedButton(
            onPressed: () => context.go('/shop'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGold,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Shop Now'),
          ),
        ],
      ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
    );
  }
}
