import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class WellnessScreen extends ConsumerWidget {
  const WellnessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Wellness Goals'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero
            Container(
              width: double.infinity,
              padding: AppSpacing.edgeInsetsLg,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                children: [
                  Text(
                    'Find Your Perfect Wellness Solution',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.surface),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.gapVmd,
                  const Text(
                    'Discover targeted nutrition blends formulated to support your specific health objectives.',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Categories Grid
            Padding(
              padding: AppSpacing.edgeInsetsLg,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _buildCategoryCard(context, 'Weight Management', '2 Products', Icons.monitor_weight_outlined),
                  _buildCategoryCard(context, 'Daily Energy', '1 Product', Icons.bolt),
                  _buildCategoryCard(context, 'Kids Nutrition', '1 Product', Icons.child_care),
                  _buildCategoryCard(context, 'Women\'s Wellness', '1 Product', Icons.auto_awesome),
                  _buildCategoryCard(context, 'Family Health', '2 Products', Icons.people_outline),
                  _buildCategoryCard(context, 'Natural Nourishment', '1 Product', Icons.eco_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, String subtitle, IconData icon) {
    return InkWell(
      onTap: () => context.go('/shop'),
      child: Container(
        padding: AppSpacing.edgeInsetsMd,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: AppSpacing.edgeInsetsSm,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
            ),
            AppSpacing.gapVmd,
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVsm,
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}


