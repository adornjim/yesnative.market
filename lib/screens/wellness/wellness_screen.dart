import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_spacing.dart';
import '../../providers/products_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/daily_tip_card.dart';
import '../../widgets/wellness_streak.dart';
import '../../widgets/wellness_quiz.dart';

class WellnessScreen extends ConsumerStatefulWidget {
  const WellnessScreen({super.key});

  @override
  ConsumerState<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends ConsumerState<WellnessScreen> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Wellness Hub'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WellnessStreak(),
            AppSpacing.gapVlg,
            const DailyTipCard(),
            AppSpacing.gapVlg,
            const WellnessQuiz(),
            AppSpacing.gapVlg,
            
            Text(
              "Explore by Category",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ).animate().fadeIn(),
            AppSpacing.gapVmd,
            
            // Categories Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildCategoryCard('weight-management', 'Weight Management', '2 Products', Icons.monitor_weight_outlined),
                _buildCategoryCard('daily-energy', 'Daily Energy', '1 Product', Icons.bolt),
                _buildCategoryCard('kids-nutrition', 'Kids Nutrition', '1 Product', Icons.child_care),
                _buildCategoryCard('womens-wellness', 'Women\'s Wellness', '1 Product', Icons.auto_awesome),
                _buildCategoryCard('family-health', 'Family Health', '2 Products', Icons.people_outline),
                _buildCategoryCard('natural-nourishment', 'Natural Nourishment', '1 Product', Icons.eco_outlined),
              ],
            ).animate().fadeIn().slideY(begin: 0.1),
            
            if (_selectedCategory != null) ...[
              AppSpacing.gapVxl,
              Text(
                "Products for you",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ).animate().fadeIn(),
              AppSpacing.gapVmd,
              _buildFilteredProducts(),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String id, String title, String subtitle, IconData icon) {
    final isSelected = _selectedCategory == id;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = isSelected ? null : id;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: AppSpacing.edgeInsetsMd,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
             color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
             width: 2,
          ),
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
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary, size: 28),
            ),
            AppSpacing.gapVmd,
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredProducts() {
    final products = ref.watch(productsByCategoryProvider(_selectedCategory ?? 'all'));
    
    if (products.isEmpty) {
      return const Center(child: Text("No products found for this category."));
    }

    return SizedBox(
      height: 300, 
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (context, index) => AppSpacing.gapHmd,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 200, 
            child: ProductCard(product: products[index], index: index),
          );
        },
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }
}
