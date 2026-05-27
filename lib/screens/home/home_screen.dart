import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_spacing.dart';
import '../../providers/products_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/home_hero_carousel.dart';
import '../../widgets/app_logo.dart';
import '../notification/notification_page.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Announcement Bar
          SliverSafeArea(
            bottom: false,
            sliver: SliverToBoxAdapter(
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                child: Text(
                  'Traditional Wellness for Modern Living • Clean Label Millet Nutrition',
                  style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 12),
                ),
              ),
            ),
          ),
          
          // AppBar
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            pinned: true,
            title: AppLogo(size: 20, color: Theme.of(context).colorScheme.primary),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => context.go('/search'),
              ),
              IconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_none),
                    Positioned(
                      right: -1,
                      top: -1,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationPage()),
                ),
                tooltip: 'Notifications',
              ),
            ],
          ),
          
          SliverList(
            delegate: SliverChildListDelegate([
              const HomeHeroCarousel(),
              _buildFeaturedProducts(context, ref),
              _buildFinalCTA(context),
            ]),
          ),
        ],
      ),
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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Column(
        children: [
          Text(
            'Bring Traditional Wellness Back Into Everyday Life',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          AppSpacing.gapVlg,
          ElevatedButton(
            onPressed: () => context.go('/shop'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.surface,
            ),
            child: Text('Shop Now'),
          ),
        ],
      ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
    );
  }
}


